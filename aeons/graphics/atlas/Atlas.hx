package aeons.graphics.atlas;

import haxe.Json;

/**
 * Atlas is for createing a texture atlas.
 */
class Atlas {
  /**
   * The atlas sheet image.
   */
  public var image(default, null): Image;

  /**
   * A map with frame names to sprite frame.
   */
  var frames = new Map<String, Frame>();

  /**
   * Atlas constructor.
   * @param image The image for the atlas.
   * @param data The data file text.
   */
  public function new(image: Image, data: String) {
    this.image = image;
    final atlasData = Json.parse(data);
    final frameList: Array<Dynamic> = atlasData.frames;
    for (frameInfo in frameList) {
      final frame = Frame.fromTexturePackerFrame(frameInfo);
      frames[frame.name] = frame;
    }
  }

  /**
   * Get a frame by name.
   * @param name The name of the sprite in the atlas.
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
   * Clean up the data when removing the atlas.
   */
  public function cleanup() {
    image = null;
    frames.clear();
    frames = null;
  }
}
