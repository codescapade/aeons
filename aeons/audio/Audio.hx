package aeons.audio;

/**
 * Audio is used to play sounds and vibrate a device.
 */
interface Audio {
  /**
   * The master volume multiplier to adjust the volume globally.
   * Value between 0.0 and 1.0.
   */
  var masterVolume(default, set): Float;

  /**
   * Add a sound to the audio manager.
   * @param name The name of the sound.
   * @param sound The sound asset.
   * @param loop Does the sound loop.
   * @return The created sound channel.
   */
  function addSound(name: String, sound: Sound, loop: Bool = false): SoundChannel;

  /**
   * Remove a sound from the audio manager.
   * @param name The name of the sound.
   */
  function removeSound(name: String): Void;

  /**
   * Get a sound channel by name.
   * @param name The name of the channel.
   * @return The sound channel or null if it does not exist.
   */
  function getSoundChannel(name: String): SoundChannel;

  /**
   * Mute all audio.
   */
  function mute(): Void;

  /**
   * UnMute all audio.
   */
  function unMute(): Void;

  /**
   * Pause all audio.
   */
  function pauseAll(): Void;

  /**
   * Resume all audio after pausing it.
   */
  function resumeAll(): Void;

  /**
   * Stop all audio. This sets the start of all sound channels back to the start.
   */
  function stopAll(): Void;

  /**
   * Vibrate the device.
   * @param time The time to vibrate in milliseconds. (Does nothing on iOS)
   */
  function vibrate(time: Int): Void;
}
