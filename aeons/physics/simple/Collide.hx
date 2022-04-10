package aeons.physics.simple;

using aeons.utils.BitSets;

/**
 * Collide is used to set which side of a body can collide.
 */
enum abstract Collide(Int) from Int to Int {
  var NONE = 0;
  var LEFT = value(0);
  var RIGHT = value(1);
  var TOP = value(2);
  var BOTTOM = value(3);
  var ALL = 15;

  /**
   * Bit shift value.
   * @param index Yhe index to shift.
   */
  static inline function value(index: Int): Int {
    return 1 << index;
  }

  /**
   * Add a side.
   * @param value The new side.
   */
  public inline function add(value: Collide) {
    this = this.add(value);
  }

  /**
   * Remove a side.
   * @param value The side you want to remove.
   */
  public inline function remove(value: Collide) {
    this = this.remove(value);
  }

  /**
   * Check if this collider has a side.
   * @param value The side to check for.
   */
  public inline function contains(value: Collide): Bool {
    return this.contains(value);
  }
}
