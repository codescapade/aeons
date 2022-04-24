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
   * Add a sound channel to the audio manager.
   * @param sound The sound asset for the channel.
   * @param volume The sound volume.
   * @param loop Does the sound loop.
   * @return The created sound channel.
   */
  function addChannel(sound: Sound, volume: Float = 1.0, loop: Bool = false): SoundChannel;

  /**
   * Remove a channel from the audio manager.
   * @param sound The channel to remove.
   */
  function removeChannel(channel: SoundChannel): Void;

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
