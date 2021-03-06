package aeons.events.input;

/**
 * MouseEvent for sending mouse input events.
 */
class MouseEvent extends Event {
  /**
   * Mouse down event type.
   */
  public static inline final MOUSE_DOWN: EventType<MouseEvent> = 'aeons_mouse_down';

  /**
   * Mouse up event type.
   */
  public static inline final MOUSE_UP: EventType<MouseEvent> = 'aeons_mouse_up';

  /**
   * Mouse move event type.
   */
  public static inline final MOUSE_MOVE: EventType<MouseEvent> = 'aeons_mouse_move';

  /**
   * Mouse scroll event type.
   */
  public static inline final MOUSE_SCROLL: EventType<MouseEvent> = 'aeons_mouse_scroll';

  /**
   * Mouse leave event type.
   */
  public static inline final MOUSE_LEAVE: EventType<MouseEvent> = 'aeons_mouse_leave';

  /**
   * The button pressed.
   */
  var button = -1;

  /**
   * The x position of the mouse in window pixels.
   */
  var x = 0;

  /**
   * The y position of the mouse in window pixels.
   */
  var y = 0;

  /**
   * The amount moved on the x axis since the last event in window pixels.
   */
  var deltaX = 0;

  /**
   * The amount moved on the y axis since the last even in window pixels.
   */
  var deltaY = 0;

  /**
   * The scroll wheel direction. -1 is up. 1 is down.
   */
  var scrollDirection = 0;

  /**
   * Has the cursor left the window.
   */
  var leave = false;
}
