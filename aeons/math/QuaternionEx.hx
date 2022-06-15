package aeons.math;

/**
 * QuaternionEx has static extension functions for the `Quaternion` class.
 */
class QuaternionEx {
  /**
   * Set a quaternion from an angle on one or more axes.
   * @param x The x axis value.
   * @param y The y axis value.
   * @param z The z axis value.
   * @param angle The angle in radians.
   * @return The new quaternion.
   */
  public static function fromAxisAngleVal(cl: Class<Quaternion>, x: Float, y: Float, z: Float,
      angle: Float): Quaternion {
    final cos = Math.cos(angle / 2.0);
    final sin = Math.sin(angle / 2.0);

    return new Quaternion(sin * x, sin * y, sin * z, cos);
  }
}
