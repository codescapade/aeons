package aeons.math;

/**
 * Rect is a basic rectangle class using floats.
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
   * The integer x position of the rectangle.
   */
  public var xi(get, never): Int;

  /**
   * The integer y position of the rectangle.
   */
  public var yi(get, never): Int;

  /**
   * The integer width of the rectangle.
   */
  public var widthi(get, never): Int;

  /**
   * The integer height of the rectangle.
   */
  public var heighti(get, never): Int;

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
   * Check if a line overlaps with this rectangle.
   * @param p1 The start point of the line.
   * @param p2 The end point of the line.
   * @return True if the line overlaps.
   */
  public function intersectsLine(p1: Vector2, p2: Vector2, ?out: Vector2): Bool {
    var b1 = Vector2.get(x, y);
    var b2 = Vector2.get(x + width, y);

    var intersects = false;
    if (linesIntersect(p1, p2, b1, b2, out)) {
      intersects = true;
    }

    b1.set(x + width, y + height);
    if (linesIntersect(p1, p2, b1, b2, out)) {
      intersects = true;
    }

    b2.set(x, y + height);
    if (linesIntersect(p1, p2, b1, b2, out)) {
      intersects = true;
    }

    b1.set(x, y);
    if (linesIntersect(p1, p2, b1, b2, out)) {
      intersects = true;
    }

    b1.put();
    b2.put();

    return intersects;
  }
  /**
   * String representation of the rectangle.
   * @return The string representation.
   */
  public inline function toString(): String {
    return 'x: $x, y: $y, width: $width, height: $height';
  }

  static function linesIntersect(a1: Vector2, a2: Vector2, b1: Vector2, b2: Vector2, ?out: Vector2): Bool {
    var b = Vector2.get();
    Vector2.subVectors(a2, a1, b);

    var d = Vector2.get();
    Vector2.subVectors(b2, b1, d);

    var bDotDPerp = b.x * d.y - b.y * d.x;
    if (bDotDPerp == 0) {
      b.put();
      d.put();
      return false;
    }

    var c = Vector2.get();
    Vector2.subVectors(b1, a1, c);
    var t = (c.x * d.y - c.y * d.x) / bDotDPerp;
    if ( t < 0 || t > 1) {
      b.put();
      d.put();
      c.put();
      return false;
    }

    var u = (c.x * b.y - c.y * b.x) / bDotDPerp;
    if (u < 0 || u > 1) {
      b.put();
      d.put();
      c.put();
      return false;
    }

    if (out != null) {
      var point = Vector2.get();
      point.copyFrom(a1);
      b.mulVal(t);
      point.add(b);

      // Choose the closest hit.
      if (out.equals(Vector2.ZERO)) {
        out.copyFrom(point);
      } else {
        if (Vector2.distance(a1, point) < Vector2.distance(a1, out)) {
          out.copyFrom(point);
        }
      }
      point.put();
    }

    b.put();
    d.put();
    c.put();

    return true;
  }
  /**
   * xi getter.
   */
  function get_xi(): Int {
    return Std.int(x);
  }

  /**
   * yi getter.
   */
  function get_yi(): Int {
    return Std.int(y);
  }

  /**
   * widthi getter.
   */
  function get_widthi(): Int {
    return Std.int(width);
  }

  /**
   * heighti getter.
   */
  function get_heighti(): Int {
    return Std.int(height);
  }
}
