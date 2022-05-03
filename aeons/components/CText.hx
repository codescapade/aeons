package aeons.components;

import aeons.core.Component;
import aeons.core.Renderable;
import aeons.graphics.Color;
import aeons.graphics.Font;
import aeons.graphics.RenderTarget;
import aeons.math.Rect;

/**
 * CText component to render bitmap text.
 */
class CText extends Component implements Renderable {
  /**
   * The font to use to render.
   */
  public var font(default, set): Font;

  /**
   * The size of the font.
   */
  public var fontSize: Int;

  /**
   * the text to render.
   */
  public var text(default, set): String;

  /**
   * The color for the text.
   */
  public var color: Color;

  /**
   * Should the text have a colored background.
   */
  public var hasBackground: Bool;

  /**
   * The background color for the text.
   */
  public var backgroundColor: Color;

  /**
   * The width of the text in pixels.
   */
  public var width(default, null): Float;

  /**
   * The height of the text in pixels.
   */
  public var height(get, never): Float;

  /**
   * The x axis anchor.
   */
  public var anchorX: Float;

  /**
   * The y axis anchor.
   */
  public var anchorY: Float;

  /**
   * CText constructor.
   * @param options The options for initialization.
   */
  public function new(?options: CTextOptions) {
    super();

    if (options == null) {
      // Defautls when no options are specified.
      text = '';
      fontSize = 20;
      color = Color.White;
      anchorX = 0.5;
      anchorY = 0.5;
      hasBackground = false;
      backgroundColor = Color.Black;
    } else {
      text = options.text == null ? '' : options.text;
      if (options.font != null) font = options.font;
      if (options.fontSize != null) fontSize = options.fontSize;
      color = options.color == null ?  Color.White : options.color;
      backgroundColor = options.backgroundColor == null ? Color.Black : options.backgroundColor;
      if (options.hasBackground != null) hasBackground = options.hasBackground;

      anchorX = options.anchorX == null ? 0.5 : options.anchorX;
      anchorY = options.anchorY == null ? 0.5 : options.anchorY;
    }
  }

  /**
   * Render the text.
   * @param target The renderer.
   */
  public function render(target: RenderTarget) {
    if (font == null) {
      return;
    }

    if (hasBackground) {
      target.drawSolidRect(-(width) * anchorX - 2, -(height) * anchorY - 1, width + 4, height + 2, backgroundColor);
    }

    target.drawString(-width * anchorX, -height * anchorY, text, font, fontSize, color);
  }

  /**
   * Check if the component is inside the camera bounds and should be rendered.
   * @param cameraBounds Used to render only what the camera can see.
   * The bounds are in the local space of the component.
   * @return True if in bounds. Out of bounds will not render using the RenderSystem.
   */
  public function inCameraBounds(cameraBounds: Rect): Bool {
    return cameraBounds.x > -cameraBounds.width - width * 2 && cameraBounds.y > -cameraBounds.height - height * 2 &&
        cameraBounds.x < width * 2 && cameraBounds.y < height * 2;
  }

  inline function get_height(): Float {
    return font == null ? 0 : font.height(fontSize);
  }

  inline function set_text(value: String): String {
    text = value;
    if (font == null) {
      width = 0;
    } else {
      width = font.width(fontSize, value);
    }

    return value;
  }

  inline function set_font(value: Font): Font{
    font = value;
    width = font.width(fontSize, text);

    return value;
  }
}

/**
 * The Text component initialization options.
 */
typedef CTextOptions = {
  /**
   * The font to use.
   */
  var ?font: Font;

  /**
   * the size of the font in pixels.
   */
  var ?fontSize: Int;

  /**
   * The text to render.
   */
  var ?text: String;

  /**
   * The text color.
   */
  var ?color: Color;

  /**
   * The x axis anchor.
   */
  var ?anchorX: Float;

  /**
   * The y axis anchor.
   */
  var ?anchorY: Float;

  /**
   * Should there be a background color around the text.
   */
  var ?hasBackground: Bool;

  /**
   * The color of the background around the text.
   */
  var ?backgroundColor: Color;
}
