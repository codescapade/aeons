package aeons.events;

/**
 * The `EventEmitter` handles game and scene wide events.
 */
class EventEmitter {
  /**
   * Events that persist between scenes. Don't add handlers to this that are in scenes because they will be removed
   * when changing scenes.
   */
  final globalHandlers = new Map<String, Array<EventHandler>>();

  /**
   * Handlers per scene. This is an array because you can push and pop scenes on the stack. Each scene has their own
   * handler list.
   */
  final sceneHandlers: Array<Map<String, Array<EventHandler>>> = [];

  /**
   * This scene index mirrors the game scene index to get the correct handlers for the active scene.
   */
  var sceneIndex = -1;

  /**
   * EventEmitter constructor.
   */
  public function new() {}

  /**
   * Add an event handler.
   * @param type The type of event the handler is for.
   * @param callback The function to call when an event is triggered.
   * @param canCancel If true the callback can cancel the event so it doesn't trigger handlers lower in the list.
   * @param priority Higher priority handlers are called first.
   * @param isGlobal Is this a global or scene event.
   */
  public function on<T: Event>(type: EventType<T>, callback: (T)->Void, canCancel = true, priority = 0,
      isGlobal = false) {
    final handler = new EventHandler(callback, canCancel, priority);
    final handlers = isGlobal ? globalHandlers : sceneHandlers[sceneIndex];

    if (handlers[type] == null) {
      handlers[type] = [handler];
    } else {
      handlers[type].unshift(handler);
    }

    // Sort the handlers by priority.
    handlers[type].sort((a: EventHandler, b: EventHandler) -> {
      if (a.priority < b.priority) {
        return 1;
      } else if (a.priority > b.priority) {
        return -1;
      }

      return 0;
    });
  }

  /**
   * Remove an event handler.
   * @param type The type of event the handler is for.
   * @param callback The callback function to find the handler with. 
   * @param isGlobal Is this a global or scene handler.
   */
  public function off<T: Event>(type: EventType<T>, callback: (T)->Void, isGlobal = false) {
    final handlers = isGlobal ? globalHandlers[type] : sceneHandlers[sceneIndex][type];

    if (handlers != null) {
      for (handler in handlers) {
        if (handler.callback == callback) {
          handlers.remove(handler);
          break;
        }
      }
    }
  }

  /**
   * Check if a handler for an event exists.
   * @param type The type of event to check.
   * @param isGlobal Is this a global or scene handler.
   * @param callback The callback function to check if you want to check for a specific handler.
   * @return True if the handler exists.
   */
  public function has<T: Event>(type: EventType<T>, isGlobal = false, ?callback: (T)->Void): Bool {
    final handlers = isGlobal ? globalHandlers[type] : sceneHandlers[sceneIndex][type];

    // No handlers for this event.
    if (handlers == null) {
      return false;
    }

    // Does any handler for this event exist.
    if (callback == null) {
      return handlers.length > 0;
    } else {
      // Does a specific handler for this event exist.
      for (handler in handlers) {
        if (handler.callback == callback) {
          return true;
        }
      }
    }

    return false;
  }

  /**
   * Emit an event to all handlers. Events get put back into the pool automatically after the emit.
   * @param event The event to emit.
   */
  public function emit(event: Event) {
    // Global handlers are always triggered first.
    var handlers = globalHandlers[event.type];
    if (handlers != null) {
      processHandlers(event, handlers);
    }

    if (event.canceled) {
      event.put();
      return;
    }

    handlers = sceneHandlers[sceneIndex][event.type];
    if (handlers != null) {
      processHandlers(event, handlers);
    }

    event.put();
  }

  function processHandlers(event: Event, handlers: Array<EventHandler>) {
    for (handler in handlers) {
      handler.callback(event);

      // Check if this handler can cancel an event. Stop the loop if it can.
      if (event.canceled) {
        if (handler.canCancel) {
          break;
        } else {
          event.canceled = false;
        }
      }
    }
  }

  @:allow(aeons.core.Game)
  function pushSceneList() {
    sceneHandlers.push(new Map<String, Array<EventHandler>>());
    sceneIndex++;
  }

  @:allow(aeons.core.Game)
  function popSceneList() {
    sceneHandlers.pop().clear();
    sceneIndex--;
  }

  @:allow(aeons.core.Game)
  function resetIndex() {
    sceneIndex = -1;
  }
}