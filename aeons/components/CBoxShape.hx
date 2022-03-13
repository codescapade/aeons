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
  public var fillColor: Color;

  /**
   * The stroke color. Defaults to white.
   */
  public var strokeColor: Color;

  /**
   * The width of the box in pixels.
   */
  public var width: Float;

  /**
   * The height of the box in pixels.
   */
  public var height: Float;

  /**
   * The x axis anchor.
   */
  public var anchorX: Float;

  /**
   * The y axis anchor.
   */
  public var anchorY: Float;

  /**
   * Should the box be filled with color.
   */
  public var filled: Bool;

  /**
   * Should the box have an outline stroke.
   */
  public var hasStroke: Bool;

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
    hasStroke = options.hasStroke == null ? true : options.hasStroke;
    strokeColor = options.strokeColor == null ? Color.White : options.strokeColor;
    strokeWidth = options.strokeWidth == null ? 1.0 : options.strokeWidth;
    filled = options.filled == null ? false : options.filled;
    fillColor = options.fillColor == null ? Color.White : options.fillColor;
    anchorX = options.anchorX == null ? 0.5 : options.anchorX;
    anchorY = options.anchorY == null ? 0.5 : options.anchorY;
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