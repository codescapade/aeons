package aeons.audio;

/**
 * Audio is used to play sounds and vibrate a device.
 */
interface Audio {

  /**
   * Play a sound.
   * @param sound The sound to play.
   * @param loop Should this sound loop.
   * @return The audio channel playing the sound.
   */
  function play(sound: Sound, loop: Bool = false): AudioChannel;

  /**
   * Vibrate the device.
   * @param time The time to vibrate in milliseconds. (Does nothing on iOS)
   */
  function vibrate(time: Int): Void;
}
