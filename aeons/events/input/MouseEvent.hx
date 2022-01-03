package aeons.events.input;
/**
 * `MouseEvent` for sending mouse input events.
 */
class MouseEvent extends Event {
  /**
   * Mouse down event type.
   */
  public static inline final MOUSE_DOWN: EventType<MouseEvent> = 'phantom_mouse_down';

  /**
   * Mouse up event type.
   */
  public static inline final MOUSE_UP: EventType<MouseEvent> = 'phantom_mouse_up';

  /**
   * Mouse move event type.
   */
  public static inline final MOUSE_MOVE: EventType<MouseEvent> = 'phantom_mouse_move';

  /**
   * Mouse scroll event type.
   */
  public static inline final MOUSE_SCROLL: EventType<MouseEvent> = 'phantom_mouse_scroll';

  /**
   * Mouse leave event type.
   */
  public static inline final MOUSE_LEAVE: EventType<MouseEvent> = 'phantom_mouse_leave';

  /**
   * The button pressed.
   */
  var button: Int;

  /**
   * The x position of the mouse in window pixels.
   */
  var x: Int;

  /**
   * The y position of the mouse in window pixels.
   */
  var y: Int;

  /**
   * The amount moved on the x axis since the last event in window pixels.
   */
  var deltaX: Int;

  /**
   * The amount moved on the y axis since the last even in window pixels.
   */
  var deltaY: Int;

  /**
   * The scroll wheel direction. -1 is up. 1 is down.
   */
  var scrollDirection: Int;

  /**
   * Has the cursor left the window.
   */
  var leave: Bool;
}