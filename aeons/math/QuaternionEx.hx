package aeons.math;

/**
 * `QuaternionEx` has static extension functions for the `Quaternion` class.
 */
class QuaternionEx {
  /**
   * Set a quaternion from an angle on one or more axes.
   * @param quat The quaternion to update.
   * @param x The x axis value.
   * @param y The y axis value.
   * @param z The z axis value.
   * @param angle The angle in radians.
   * @return The updated quaternion.
   */
  public static function fromAxisAngleVal(quat: Quaternion, x: Float, y: Float, z: Float, angle: Float): Quaternion {
    quat.w = Math.cos(angle / 2.0);
    quat.x = quat.y = quat.z = Math.sin(angle / 2.0);
    quat.x *= x;
    quat.y *= y;
    quat.z *= z;

    return quat;
  }
}