package aeons.math;

interface Random {
  /**
   * The initial seed.
   */
  var initialSeed(default, set): Int;

  /**
   * The current seed. This changes every time a random function gets called.
   */
  var currentSeed(get, set): Int;

  /**
   * Create a random initial seed to reset the seed.
   */
  function resetSeed(): Void;

  /**
   * Get a random integer in a range. Max is inclusive.
   * @param min The minimum value.
   * @param max The maximum value.
   * @return The random integer.
   */
  function int(?min: Int, ?max: Int): Int;

  /**
   * Get a random float between min and max inclusive. If you don't give min and max it is between 0 and 1.
   * @param min The minimum value.
   * @param max The maximum value.
   * @return The random float.
   */
  function float(min: Float = 0.0, max: Float = 1.0): Float;
}
