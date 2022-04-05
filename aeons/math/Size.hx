package aeons.math;

/**
 * Size is a helper class to easily represent the width and height of something using floats.
 */
class Size {
  /**
   * The width of the size.
   */
  public var width: Float;

  /**
   * The height of the size.
   */
  public var height: Float;

  /**
   * Constructor.
   * @param width The width for the size.
   * @param height The height for the size.
   */
  public function new(width = 0.0, height= 0.0) {
    this.width = width;
    this.height = height;
  }
}