package aeons.assets.services;

import aeons.audio.Sound;
import aeons.graphics.Font;
import aeons.graphics.Image;
import aeons.graphics.Video;
import aeons.graphics.atlas.Atlas;
import aeons.utils.Blob;

/**
 * `NullAssets` is an empty implementation of Assets to keep
 * the engine from crashing when no asset manager is set.
 */
class NullAssets implements Assets {

  public function new() {}

  public function loadImage(name: String, complete: (Image)->Void): Void {
    trace('loadImage not implemented');
  }

  public function unloadImage(name: String): Void {
    trace('unloadImage not implemented');
  }

  public function getImage(name: String): Image {
    trace('getImage not implemented');

    return null;
  }

  public function loadFont(name: String, complete: (Font)->Void): Void {
    trace('loadFont not implemented');
  }

  public function unloadFont(name: String): Void {
    trace('unloadFont not implemented');
  }

  public function getFont(name: String): Font {
    trace('getFont not implemented');

    return null;
  }

  public function loadBlob(name: String, complete: (Blob)->Void): Void {
    trace('loadBlob not implemented');
  }

  public function unloadBlob(name: String): Void {
    trace('unloadBlob not implemented');
  }

  public function getBlob(name: String): Blob {
    trace('getBlob not implemented');

    return null;
  }

  public function loadSound(name: String, complete: (Sound)->Void): Void {
    trace('loadSound not implemented');
  }

  public function unloadSound(name: String): Void {
    trace('unloadSound not implemented');
  }

  public function getSound(name: String): Sound {
    trace('getSound not implemented');

    return null;
  }

  public function loadVideo(name: String, complete: (Video)->Void): Void {
    trace('loadVideo not implemented');
  }

  public function unloadVideo(name: String): Void {
    trace('unloadVideo not implemented');
  }

  public function getVideo(name: String): Video {
    trace('getVideo not implemented');

    return null;
  }

  public function loadAtlas(name: String, complete: (Atlas)->Void): Void {
    trace('loadAtlas not implemented');
  }

  public function unLoadAtlas(name: String): Void {
    trace('unloadAtlas not implemented');
  }

  public function getAtlas(name: String): Atlas {
    trace('getAtlas not implemented');
    return null;
  }
}