package aeons.assets;

import aeons.audio.Sound;
import aeons.graphics.Font;
import aeons.graphics.Image;
import aeons.graphics.Video;
import aeons.graphics.atlas.Atlas;
import aeons.utils.Blob;

interface Assets {
  /**
   * Load an image asset.
   * @param name The name of the image.
   * @param complete The function to call when the loading is complete.
   */
  function loadImage(name: String, complete: (Image)->Void): Void;

  /**
   * Remove an image from memory.
   * @param name The name of the image.
   */
  function unloadImage(name: String): Void;

  /**
   * Get an image.
   * @param name The name of the image.
   * @return The image reference.
   */
  function getImage(name: String): Image;

  /**
   * Load a font asset.
   * @param name The name of the font.
   * @param complete The function to call when the loading is complete.
   */
  function loadFont(name: String, complete: (Font)->Void): Void;

  /**
   * Remove a font from memory.
   * @param name The name of the font.
   */
  function unloadFont(name: String): Void;

  /**
   * Get a font.
   * @param name The name of the font.
   * @return The font reference.
   */
  function getFont(name: String): Font;

  /**
   * Load a blob asset.
   * @param name The name of the blob.
   * @param complete The function to call when the loading is complete.
   */
  function loadBlob(name: String, complete: (Blob)->Void): Void;

  /**
   * Remove a blob from memory.
   * @param name The name of the blob.
   */
  function unloadBlob(name: String): Void;

  /**
   * Get a blob.
   * @param name The name of the blob.
   * @return The blob reference.
   */
  function getBlob(name: String): Blob;

  /**
   * Load a sound asset.
   * @param name The name of the sound.
   * @param complete The function to call when the loading is complete.
   */
  function loadSound(name: String, complete: (Sound)->Void): Void;

  /**
   * Remove a sound from memory.
   * @param name The name of the sound.
   */
  function unloadSound(name: String): Void;

  /**
   * Get a sound.
   * @param name The name of the sound.
   * @return The sound reference.
   */
  function getSound(name: String): Sound;

  /**
   * Load a video asset.
   * @param name The name of the video.
   * @param complete The function to call when the loading is complete.
   */
  function loadVideo(name: String, complete: (Video)->Void): Void;

  /**
   * Remove a video from memory.
   * @param name The name of the video.
   */
  function unloadVideo(name: String): Void;

  /**
   * Get a video.
   * @param name The name of the video.
   * @return The video reference.
   */
  function getVideo(name: String): Video;

  /**
   * Add an atlas to the manager.
   * @param name The name of this atlas.
   * @return The loaded atlas.
   */
  function loadAtlas(name: String): Atlas;

  /**
   * Remove an atlas from the asset manager.
   * @param name The name of the atlas to remove.
   */
  function unLoadAtlas(name: String): Void;

  /**
   * Get an atlas.
   * @param name The name of the atlas.
   */
  function getAtlas(name: String): Atlas;
}