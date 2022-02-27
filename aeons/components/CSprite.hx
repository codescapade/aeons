package aeons.components;

import aeons.core.Component;
import aeons.core.Renderable;
import aeons.graphics.Color;
import aeons.graphics.RenderTarget;
import aeons.graphics.atlas.Frame;
import aeons.graphics.atlas.Atlas;
import aeons.math.Rect;

/**
 * The `CSprite` component can be used to render sprite atlas frames.
 */
class CSprite extends Component implements Renderable {
  /**
   * The atlas to use.
   */
  public var atlas: Atlas;

  /**
   * The sprite frame name.
   */
  public var frameName(default, null) = '';

  /**
   * The width of the sprite frame in pixels.
   */
  public var width(get, never): Int;

  /**
   * The height of the sprite frame in pixels.
   */
  public var height(get, never): Int;

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
      if (options.atlas != null) atlas = options.atlas;
      if (options.frameName != null) setFrame(options.frameName);
    }

    return this;
  }

  /**
   * Render the image.
   * @param graphics The graphics reference used to actually draw things.
   */
  public function render(target: RenderTarget) {
    if (!active || atlas == null || frame == null) {
      return;
    }

    // Draw an atlas frame.
    target.drawImageSection(-(frame.sourceSize.width * anchorX) + frame.sourceRect.x,
        -(frame.sourceSize.height * anchorY) + frame.sourceRect.y, frame.frame.x, frame.frame.y, frame.frame.width,
        frame.frame.height, atlas.image, color);
  }

  /**
   * Set a new frame for a atlas.
   * @param frameName The new frame name.
   * @param atlas The new atlas sheet if needed.
   */
  public function setFrame(frameName: String, ?atlas: Atlas) {
    if (atlas != null) {
      this.atlas = atlas;
    }

    if (this.atlas == null) {
      throw 'No sprite sheet assigned';
    }

    frame = this.atlas.getFrame(frameName);
  }

  /**
   * Sprite width getter.
   */
  function get_width(): Int {
    if (frame != null) {
      return Std.int(frame.sourceSize.width);
    }

    return 0;
  }

  /**
   * Sprite height getter.
   */
  function get_height(): Int {
    if (frame != null) {
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
   * The sprite atlas to use.
   */
  var ?atlas: Atlas;

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