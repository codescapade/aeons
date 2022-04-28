package aeons.components;

import aeons.core.Component;
import aeons.core.Renderable;
import aeons.math.Rect;
import aeons.graphics.Color;
import aeons.graphics.RenderTarget;
import aeons.graphics.atlas.Atlas;
import aeons.graphics.atlas.Frame;

/**
 * Nine slice is a sprite that can scale without changing the corners.
 */
class CNineSlice extends Component implements Renderable {
  /**
   * The width of the sprite in pixels.
   */
  public var width(default, set): Float;

  /**
   * The height of the sprite in pixels.
   */
  public var height(default, set): Float;

  /**
   * The sprite tint color.
   */
  public var color: Color;

  /**
   * The x axis anchor.
   */
  public var anchorX: Float;

  /**
   * The y axis anchor.
   */
  public var anchorY: Float;

  /**
   * The atlas to use.
   */
  var atlas: Atlas;

  /**
   * The sprite frame to use.
   */
  var frame: Frame;

  /**
   * The top left corner of the slice.
   */
  var topLeft: Slice;

  /**
   * The top part of the slice.
   */
  var top: Slice;

  /**
   * The top right corner of the slice.
   */
  var topRight: Slice;

  /**
   * The left part of the slice.
   */
  var left: Slice;

  /**
   * The center part of the slice.
   */
  var center: Slice;

  /**
   * The right part of the slice.
   */
  var right: Slice;

  /**
   * The bottom left corner of the slice.
   */
  var bottomLeft: Slice;

  /**
   * The bottom part of the slice.
   */
  var bottom: Slice;

  /**
   * The bottom right corner of the slice.
   */
  var bottomRight: Slice;

  /**
   * CNineSlice constructor.
   * @param options The init options.
   */
  public function new(options: NineSliceOptions) {
    super();
    atlas = options.atlas;
    frame = atlas.getFrame(options.frameName);
    createFrames(frame.frame.x, frame.frame.y, frame.frame.width, frame.frame.height,
        options.insetLeft, options.insetRight, options.insetTop, options.insetBottom);

    anchorX = options.anchorX == null ? 0.5 : options.anchorX;
    anchorY = options.anchorY == null ? 0.5 : options.anchorY;

    width = options.width;
    height = options.height;

    color = options.color == null ? Color.White : options.color;
  }

  /**
   * Render the slices.
   * @param target The target to render to.
   */
  public function render(target: RenderTarget) {
    // Top left.
    target.drawImageSection(-(width * anchorX) + topLeft.x, -(height * anchorY) + topLeft.y, topLeft.frameRect.x,
        topLeft.frameRect.y, topLeft.frameRect.width, topLeft.frameRect.height, atlas.image, color);

    // Top.
    target.drawImageSectionWithSize(-(width * anchorX) + top.x, -(height * anchorY) + top.y,
        top.frameRect.width * top.scaleX, top.frameRect.height, top.frameRect.x, top.frameRect.y, top.frameRect.width,
        top.frameRect.height, atlas.image, color);

    // Top right.
    target.drawImageSection(-(width * anchorX) + topRight.x, -(height * anchorY) + topRight.y,
        topRight.frameRect.x, topRight.frameRect.y,
        topRight.frameRect.width, topRight.frameRect.height, atlas.image, color);

    // Left.
    target.drawImageSectionWithSize(-(width * anchorX) + left.x, -(height * anchorY) + left.y,
        left.frameRect.width, left.frameRect.height * left.scaleY, left.frameRect.x, left.frameRect.y,
        left.frameRect.width, left.frameRect.height, atlas.image, color);

    // Center.
    target.drawImageSectionWithSize(-(width * anchorX) + center.x, -(height * anchorY) + center.y,
        center.frameRect.width * center.scaleX, center.frameRect.height * center.scaleY, center.frameRect.x,
        center.frameRect.y, center.frameRect.width, center.frameRect.height, atlas.image, color);

    // Right.
    target.drawImageSectionWithSize(-(width * anchorX) + right.x, -(height * anchorY) + right.y,
        right.frameRect.width, right.frameRect.height * right.scaleY, right.frameRect.x, right.frameRect.y,
        right.frameRect.width, right.frameRect.height, atlas.image, color);

    // Bottom left.
    target.drawImageSection(-(width * anchorX) + bottomLeft.x, -(height * anchorY) + bottomLeft.y,
        bottomLeft.frameRect.x, bottomLeft.frameRect.y, bottomLeft.frameRect.width, bottomLeft.frameRect.height,
        atlas.image, color);

    // Bottom.
    target.drawImageSectionWithSize(-(width * anchorX) + bottom.x, -(height * anchorY) + bottom.y,
        bottom.frameRect.width * bottom.scaleX, bottom.frameRect.height, bottom.frameRect.x, bottom.frameRect.y,
        bottom.frameRect.width, bottom.frameRect.height, atlas.image, color);

    // Bottom right.
    target.drawImageSection(-(width * anchorX) + bottomRight.x, -(height * anchorY) + bottomRight.y,
        bottomRight.frameRect.x, bottomRight.frameRect.y, bottomRight.frameRect.width, bottomRight.frameRect.height,
        atlas.image, color);
  }
  
  /**
   * Check if the component is inside the camera bounds and should be rendered.
   * @param cameraBounds Used to render only what the camera can see.
   * The bounds are in the local space of the component.
   * @return True if in bounds. Out of bounds will not render using the RenderSystem.
   */
  public function inCameraBounds(cameraBounds: Rect): Bool {
    return true;
  }

  /**
   * Create all slice frames.
   * @param frameX The x position of the top left corner of the sprite in pixels.
   * @param frameY The y position of the top left corner of the sprite in pixels.
   * @param width The width of the source sprite in pixels.
   * @param height The height of the source sprite in pixels.
   * @param insetLeft The inset on the left in pixels.
   * @param insetRight The inset on the right in pixels.
   * @param insetTop The inset on the top in pixels.
   * @param insetBottom The inset on the bottom in pixels.
   */
  function createFrames(frameX: Float, frameY: Float, width: Float, height: Float, insetLeft: Int, insetRight: Int,
      insetTop: Int, insetBottom: Int) {
    topLeft = new Slice(frameX, frameY, insetLeft, insetTop);
    top = new Slice(frameX + insetLeft, frameY, width - insetLeft - insetRight, insetTop);
    topRight = new Slice(frameX + width - insetRight, frameY, insetRight, insetTop);
    left = new Slice(frameX, frameY + insetTop, insetLeft, height - insetTop - insetBottom);
    center = new Slice(frameX + insetLeft, frameY + insetTop, width - insetLeft - insetRight,
        height - insetTop - insetBottom);
    right = new Slice(frameX + width - insetRight, frameY + insetTop, insetRight, height - insetTop - insetBottom);
    bottomLeft = new Slice(frameX, frameY + height - insetBottom, insetLeft, insetBottom);
    bottom = new Slice(frameX + insetLeft, frameY + height - insetBottom, width - insetLeft - insetRight, insetBottom);
    bottomRight = new Slice(frameX + width - insetRight, frameY + height - insetBottom, insetRight, insetBottom);
  }

  /**
   * Width setter. Updates all slices.
   * @param value The new width.
   */
  function set_width(value: Float): Float {
    final minWidth = left.width + center.width + right.width;
    if (value < minWidth) {
      value = minWidth;
    }

    final centerWidth = value - (left.width + right.width);
    final centerScale = centerWidth / center.width;

    topLeft.x = left.x = bottomLeft.x = 0;
    top.x = center.x = bottom.x = left.width;
    topRight.x = right.x = bottomRight.x = left.width + centerWidth;
    top.scaleX = center.scaleX = bottom.scaleX = centerScale;

    width = value;

    return width;
  }

  /**
   * Height setter. Updates all slices.
   * @param value The new height.
   */
  function set_height(value: Float): Float {
    final minHeight = top.height + center.height + bottom.height;
    if (value < minHeight) {
      value = minHeight;
    }

    final centerHeight = value - (top.height + bottom.height);
    final centerScale = centerHeight / center.height;

    topLeft.y = top.y = topRight.y = 0;
    left.y = center.y = right.y = top.height;
    bottomLeft.y = bottom.y = bottomRight.y = top.height + centerHeight;
    left.scaleY = center.scaleY = right.scaleY = centerScale;

    height = value;

    return height;
  }
}

/**
 * Nine slice initialization options.
 */
typedef NineSliceOptions = {
  /**
   * The left inset in pixels.
   */
  var insetLeft: Int;

  /**
   * The right inset in pixels.
   */
  var insetRight: Int;

  /**
   * The top inset in pixels.
   */
  var insetTop: Int;

  /**
   * The bottom inset in pixels.
   */
  var insetBottom: Int;

  /**
   * The width of the sprite.
   */
  var width: Int;

  /**
   * The height of the sprite.
   */
  var height: Int;

  /**
   * The atlas to use as source.
   */
  var atlas: Atlas;

  /**
   * The atlas frame name.
   */
  var frameName: String;

  /**
   * The x axis anchor.
   */
  var ?anchorX: Float;

  /**
   * The y axis anchor.
   */
  var ?anchorY: Float;

  /**
   * The tint color.
   */
  var ?color: Color;
}

/**
 * Internal slice class.
 */
private class Slice {
  /**
   * The x position in the slice in pixels.
   */
  public var x = 0.0;

  /**
   * The y position in the slice in pixels.
   */
  public var y = 0.0;

  /**
   * The x scale of the internal size.
   */
  public var scaleX = 1.0;

  /**
   * The y scale of the internal size.
   */
  public var scaleY = 1.0;

  /**
   * The frame rect.
   */
  public var frameRect(default, null): Rect;

  /**
   * The width of the slice.
   */
  public var width(get, never): Float;

  /**
   * The height of the slice.
   */
  public var height(get, never): Float;

  /**
   * Constructor.
   * @param x The frame x position.
   * @param y The frame y position.
   * @param width The frame width.
   * @param height The frame height.
   */
  public function new(x: Float, y: Float, width: Float, height: Float) {
    frameRect = new Rect(x, y, width, height);
  }

  /**
   * Width getter.
   */
  inline function get_width(): Float {
    return frameRect.width;
  }

  /**
   * Height getter.
   */
  inline function get_height(): Float {
    return frameRect.height;
  }
}
