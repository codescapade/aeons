package aeons.utils;

/**
 * Bit Sets are used to bit sift.
 */
 class BitSets {
  /**
   * Add a bit to the mask.
   * @param bits The source bits.
   * @param mask The mask.
   */
  public static inline function add(bits: Int, mask: Int): Int {
    return bits | mask;
  }

  /**
   * Remove a bit from the mask.
   * @param bits The source bits.
   * @param mask The mask.
   */
  public static inline function remove(bits: Int, mask: Int): Int {
    return bits & ~mask;
  }

  /**
   * Check if a bit mask has a bit.
   * @param bits The source bits.
   * @param mask The mask.
   */
  public static inline function contains(bits: Int, mask: Int): Bool {
    return bits & mask != 0;
  }
}