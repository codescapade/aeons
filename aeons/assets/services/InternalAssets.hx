package aeons.assets.services;

import aeons.audio.Sound;
import aeons.graphics.Font;
import aeons.graphics.Image;
import aeons.graphics.Video;
import aeons.graphics.atlas.Atlas;
import aeons.utils.Blob;

import haxe.Exception;

/**
 * InternalAssets is the main Assets implementation.
 */
@:dox(hide)
class InternalAssets implements Assets {
  /**
   * The added sprite atlasses.
   */
  final atlasses = new Map<String, Atlas>();

  /**
   * PrimaryAssets constructor.
   */
  public function new() {}

  public inline function loadImage(name: String, complete: (Image)->Void) {
    kha.Assets.loadImage(name, complete, failed);
  }

  public inline function unloadImage(name: String) {
    Reflect.callMethod(kha.Assets.images, Reflect.field(kha.Assets.images, '${name}Unload'), []);
  }

  public inline function getImage(name: String): Image {
    try {
      return kha.Assets.images.get(name);
    } catch (e: Exception) {
      trace('Image ${name} is not loaded.');

      return null;
    }
  }

  public inline function loadFont(name: String, complete: (Font)->Void) {
    kha.Assets.loadFont(name, complete, failed);
  }

  public inline function unloadFont(name: String) {
    Reflect.callMethod(kha.Assets.fonts, Reflect.field(kha.Assets.fonts, '${name}Unload'), []);
  }

  public inline function getFont(name: String): Font {
    try {
      return kha.Assets.fonts.get(name);
    } catch (_) {
      trace('Font ${name} is not loaded.');

      return null;
    }
  }

  public inline function loadBlob(name: String, complete: (Blob)->Void) {
    kha.Assets.loadBlob(name, complete, failed);
  }

  public inline function unloadBlob(name: String) {
    kha.Assets.blobs.get(name).unload();
    Reflect.callMethod(kha.Assets.blobs, Reflect.field(kha.Assets.blobs, '${name}Unload'), []);
  }

  public inline function getBlob(name: String): Blob {
    try {
      return kha.Assets.blobs.get(name);
    } catch (_) {
      trace('Blob ${name} is not loaded.');

      return null;
    }
  }

  public inline function loadSound(name: String, complete: (Sound)->Void) {
    kha.Assets.loadSound(name, complete, failed);
  }

  public inline function unloadSound(name: String) {
    kha.Assets.sounds.get(name).unload();
    Reflect.callMethod(kha.Assets.sounds, Reflect.field(kha.Assets.sounds, '${name}Unload'), []);
  }

  public inline function getSound(name: String): Sound {
    try {
      return kha.Assets.sounds.get(name);
    } catch (_) {
      trace('Sound ${name} is not loaded.');

      return null;
    }
  }

  public inline function loadVideo(name: String, complete: (Video)->Void) {
    kha.Assets.loadVideo(name, complete, failed);
  }

  public inline function unloadVideo(name: String) {
    Reflect.callMethod(kha.Assets.videos, Reflect.field(kha.Assets.videos, '${name}Unload'), []);
  }

  public inline function getVideo(name: String): Video {
    try {
      return kha.Assets.videos.get(name);
    } catch (_) {
      trace('Video ${name} is not loaded.');

      return null;
    }
  }

  public function loadAtlas(name: String): Atlas {
    final image = getImage(name);
    final data = getBlob('${name}_json');

    if (image == null || data == null) {
      trace('Unable to load atlas ${name}.');

      return null;
    }

    final atlas = new Atlas(image, data.toString());
    atlasses.set(name, atlas);

    return atlas;
  }

  public function unLoadAtlas(name: String) {
    if (atlasses.exists(name)) {
      atlasses[name].cleanup();
    }
    atlasses.remove(name);
  }

  public inline function getAtlas(name: String): Atlas {
    return atlasses[name];
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