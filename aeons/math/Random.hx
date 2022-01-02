package aeons.math;

/**
 * The `Random` class has seeded random number generation funcations.
 */
 class Random {
  /**
   * The initial seed.
   */
  public var initialSeed(default, set) = 1;

  /**
   * The current seed. This changes every time a random function gets called.
   */
  public var currentSeed(get, set): Int;

  /**
   * The multiplier for the random generation.
   */
  static inline final MULTIPLIER = 48271.0;

  /**
   * The maximum integer.
   */
  static inline final MODULUS = 0x7FFFFFFF;

  /**
   * The internal seed
   */
  var internalSeed = 1.0;

  /**
   * Constructor.
   * @param initialSeed start seed (Optional).
   */
  public function new(?initialSeed: Int) {
    if (initialSeed != null) {
      this.initialSeed = initialSeed;
    } else {
      resetSeed();
    }
  }

  /**
   * Create a random initial seed to reset the seed.
   */
  public inline function resetSeed() {
    initialSeed = rangeBound(Std.int(Math.random() * MODULUS));
  }

  /**
   * Get a random integer in a range. Max is inclusive.
   * @param min The minimum value.
   * @param max The maximum value.
   * @return The random integer.
   */
  public function int(min = 0, max = MODULUS): Int {
    if (min == 0 && max == MODULUS) {
      return Std.int(generate());
    } else if (min == max) {
      return min;
    } else {
      if (min > max) {
        var temp = max;
        max = min;
        min = temp;
      }

      return Math.floor(min + generate() / MODULUS * (max - min + 1));
    }
  }

  /**
   * Get a random float between min and max inclusive. If you don't give min and max it is between 0 and 1.
   * @param min The minimum value.
   * @param max The maximum value.
   * @return The random float.
   */
  public function float(min = 0.0, max = 1.0): Float {
    if (min == 0 && max == 1) {
      return generate() / MODULUS;
    } else if (min == max) {
      return min;
    } else {
      if (min > max) {
        var temp = max;
        max = min;
        min = temp;
      }

      return min + (generate() / MODULUS) * (max - min);
    }
  }

  /**
   * Generate a new seed. This is done every time a number is generated.
   * @return A new float.
   */
  inline function generate(): Float {
    return internalSeed = (internalSeed * MULTIPLIER) % MODULUS;
  }

  /**
   * Clamp a value between 1 and max integer minus one.
   * @param value Value to clamp.
   * @return The clamped value.
   */
  inline function rangeBound(value: Int): Int {
    return AeMath.clampInt(value, 1, MODULUS - 1);
  }

  /**
   * Initial seed setter.
   * @param seed New seed.
   */
  inline function set_initialSeed(seed: Int): Int {
    // make sure the seed is in range.
    return initialSeed = currentSeed = rangeBound(seed);
  }

  /**
   * Current seed getter.
   */
  inline function get_currentSeed(): Int {
    return Std.int(internalSeed);
  }

  /**
   * Current seed setter.
   * @param seed New seed.
   */
  inline function set_currentSeed(seed: Int): Int {
    // make sure the seed is in range.
    return Std.int(internalSeed = rangeBound(seed));
  }
}