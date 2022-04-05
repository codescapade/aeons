package aeons.events;

/**
 * A EventHandler is used to store callbacks for when the event is triggered. 
 */
class EventHandler {
  /**
   * The function to call when the event is triggered.
   */
  public final callback: (Dynamic)->Void;

  /**
   * If true this callback can cancel an event.
   */
  public final canCancel: Bool;

  /**
   * The priority of the handler. Higher is called first.
   */
  public final priority: Int;

  /**
   * EventHandler constructor.
   * @param callback The function to call when the event is triggered.
   * @param canCancel Can the callback cancel an event.
   * @param priority The handler priority.
   */
  public function new(callback: (Dynamic)->Void, canCancel: Bool, priority: Int) {
    this.callback = callback;
    this.canCancel = canCancel;
    this.priority = priority;
  }
}