package aeons.math;

import aeons.utils.Pool;

/**
 * The `Vector2` class is for 2d vector positions using floats.
 */
class Vector2 {
  /**
   * Vector pointing left to compare to.
   */
  public static final LEFT = new Vector2(-1, 0);

  /**
   * Vector pointing right to compare to.
   */
  public static final RIGHT = new Vector2(1, 0);

  /**
   * Vector pointing up to compare to.
   */
  public static final UP = new Vector2(0, -1);

  /**
   * Vector pointing down to compare to.
   */
  public static final DOWN = new Vector2(0, 1);

  /**
   * Zero vector to compare to.
   */
  public static final ZERO = new Vector2();

  /**
   * The x position.
   */
  public var x: Float;

  /**
   * The y position.
   */
  public var y: Float;

  /**
   * Floored integer x position.
   */
  public var xi(get, never): Int;

  /**
   * Floored integer y position.
   */
  public var yi(get, never): Int;

  /**
   * The vector length.
   */
  public var length(get, set): Float;

  /**
   * Object pool for this class.
   */
  @:noCompletion
  static final pool = new Pool<Vector2>(Vector2);

  /**
   * Get a vector from the object pool.
   * @param x New x position for the vector.
   * @param y New y position for the vector.
   * @return The initialized vector from the pool.
   */
  public static function get(x = 0.0, y = 0.0): Vector2 {
    final vec = pool.get();
    vec.set(x, y);

    return vec;
  }

  /**
   * Calculate the distance between two vectors.
   * @param vec1
   * @param vec2
   * @return The distance.
   */
  public static function distance(vec1: Vector2, vec2: Vector2): Float {
    return Math.sqrt(Math.pow(vec2.x - vec1.x, 2) + Math.pow(vec2.y - vec1.y, 2));
  }

  /**
   * Add two vectors together.
   * @param vec1 
   * @param vec2 
   * @param out Optional out vector when you don't want to create a new vector.
   * @return A vector with the result.
   */
  public static function addVectors(vec1: Vector2, vec2: Vector2, ?out: Vector2): Vector2 {
    if (out == null) {
      return new Vector2(vec1.x + vec2.x, vec1.y + vec2.y);
    }

    return out.set(vec1.x + vec2.x, vec1.y + vec2.y);
  }

  /**
   * Subtract two vectors.
   * @param vec1 
   * @param vec2 
   * @param out Optional out vector when you don't want to create a new vector.
   * @return A vector with the result.
   */
  public static function subVectors(vec1: Vector2, vec2: Vector2, ?out: Vector2): Vector2 {
    if (out == null) {
      return new Vector2(vec1.x - vec2.x, vec1.y - vec2.y);
    }

    return out.set(vec1.x - vec2.x, vec1.y - vec2.y);
  }

  /**
   * Multiply two vectors,
   * @param vec1 
   * @param vec2 
   * @param out Optional out vector when you don't want to create a new vector.
   * @return A vector with the result.
   */
  public static function mulVectors(vec1: Vector2, vec2: Vector2, ?out: Vector2): Vector2 {
    if (out == null) {
      return new Vector2(vec1.x * vec2.x, vec1.y * vec2.y);
    }

    return out.set(vec1.x * vec2.x, vec1.y * vec2.y);
  }

  /**
   * Vector2 constructor.
   * @param x 
   * @param y 
   */
  public function new(x = 0.0, y = 0.0) {
    this.x = x;
    this.y = y;
  }

  /**
   * Clone this vector and return it.
   * @return A new vector
   */
  public function clone(): Vector2 {
    return new Vector2(x, y);
  }

  /**
   * Copy the values from another vector.
   * @param other The vector to copy.
   * @return This vector.
   */
  public function copyFrom(other: Vector2): Vector2 {
    x = other.x;
    y = other.y;

    return this;
  }

  /**
   * Compare a vector with this.
   * @param vec Vector to compare with.
   * @return True if the vectors are equal.
   */
  public inline function equals(vec: Vector2): Bool {
    return x == vec.x && y == vec.y;
  }

  /**
   * String representation of this vector.
   * @return The string values.
   */
  public inline function toString(): String {
    return 'x: $x, y: $y';
  }

  /**
   * Add a vector to this one.
   * @param vec Vector to add.
   * @return This vector.
   */
  public inline function add(vec: Vector2): Vector2 {
    x += vec.x;
    y += vec.y;

    return this;
  }

  /**
   * Add a number to this vector.
   * @param value number to add.
   * @return This vector.
   */
  public inline function addVal(value: Float): Vector2 {
    x += value;
    y += value;

    return this;
  }

  /**
   * Subtract a vector from this one.
   * @param vec Vector to subtract.
   * @return This vector.
   */
  public inline function sub(vec: Vector2): Vector2 {
    x -= vec.x;
    y -= vec.y;

    return this;
  }

  /**
   * Subtract a number from this vector.
   * @param value number to subtract.
   * @return This vector.
   */
  public function subVal(value: Float): Vector2 {
    x -= value;
    y -= value;

    return this;
  }

  /**
   * Multiply a vector with this one.
   * @param vec Vector to multiply with.
   * @return This vector.
   */
  public inline function mul(vec: Vector2): Vector2 {
    x *= vec.x;
    y *= vec.y;

    return this;
  }

  /**
   * Multiply a number with this vector.
   * @param value Number to multiply with.
   * @return This vector.
   */
  public inline function mulVal(value: Float): Vector2 {
    x *= value;
    y *= value;

    return this;
  }

  /**
   * Divide this vector by another.
   * @param vec Vector to divide by.
   * @return This vector.
   */
  public function div(vec: Vector2): Vector2 {
    x /= vec.x;
    y /= vec.y;

    return this;
  }

  /**
   * Divide a this vector by a number.
   * @param value The value to divide by.
   * @return This vector.
   */
  public inline function divVal(value: Float): Vector2 {
    x /= value;
    y /= value;

    return this;
  }

  /**
   * Get the dot product.
   * @param vec The other vector.
   * @return The dot product.
   */
  public inline function dot(vec: Vector2): Float {
    return x * vec.x + y * vec.y;
  }

  /**
   * Normalize this vector.
   * @return This vector.
   */
  public function normalize(): Vector2 {
    if (length > 0) {
      final l = length;
      x /= l;
      y /= l;
    }

    return this;
  }

  /**
   * Return a new vector of this one normalized.
   * @return A new vector with the result.
   */
  public inline function normalized(?out: Vector2): Vector2 {
    if (out == null) {
      return clone().normalize();
    } else {
      return out.copyFrom(this).normalize();
    }
  }

  /**
   * Set the x and y of the vector.
   * @param x New x position.
   * @param y New y position.
   * @return This vector.
   */
  public inline function set(x: Float, y: Float): Vector2 {
    this.x = x;
    this.y = y;

    return this;
  }

  /**
   * Put this vector back in the pool.
   */
  public inline function put() {
    pool.put(this);
  }

  /**
   * Get the length of this vector.
   */
  inline function get_length(): Float {
    return Math.sqrt(x * x + y * y);
  }

  /**
   * Set the length of this vector.
   * @param value 
   */
  inline function set_length(value: Float): Float {
    normalize();
    x *= value;
    y *= value;

    return value;
  }

  /**
   * xi getter.
   */
  inline function get_xi(): Int {
    return Std.int(x);
  }

  /**
   * yi getter.
   */
  inline function get_yi(): Int {
    return Std.int(y);
  }
}