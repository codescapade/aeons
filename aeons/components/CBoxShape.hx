package aeons.components;

import aeons.core.Component;
import aeons.core.Renderable;
import aeons.graphics.Color;
import aeons.graphics.RenderTarget;
import aeons.math.Rect;

/**
 * `CBoxShape` is a component to draw single color boxes.
 */
class CBoxShape extends Component implements Renderable {
  /**
   * Enable/disable debug draw for this component.
   */
  public var debugDraw = false;

  /**
   * The color of the box. Defaults to white.
   */
  public var fillColor = Color.White;

  /**
   * The stroke color. Defaults to white.
   */
  public var strokeColor = Color.White;

  /**
   * The width of the box in pixels.
   */
  public var width = 10.0;

  /**
   * The height of the box in pixels.
   */
  public var height = 10.0;

  /**
   * The x axis anchor.
   */
  public var anchorX = 0.5;

  /**
   * The y axis anchor.
   */
  public var anchorY = 0.5;

  /**
   * Should the box be filled with color.
   */
  public var filled = false;

  /**
   * Should the box have an outline stroke.
   */
  public var hasStroke = true;

  /**
   * The stroke width in pixels.
   */
  public var strokeWidth = 1.0;

  /**
   * The bounding box to check if it is inside camera bounds.
   */
  public var bounds = new Rect();

  /**
   * Initialize the component.
   * @param options The values you want to set.
   * @return A reference to this component.
   */
  public function new (options: CBoxShapeOptions) {
    super();

    width = options.width;
    height = options.height;
    if (options.hasStroke != null) hasStroke = options.hasStroke;
    if (options.strokeColor != null) strokeColor = options.strokeColor;
    if (options.strokeWidth != null) strokeWidth = options.strokeWidth;
    if (options.filled != null) filled = options.filled;
    if (options.fillColor != null) fillColor = options.fillColor;
    if (options.anchorX != null) anchorX = options.anchorX;
    if (options.anchorY != null) anchorY = options.anchorY;
  }

  /**
   * Render the box.
   * @param target Used to render the box.
   * @param cameraBounds Used to render only what the camera can see.
   */
  public function render(target: RenderTarget, cameraBounds: Rect) {
    if (!active) {
      return;
    }

    if (filled) {
      target.drawSolidRect(-(width * anchorX), -(height * anchorY), width, height, fillColor);
    }

    if (hasStroke) {
      target.drawRect(-(width * anchorX), -(height * anchorY), width, height, strokeColor, strokeWidth, Inside);
    }
  }
}

/**
 * Values you can set in the `BoxShape` init function.
 */
typedef CBoxShapeOptions = {
  /**
   * The width of the box in pixels.
   */
  var width: Float;

  /**
   * The height of the box in pixels.
   */
  var height: Float;

  /**
   * The x axis anchor. (0 to 1).
   */
  var ?anchorX: Float;

  /**
   * The y axis anchor. (0 to 1).
   */
  var ?anchorY: Float;

  /**
   * Does the box have a stroke.
   */
  var ?hasStroke: Bool;

  /**
   * The stroke color.
   */
  var ?strokeColor: Color;

  /**
   * The stroke width in pixels.
   */
  var ?strokeWidth: Float;

  /**
   * Should the box be filled.
   */
  var ?filled: Bool;

  /**
   * The color of the fill.
   */
  var ?fillColor: Color;
}