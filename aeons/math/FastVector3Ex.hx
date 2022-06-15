package aeons.math;

class FastVector3Ex {
  /**
   * Multiply x, y and z vector values by a matrix.
   * @param matrix The matrix to multiply by.
   * @param x The x vector value.
   * @param y The y vector value.
   * @param z The z vector value.
   * @param out Optional vector to store the result in.
   * @return The result as a FastVector3.
   */
  public static function mulVec3Val(cl: Class<FastVector3>, matrix: FastMatrix4, x: Float, y: Float,
      z: Float): FastVector3 {
    return new FastVector3(matrix._00 * x
      + matrix._10 * y
      + matrix._20 * z
      + matrix._30,
      matrix._01 * x
      + matrix._11 * y
      + matrix._21 * z
      + matrix._31,
      matrix._02 * x
      + matrix._12 * y
      + matrix._22 * z
      + matrix._32);
  }

  /**
   * Multiply a vector3 by a matrix..
   * @param vec The vector source.
   * @param matrix The matrix to multiply by.
   * @return The result as a FastVector3.
   */
  public static inline function mulVec3(cl: Class<FastVector3>, vec: FastVector3, matrix: FastMatrix4): FastVector3 {
    return mulVec3Val(cl, matrix, vec.x, vec.y, vec.z);
  }
}
