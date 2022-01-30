package aeons.components;

import aeons.core.Component;
import aeons.core.Renderable;
import aeons.graphics.Color;
import aeons.graphics.Font;
import aeons.graphics.RenderTarget;
import aeons.math.Rect;

/**
 * `CText` component to render bitmap text.
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
   * The text bounds.
   */
  public var bounds = new Rect();

  /**
   * Initialize the component.
   * @param options The options for initialization.
   */
  public function init(?options: TextOptions): CText {
    bounds = new Rect();
    if (options == null) {
      // Defautls when no options are specified.
      text = '';
      fontSize = 20;
      color = Color.White;
      anchorX = 0.5;
      anchorY = 0.5;
    } else {
      text = options.text == null ? '' : options.text;
      if (options.font != null) font = options.font;
      if (options.fontSize != null) fontSize = options.fontSize;
      if (options.color != null) {
        color = options.color;
      } else {
        color = Color.White;
      }

      anchorX = options.anchorX == null ? 0.5 : options.anchorX;
      anchorY = options.anchorY == null ? 0.5 : options.anchorY;
    }

    return this;
  }

  /**
   * Render the text.
   * @param target The renderer.
   */
  public function render(target: RenderTarget) {
    if (font == null) {
      return;
    }

    target.drawString(-width * anchorX, -height * anchorY, text, font, fontSize, color);
  }

  /**
   * Font height getter.
   */
  inline function get_height(): Float {
    if (font == null) {
      return 0;
    }

    return font.height(fontSize);
  }

  /**
   * Text setter. Also updates the font width.
   * @param value The new text.
   */
  inline function set_text(value: String): String {
    text = value;
    if (font == null) {
      width = 0;
    } else {
      width = font.width(fontSize, value);
    }

    return value;
  }

  /**
   * Font setter. Also update the font width.
   * @param value 
   */
  inline function set_font(value: Font): Font{
    font = value;
    width = font.width(fontSize, text);

    return value;
  }
}

/**
 * The Text component initialization options.
 */
typedef TextOptions = {
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
}