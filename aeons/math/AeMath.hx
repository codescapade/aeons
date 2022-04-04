package aeons.math;

/**
 * `AeMath` has math helper variables and functions.
 */
class AeMath {
  #if (flash || js || ios || blackberry)
  /**
   * Minimum value of a floating point number.
   */
  public static inline final MIN_VALUE_FLOAT:Float = 0.0000000000000001;
  #else

  /**
   * Minimum value of a floating point number.
   */
  public static inline final MIN_VALUE_FLOAT: Float = 5e-324;
  #end

  /**
   * Maximum value of a floating point number.
   */
  public static inline final MAX_VALUE_FLOAT: Float = 1.79e+308;

  /**
   * Minimum value of an integer.
   */
  public static inline final MIN_VALUE_INT: Int = -MAX_VALUE_INT;

  /**
   * Maximum value of an integer.
   */
  public static inline final MAX_VALUE_INT: Int = 0x7FFFFFFF;

  /**
   * Lerp between two values.
   * @param a Start value.
   * @param b End value.
   * @param position Lerp position.
   */
  public static inline function lerp(a: Float, b: Float, position: Float): Float {
    return a + position * (b - a);
  }

  /**
   * Clamp a value between a min and max.
   * @param value The value to clamp.
   * @param min Minimum.
   * @param max Maximum.
   */
  public static inline function clamp(value: Float, min: Float, max:Float): Float {
    if (min > max) {
      var temp = max;
      max = min;
      min = temp;
    }

    final lower = (value < min) ? min : value;

    return (lower > max) ? max : lower;
  }

  /**
   * Clamp an integer value between a min and max.
   * @param value The value to clamp.
   * @param min Minimum.
   * @param max Maximum.
   */
  public static inline function clampInt(value: Int, min: Int, max: Int): Int {
    if (min > max) {
      var temp = max;
      max = min;
      min = temp;
    }

    final lower = (value < min) ? min : value;

    return (lower > max) ? max : lower;
  }

  /**
   * Return the lowest value of two integers.
   * @param a First value.
   * @param b Second value.
   */
  public static inline function minInt(a: Int, b: Int): Int {
    return (a < b) ? a : b;
  }

  /**
   * Return the highest value of two integers.
   * @param a First value.
   * @param b Second value.
   */
  public static inline function maxInt(a: Int, b: Int): Int {
    return (a > b) ? a : b;
  }

  /**
   * Convert radians to degrees.
   * @param rad Value to convert.
   */
  public static inline function radToDeg(rad: Float): Float {
    return rad * (180.0 / Math.PI);
  }

  /**
   * Convert degrees to radians.
   * @param deg Value to convert.
   */
  public static inline function degToRad(deg: Float): Float {
    return deg * (Math.PI / 180.0);
  }

  /**
   * Calculate the distance between two points.
   * @param x1 The x position of the first point.
   * @param y1 The y position of the first point.
   * @param x2 The x position of the second point.
   * @param y2 The y position of the second point.
   * @return The distance.
   */
  public static function distance(x1: Float, y1: Float, x2: Float, y2: Float): Float {
    return Math.sqrt(Math.pow(x2 - x1, 2) + Math.pow(y2 - y1, 2));
  }
}