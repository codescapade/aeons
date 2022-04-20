package aeons.audio;

/**
 * The sound channel is used to play a loaded sound.
 */
class SoundChannel {
  /**
   * The volume of this channel.
   */
  public var volume(get, set): Float;

  /**
   * The current position in the sound.
   */
  public var position(get, set): Float;

  /**
   * The total length of the sound.
   */
  public var length(get, never): Float;

  /**
   * True if the sound finished playing.
   */
  public var finished(get, never): Bool;

  /**
   * Used to store the volume for this channel.
   */
  var internalVolume: Float;

  /**
   * Used to store the global volume.
   */
  var internalMasterVolume: Float;

  /**
   * The kha audio channel.
   */
  var channel: kha.audio1.AudioChannel;

  /**
   * Constructor
   * @param channel The kha audio channel. 
   * @param masterVolume The global master volume.
   */
  public function new(channel: kha.audio1.AudioChannel, masterVolume: Float) {
    this.channel = channel;
    internalMasterVolume = masterVolume;
  }

  /**
   * Play the sound. This also resumes the sound after pausing.
   */
  public inline function play() {
    channel.play();
  }

  /**
   * Pause this sound.
   */
  public inline function pause() {
    channel.pause();
  }

  /**
   * Stop this sound. This resets the position back to 0 so play will start from the begining.
   */
  public inline function stop() {
    channel.stop();
  }

  /**
   * Audio manage4 can update the master volume.
   * @param value The new volume.
   */
  @:allow(aeons.audio.Audio)
  inline function updateMasterVolume(value: Float) {
    internalMasterVolume = value;

    // Call the volume setter to update the channel volume with th3 new master volume.
    volume = internalVolume;
  }

  /**
   * Volume getter.
   */
  inline function get_volume(): Float {
    return internalVolume;
  }

  /**
   * Volume setter. This also sets the kha channel volume.
   * @param value The new volume.
   */
  inline function set_volume(value: Float): Float {
    internalVolume = value;

    // Use the master volume to regulate the volume as well.
    channel.volume = internalVolume * internalMasterVolume;

    return value;
  }

  /**
   * Sound position getter.
   */
  inline function get_position(): Float {
    return channel.position;
  }

  /**
   * Sound position setter.
   */
  inline function set_position(value: Float): Float {
    channel.position = value;

    return value;
  }

  inline function get_length(): Float {
    return channel.length;
  }

  inline function get_finished(): Bool {
    return channel.finished;
  }
}
