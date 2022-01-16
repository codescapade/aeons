package aeons.components;

import aeons.core.Component;
import aeons.core.Renderable;
import aeons.graphics.Color;
import aeons.graphics.RenderTarget;
import aeons.graphics.texturepacker.Frame;
import aeons.graphics.texturepacker.SpriteSheet;
import aeons.graphics.Image;
import aeons.math.Rect;

/**
 * The `CSprite` component can be used to render images and sprite sheet frames.
 */
class CSprite extends Component implements Renderable {
  /**
   * The image to render when not using a sprite sheet.
   */
  public var image: Image;

  /**
   * The sprite sheet to use when not using an image.
   */
  public var sheet: SpriteSheet;

  /**
   * The sprite frame name.
   */
  public var frameName(default, null) = '';

  /**
   * The width of the image / sprite frame in pixels.
   */
  public var width(get, null): Int;

  /**
   * The height of the image / sprite frame in pixels.
   */
  public var height(get, null): Int;

  /**
   * The x axis anchor. (0 to 1).
   */
  public var anchorX = 0.5;

  /**
   * The y axis anchor. (0 to 1).
   */
  public var anchorY = 0.5;

  /**
   * The sprite tint color. Defaults to white.
   */
  public var color = Color.White;

  /**
   * The sprite bounds. Used to check if it is on screen.
   */
  public var bounds = new Rect();

  /**
   * Current sprite frame.
   */
  var frame: Frame;

  /**
   * Initialize the compoenet.
   * @param options The options for initialization.
   */
  public function init(?options: CSpriteOptions): CSprite {
    if (options != null) {
      if (options.color != null) color = options.color;
      if (options.anchorX != null) anchorX = options.anchorX;
      if (options.anchorY != null) anchorY = options.anchorY;
      if (options.image != null) image = options.image;
      if (options.sheet != null) sheet = options.sheet;
      if (options.frameName != null) setFrame(options.frameName);
    }

    return this;
  }

  /**
   * Render the image.
   * @param graphics The graphics reference used to actually draw things.
   */
  public function render(target: RenderTarget) {
    if (!active || (image == null && (sheet == null || frame == null))) {
      return;
    }

    // Draw a sprite sheet frame.
    if (image == null) {
      target.drawImageSection(-(frame.sourceSize.width * anchorX) + frame.sourceRect.x,
          -(frame.sourceSize.height * anchorY) + frame.sourceRect.y, frame.frame.x, frame.frame.y, frame.frame.width,
          frame.frame.height, sheet.image, color);
    // Draw an image.
    } else {
      target.drawImage(-(image.width * anchorX), -(image.height * anchorY), image, color);
    }
  }

  /**
   * Set a new frame for a sprite sheet.
   * @param frameName The new frame name.
   * @param sheet The new sprite sheet if needed.
   */
  public function setFrame(frameName: String, ?sheet: SpriteSheet) {
    if (sheet != null) {
      this.sheet = sheet;
    }

    if (this.sheet == null) {
      throw 'No sprite sheet assigned';
    }

    frame = this.sheet.getFrame(frameName);
  }

  /**
   * Sprite width getter.
   */
  function get_width(): Int {
    if (image != null) {
      return image.width;
    } else if (frame != null) {
      return Std.int(frame.sourceSize.width);
    }

    return 0;
  }

  /**
   * Sprite height getter.
   */
  function get_height(): Int {
    if (image != null) {
      return image.height;
    } else if (frame != null) {
      return Std.int(frame.sourceSize.height);
    }

    return 0;
  }
}

/**
 * The sprite options you can set in the `CSprite` init function.
 */
typedef CSpriteOptions = {
  /**
   * The image to use when not using a sprite sheet.
   */
  var ?image: Image;

  /**
   * The sprite sheet to use.
   */
  var ?sheet: SpriteSheet;

  /**
   * The sprite frame to use.
   */
  var ?frameName: String;

  /**
   * The x axis anchor.
   */
  var ?anchorX: Float;

  /**
   * The y axis anchor.
   */
  var ?anchorY: Float;

  /**
   * The sprite tint color.
   */
  var ?color: Color;
}