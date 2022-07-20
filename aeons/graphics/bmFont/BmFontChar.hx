package aeons.graphics.bmFont;

/**
 * Bitmap font character information.
 */
class BmFontChar {
  /**
   * The character code.
   */
  public var id(default, null): Int;

  /**
   * The x position in the font image in pixels.
   */
  public var x(default, null): Int;

  /**
   * The y position in the font image in pixels.
   */
  public var y(default, null): Int;

  /**
   * The character width in pixels.
   */
  public var width(default, null): Int;

  /**
   * The character height in pixels.
   */
  public var height(default, null): Int;

  /**
   * The horizontal offset from the x position in pixels.
   */
  public var xOffset(default, null): Int;

  /**
   * The vertixal offset from the y position in pixels.
   */
  public var yOffset(default, null): Int;

  /**
   * The amount of horizontal pixels until the next character.
   */
  public var xAdvance(default, null): Int;

  /**
   * Constructor.
   * @param id Character code.
   * @param x The x position in the image.
   * @param y The y position in the image.
   * @param width The width in pixels.
   * @param height The height in pixels.
   * @param xOffset The horizontal offset.
   * @param yOffset The vertical offset.
   * @param xAdvance The amount of pixels until the next character.
   */
  public function new(id: Int, x: Int, y: Int, width: Int, height: Int, xOffset: Int, yOffset: Int, xAdvance: Int) {
    this.id = id;
    this.x = x;
    this.y = y;
    this.width = width;
    this.height = height;
    this.xOffset = xOffset;
    this.yOffset = yOffset;
    this.xAdvance = xAdvance;
  }
}
