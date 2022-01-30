package aeons.assets;

import aeons.audio.Sound;
import aeons.graphics.Font;
import aeons.graphics.Image;
import aeons.graphics.Video;
import aeons.graphics.texturepacker.SpriteSheet;
import aeons.utils.Blob;

/**
 * The `Assets` class is for loading / unloading and retrieving assets.
 */
class Assets {
  /**
   * The added sprite sheets.
   */
  final spriteSheets = new Map<String, SpriteSheet>();

  /**
   * Assets constructor.
   */
  public function new() {}

  /**
   * Load an image asset.
   * @param name The name of the image.
   * @param complete The function to call when the loading is complete.
   */
  public inline function loadImage(name: String, complete: (Image)->Void) {
    kha.Assets.loadImage(name, complete, failed);
  }

  /**
   * Remove an image from memory.
   * @param name The name of the image.
   */
  public inline function unloadImage(name: String) {
    Reflect.callMethod(kha.Assets.images, Reflect.field(kha.Assets.images, '${name}Unload'), []);
  }

  /**
   * Get an image.
   * @param name The name of the image.
   * @return The image reference.
   */
  public inline function getImage(name: String): Image {
    return kha.Assets.images.get(name);
  }

  /**
   * Load a font asset.
   * @param name The name of the font.
   * @param complete The function to call when the loading is complete.
   */
  public inline function loadFont(name: String, complete: (Font)->Void) {
    kha.Assets.loadFont(name, complete, failed);
  }

  /**
   * Remove a font from memory.
   * @param name The name of the font.
   */
  public inline function unloadFont(name: String) {
    Reflect.callMethod(kha.Assets.fonts, Reflect.field(kha.Assets.fonts, '${name}Unload'), []);
  }

  /**
   * Get a font.
   * @param name The name of the font.
   * @return The font reference.
   */
  public inline function getFont(name: String): Font {
    return kha.Assets.fonts.get(name);
  }

  /**
   * Load a blob asset.
   * @param name The name of the blob.
   * @param complete The function to call when the loading is complete.
   */
  public inline function loadBlob(name: String, complete: (Blob)->Void) {
    kha.Assets.loadBlob(name, complete, failed);
  }

  /**
   * Remove a blob from memory.
   * @param name The name of the blob.
   */
  public inline function unloadBlob(name: String) {
    kha.Assets.blobs.get(name).unload();
    Reflect.callMethod(kha.Assets.blobs, Reflect.field(kha.Assets.blobs, '${name}Unload'), []);
  }

  /**
   * Get a blob.
   * @param name The name of the blob.
   * @return The blob reference.
   */
  public inline function getBlob(name: String): Blob {
    return kha.Assets.blobs.get(name);
  }

  /**
   * Load a sound asset.
   * @param name The name of the sound.
   * @param complete The function to call when the loading is complete.
   */
  public inline function loadSound(name: String, complete: (Sound)->Void) {
    kha.Assets.loadSound(name, complete, failed);
  }

  /**
   * Remove a sound from memory.
   * @param name The name of the sound.
   */
  public inline function unloadSound(name: String) {
    kha.Assets.sounds.get(name).unload();
    Reflect.callMethod(kha.Assets.sounds, Reflect.field(kha.Assets.sounds, '${name}Unload'), []);
  }

  /**
   * Get a sound.
   * @param name The name of the sound.
   * @return The sound reference.
   */
  public inline function getSound(name: String): Sound {
    return kha.Assets.sounds.get(name);
  }

  /**
   * Load a video asset.
   * @param name The name of the video.
   * @param complete The function to call when the loading is complete.
   */
  public inline function loadVideo(name: String, complete: (Video)->Void) {
    kha.Assets.loadVideo(name, complete, failed);
  }

  /**
   * Remove a video from memory.
   * @param name The name of the video.
   */
  public inline function unloadVideo(name: String) {
    Reflect.callMethod(kha.Assets.videos, Reflect.field(kha.Assets.videos, '${name}Unload'), []);
  }

  /**
   * Get a video.
   * @param name The name of the video.
   * @return The video reference.
   */
  public inline function getVideo(name: String): Video {
    return kha.Assets.videos.get(name);
  }

  /**
   * Add a sprite sheet to the manager.
   * @param name The name for this sprite sheet.
   * @param imagePath The image asset path.
   * @param dataPath The data asset path.
   * @return The loaded sprite sheet.
   */
  public function loadSheet(name: String, imagePath: String, dataPath: String): SpriteSheet {
    var sheet = new SpriteSheet(getImage(imagePath), getBlob(dataPath).toString());
    spriteSheets.set(name, sheet);

    return sheet;
  }

  /**
   * Remove a sheet from the asset manager.
   * @param name The name of the sheet to remove.
   */
  public function unLoadSheet(name: String) {
    if (spriteSheets.exists(name)) {
      spriteSheets[name].cleanup();
    }
    spriteSheets.remove(name);
  }

  /**
   * Get a sprite sheet.
   * @param name The name of the sheet.
   */
  public inline function getSheet(name: String): SpriteSheet {
    return spriteSheets[name];
  }

  /**
   * Function that gets called when loading an asset fails.
   * @param assetError The error to print.
   */
  inline function failed(assetError: AssetError) {
    if (assetError.error != null) {
      throw assetError.error;
    }
    throw 'Asset failed to load ${assetError.url}';
  }
}