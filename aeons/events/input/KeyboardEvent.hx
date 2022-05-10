package aeons.events.input;

import aeons.input.KeyCode;

/**
 * KeyboardEvent for sending keyboard input events.
 */
class KeyboardEvent extends Event {
  /**
   * Key up event type.
   */
  public static inline final KEY_UP: EventType<KeyboardEvent> = 'aeons_key_up';

  /**
   * Key down event type.
   */
  public static inline final KEY_DOWN: EventType<KeyboardEvent> = 'aeons_key_down';

  /**
   * The keycode that was pressed or released.
   */
  var key: KeyCode;
}
