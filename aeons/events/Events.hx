package aeons.events;

interface Events {
  /**
   * Add an event handler.
   * @param type The type of event the handler is for.
   * @param callback The function to call when an event is triggered.
   * @param canCancel If true the callback can cancel the event so it doesn't trigger handlers lower in the list.
   * @param priority Higher priority handlers are called first.
   * @param isGlobal Is this a global or scene event.
   */
  function on<T: Event>(type: EventType<T>, callback: (T)->Void, canCancel: Bool = true, priority: Int = 0,
    isGlobal: Bool = false): Void;

  /**
   * Remove an event handler.
   * @param type The type of event the handler is for.
   * @param callback The callback function to find the handler with. 
   * @param isGlobal Is this a global or scene handler.
   */
  function off<T: Event>(type: EventType<T>, callback: (T)->Void, isGlobal: Bool = false): Void;

  /**
   * Check if a handler for an event exists.
   * @param type The type of event to check.
   * @param isGlobal Is this a global or scene handler.
   * @param callback The callback function to check if you want to check for a specific handler.
   * @return True if the handler exists.
   */
  function has<T: Event>(type: EventType<T>, isGlobal: Bool = false, ?callback: (T)->Void): Bool;

  /**
   * Emit an event to all handlers. Events get put back into the pool automatically after the emit.
   * @param event The event to emit.
   */
  function emit(event: Event): Void;

  @:dox(hide)
  function pushSceneList(): Void;

  @:dox(hide)
  function popSceneList(): Void;

  @:dox(hide)
  function replaceSceneList(index: Int): Void;

  @:dox(hide)
  function resetIndex(): Void;

  @:dox(hide)
  function setIndex(index: Int): Void;
}
