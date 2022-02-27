package aeons.graphics.atlas;

import aeons.math.Rect;
import aeons.math.Size;

/**
 * The `Frame` has the dimensions and location of a frame in an atlas.
 */
class Frame {
  /**
   * The name of the sprite in the atlas.
   */
  public var name(default, null): String;

  /**
   * The position and size of the image in the atlas.
   */
  public var frame(default, null): Rect;

  /**
   * True if the empty space has been trimmed around the image.
   */
  public var trimmed(default, null): Bool;

  /**
   * The Source rect in the sprite sheet without trimming.
   */
  public var sourceRect(default, null): Rect;

  /**
   * The size of the sprite without trimming.
   */
  public var sourceSize(default, null): Size;

  /**
   * Create a new frame from atlas data.
   * @param frameInfo The atlas data for the frame.
   * @return The created frame.
   */
  public static function fromTexturePackerFrame(frameInfo: Dynamic): Frame {
    final frameRect = new Rect(frameInfo.frame.x, frameInfo.frame.y, frameInfo.frame.w, frameInfo.frame.h);
    final sourceRect = new Rect(frameInfo.spriteSourceSize.x, frameInfo.spriteSourceSize.y,
        frameInfo.spriteSourceSize.w, frameInfo.spriteSourceSize.h);
    final sourceSize = new Size(frameInfo.sourceSize.w, frameInfo.sourceSize.h);

    return new Frame(frameInfo.filename, frameRect, frameInfo.trimmed, sourceRect, sourceSize);
  }

  /**
   * Create a new frame.
   * @param name The name of the frame in the atlas.
   * @param frame The frame position and size in pixels.
   * @param trimmed Is the empty space around the image trimmed.
   * @param sourceRect The frame size without trimming.
   * @param sourceSize The size without trimming.
   */
  public function new(name: String, frame: Rect, trimmed: Bool, sourceRect: Rect, sourceSize: Size) {
    this.name = name;
    this.frame = frame;
    this.trimmed = trimmed;
    this.sourceRect = sourceRect;
    this.sourceSize = sourceSize;
  }
}