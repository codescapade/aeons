package aeons.graphics.texturepacker;

import haxe.Json;

/**
 * `SpriteSheet` is for createing a sprite sheet from a texturepacker atlas.
 */
class SpriteSheet {
  /**
   * The sprite sheet image.
   */
  public var image(default, null): Image;

  /**
   * A map with frame names to sprite frame.
   */
  var frames = new Map<String, Frame>();

  /**
   * SpriteSheet constructor.
   * @param image The image for the sheet.
   * @param data The data file text.
   */
  public function new(image: Image, data: String) {
    this.image = image;
    final spriteData = Json.parse(data);
    final frameList: Array<Dynamic> = spriteData.frames;
    for (frameInfo in frameList) {
      final frame = Frame.fromTexturePackerFrame(frameInfo);
      frames[frame.name] = frame;
    }
  }

  /**
   * Get a frame by name.
   * @param name The name of the sprite in texturepacker.
   * @return The frame. 
   */
  public function getFrame(name: String): Frame {
    final frame = frames[name];

    #if debug
    if (frame == null) {
      throw 'Frame called ${name} does not exist.';
    }
    #end

    return frame;
  }

  /**
   * Clean up the data when removing the sprite sheet.
   */
  public function cleanup() {
    image = null;
    frames.clear();
    frames = null;
  }
}