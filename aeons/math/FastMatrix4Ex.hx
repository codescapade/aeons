package aeons.math;

/**
 * FastMatrix4Ex has static extension functions for the `FastMatrix4` class.
 */
class FastMatrix4Ex {
  /**
   * Set a FastMatrix4 from a rotation translation and scale.
   * @param matrix The matrix to update.
   * @param rotation The rotation quaternion.
   * @param translation The x and y translation values. 
   * @param scale The x and y scale values.
   * @return The updated matrix.
   */
  public static inline function from2dRotationTranslationScale(matrix: FastMatrix4, rotation: Quaternion,
      translation: Vector2, scale: Vector2): FastMatrix4 {
    return fromRotationTranslationScaleVal(matrix, rotation, translation.x, translation.y, 0, scale.x, scale.y, 1);
  }

  /**
   * Set a FastMatrix4 from a rotation translation and scale.
   * @param matrix The matrix to update.
   * @param rotation The rotation quaternion.
   * @param x The translation x.
   * @param y The translation y.
   * @param z The translation z.
   * @param scaleX The scale x.
   * @param scaleY The scale y.
   * @param scaleZ The scale z.
   * @return The updated matrix.
   */
  public static function fromRotationTranslationScaleVal(matrix: FastMatrix4, rotation: Quaternion, x: FastFloat,
      y: FastFloat, z: FastFloat, scaleX: FastFloat, scaleY: FastFloat, scaleZ: FastFloat): FastMatrix4 {
    final rx = rotation.x;
    final ry = rotation.y;
    final rz = rotation.z;
    final rw = rotation.w;

    final x2 = rx + rx;
    final y2 = ry + ry;
    final z2 = rz + rz;

    final xx = rx * x2;
    final xy = rx * y2;
    final xz = rx * z2;
    final yy = ry * y2;
    final yz = ry * z2;
    final zz = rz * z2;
    final wx = rw * x2;
    final wy = rw * y2;
    final wz = rw * z2;

    final sx = scaleX;
    final sy = scaleY;
    final sz = scaleZ;

    matrix._00 = (1 - (yy + zz)) * sx;
    matrix._10 = (xy - wz) * sy;
    matrix._20 = (xz + wy) * sz;
    matrix._30 = x;
    matrix._01 = (xy + wz) * sx;
    matrix._11 = (1 - (xx + zz)) * sy;
    matrix._21 = (yz - wx) * sz;
    matrix._31 = y;
    matrix._02 = (xz - wy) * sx;
    matrix._12 = (yz + wx) * sy;
    matrix._22 = (1 - (xx + yy)) * sz;
    matrix._32 = z;
    matrix._03 = 0;
    matrix._13 = 0;
    matrix._23 = 0;
    matrix._33 = 1;

    return matrix;
  }
}
