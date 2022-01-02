package aeons.math;

/**
 * `Rect` is a basic rectangle class using floats.
 */
 class Rect {
  /**
   * The x position of the rectangle.
   */
  public var x: Float;

  /**
   * The y position of the rectangle.
   */
  public var y: Float;

  /**
   * The width of the rectangle.
   */
  public var width: Float;

  /**
   * The height of the rectangle.
   */
  public var height: Float;

  /**
   * Rectangle constructor.
   * @param x 
   * @param y 
   * @param width 
   * @param height 
   */
  public function new(x = 0.0, y = 0.0, width = 0.0, height = 0.0) {
    set(x, y, width, height);
  }

  /**
   * Check if a point is inside this rectangle.
   * @param x X position of the point.
   * @param y Y position of the point.
   * @return True if the point is inside the rectangle.
   */
  public inline function hasPoint(x: Float, y: Float): Bool {
    return x >= this.x && x <= (this.x + width) && y > this.y && y <= (this.y + height);
  }

  /**
   * Check if a rectangle overlaps with this rectangle.
   * @param rect Rectangle to check.
   * @return True if the rectangles intersect.
   */
  public inline function intersects(rect: Rect): Bool {
    return (x < (rect.x + rect.width) && (x + width) > rect.x && y < (rect.y + rect.height) && (y + height) > rect.y);
  }

  /**
   * Set all rect values to a new value.
   * @param x The new x value.
   * @param y The new y value.
   * @param width The new width.
   * @param height The new height.
   */
  public function set(x: Float, y: Float, width: Float, height: Float): Void {
    this.x = x;
    this.y = y;
    this.width = width;
    this.height = height;
  }

  /**
   * String representation of the rectangle.
   * @return The string representation.
   */
  public inline function toString(): String {
    return 'x: $x, y: $y, width: $width, height: $height';
  }
}