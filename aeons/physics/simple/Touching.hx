package aeons.physics.simple;

using aeons.utils.BitSets;

/**
 * Enum used to set which side of a body is touching another side.
 */
enum abstract Touching(Int) from Int to Int {
  var NONE = 0;
  var LEFT = value(0);
  var RIGHT = value(1);
  var TOP = value(2);
  var BOTTOM = value(3);

  /**
   * Bit shift value.
   * @param index Yhe index to shift.
   */
  static inline function value(index: Int): Int {
    return 1 << index;
  }

  /**
   * Add a side that is touching a body.
   * @param value The side you want to add.
   */
  public inline function add(value: Touching) {
    this = this.add(value);
  }

  /**
   * Remove a side that is touching a body.
   * @param value The side you want to remove.
   */
  public inline function remove(value: Touching) {
    this = this.remove(value);
  }

  /**
   * Check if a side is in the current value.
   * @param value The side to check for.
   */
  public inline function contains(value: Touching): Bool {
    return this.contains(value);
  }
}
