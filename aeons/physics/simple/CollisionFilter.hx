package aeons.physics.simple;

using aeons.utils.BitSets;

/**
 * CollisionFilter is used for collision grouping.
 */
enum abstract CollisionFilter(Int) from Int to Int {
  var GROUP_01 = value(0);
  var GROUP_02 = value(1);
  var GROUP_03 = value(2);
  var GROUP_04 = value(3);
  var GROUP_05 = value(4);
  var GROUP_06 = value(5);
  var GROUP_07 = value(6);
  var GROUP_08 = value(7);
  var GROUP_09 = value(8);
  var GROUP_10 = value(9);
  var GROUP_11 = value(10);
  var GROUP_12 = value(11);
  var GROUP_13 = value(12);
  var GROUP_14 = value(13);
  var GROUP_15 = value(14);

  /**
   * Bit shift value.
   * @param index Yhe index to shift.
   */
  static inline function value(index: Int): Int {
    return 1 << index;
  }

  /**
   * Add a group.
   * @param value The group you want to add.
   */
  public inline function add(value: CollisionFilter) {
    this = this.add(value);
  }

  /**
   * Remove a group.
   * @param value The group you want to remove.
   */
  public inline function remove(value: CollisionFilter) {
    this = this.remove(value);
  }

  /**
   * Check if this filter contains a group.
   * @param value The group to check for.
   */
  public function contains(value: CollisionFilter): Bool {
    return this.contains(value);
  }
}