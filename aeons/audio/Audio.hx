package aeons.audio;

import kha.System;

// TODO: Make audio nicer by keeping track of audio channels so muting and volume can be changed across sounds.
/**
 * `Audio` is used to play sounds and vibrate a device.
 */
class Audio {
  /**
   * Constructor.
   */
  public function new() {}

  /**
   * Play a sound.
   * @param sound The sound to play.
   * @param loop Should this sound loop.
   * @return The audio channel playing the sound.
   */
  public inline function play(sound: Sound, loop = false): AudioChannel {
    return kha.audio1.Audio.play(sound, loop);
  }

  /**
   * Vibrate the device.
   * @param time The time to vibrate in milliseconds. (Does nothing on iOS)
   */
  public inline function vibrate(time: Int): Void {
    System.vibrate(time);
  }
}