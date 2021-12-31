package aeons.events;

/**
 * `Event` base class.
 */
 @:autoBuild(aeons.core.Macros.buildEvent())
class Event {
  /**
   * The type of event as a string.
   */
  public var type(default, null) = '';

  /**
   * True if the event has been canceled inside a handler.
   */
  public var canceled = false;

  /**
   * Private constructor. Events should be used with pooling.
   */
  function new() {}

  /**
   * Used to reset object pooled events.
   */
  public function put() {
    canceled = false;
  }
}