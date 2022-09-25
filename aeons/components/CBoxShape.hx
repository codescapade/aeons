package aeons.components;

import aeons.core.Component;
import aeons.core.Renderable;
import aeons.graphics.Color;
import aeons.graphics.RenderTarget;
import aeons.math.Rect;

/**
 * CBoxShape is a component to draw single color boxes.
 */
class CBoxShape extends Component implements Renderable {
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
   * Initialize the component.
   * @param options Initialization options.
   * @return This component.
   */
  public function create(options: CBoxShapeOptions): CBoxShape {
    width = options.width;
    height = options.height;
    hasStroke = options.hasStroke == null ? true : options.hasStroke;
    strokeColor = options.strokeColor == null ? Color.White : options.strokeColor;
    strokeWidth = options.strokeWidth == null ? 1.0 : options.strokeWidth;
    filled = options.filled == null ? false : options.filled;
    fillColor = options.fillColor == null ? Color.White : options.fillColor;
    anchorX = options.anchorX == null ? 0.5 : options.anchorX;
    anchorY = options.anchorY == null ? 0.5 : options.anchorY;

    return this;
  }

  /**
   * Render the box.
   * @param target Used to render the box.
   */
  public function render(target: RenderTarget) {
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

  /**
   * Check if the component is inside the camera bounds and should be rendered.
   * @param cameraBounds Used to render only what the camera can see.
   * The bounds are in the local space of the component.
   * @return True if in bounds. Out of bounds will not render using the RenderSystem.
   */
  public function inCameraBounds(cameraBounds: Rect): Bool {
    return cameraBounds.x > -cameraBounds.width - width
      && cameraBounds.y > -cameraBounds.height - height
      && cameraBounds.x < width
      && cameraBounds.y < height;
  }
}

/**
 * Values you can set in the BoxShape init function.
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
