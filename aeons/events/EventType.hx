package aeons.events;

/**
 * EventType adds type checking for the callback functions.
 */
abstract EventType<T>(String) from String to String {

  /**
   * Compare Event types with strings.
   * @param a The event type to compare.
   * @param b The string to compare to.
   * @return True if a and b match.
   */
  @:op(A == B)
  static inline function equals<T>(a: EventType<T>, b: String): Bool {
    return (a: String) == b;
  }

  /**
   * Compare Event types with strings.
   * @param a The event type to compare.
   * @param b The string to compare to.
   * @return True if a and b do not match.
   */
  @:op(A != B)
  static inline function notEquals<T>(a: EventType<T>, b: String): Bool {
    return (a: String) != b;
  }
}