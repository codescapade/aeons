package aeons.events.services;

/**
 * The EventEmitter handles game and scene wide events.
 */
@:dox(hide)
class InternalEvents implements Events {
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

  /**
   * Push a new event list on the events stack.
   */
  public function pushSceneList() {
    sceneHandlers.push(new Map<String, Array<EventHandler>>());
    sceneIndex++;
  }

  /**
   * Pop the top most list from the event stack.
   */
  public function popSceneList() {
    sceneHandlers.pop().clear();
    sceneIndex--;
  }

  /**
   * Replace a scene list at a specific index.
   * @param index The list index.
   */
  public function replaceSceneList(index: Int) {
    sceneHandlers[index].clear();
  }

  /**
   * Reset the scene index for when replacing all scenes.
   */
  public function resetIndex() {
    sceneIndex = -1;
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
}
