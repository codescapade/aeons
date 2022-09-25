package aeons.components;

import aeons.audio.Sound;
import aeons.audio.SoundChannel;
import aeons.core.Component;

/**
 * The audio component is used to play sounds or music.
 */
class CAudio extends Component {
  /**
   * The volume of the sound that plays. This is separate from the master audio.
   */
  public var volume(get, set): Float;

  /**
   * The current position in the sound.
   */
  public var position(get, set): Float;

  /**
   * Does the sound in this component loop.
   */
  public var loop(get, set): Bool;

  /**
   * The current sound in the component.
   */
  public var sound(default, null): Sound;

  /**
   * The sound channel that plays the audio.
   */
  var channel: SoundChannel;

  /**
   * Internal loop variable.
   */
  var _loop = false;

  /**
   * Initialize the component.
   * @param options The options for initialization.
   * @return This component.
   */
  public function create(options: CAudioOptions): CAudio {
    if (options.loop == null) {
      options.loop = false;
    }
    setSound(options.sound, options.loop);

    return this;
  }

  /**
   * Called when this component is removed.
   */
  public override function cleanup() {
    super.cleanup();
    Aeons.audio.removeChannel(channel);
    channel = null;
  }

  /**
   * Play the current sound in the component.
   */
  public inline function play() {
    #if debug
    if (channel == null) {
      trace('Cannot play CAudio. Channel not initialized');
    }
    #end

    channel.play();
  }

  /**
   * Pause the current sound in the component.
   */
  public function pause() {
    #if debug
    if (channel == null) {
      trace('Cannot pause CAudio. Channel not initialized');
    }
    #end

    channel.pause();
  }

  /**
   * Stop the current sound in the component.
   */
  public function stop() {
    #if debug
    if (channel == null) {
      trace('Cannot stop CAudio. Channel not initialized');
    }
    #end

    channel.stop();
  }

  /**
   * Set a new sound.
   * @param sound The new sound.
   * @param loop Should this sound loop.
   */
  public function setSound(sound: Sound, loop = false) {
    var soundVolume = 1.0;
    if (channel != null) {
      soundVolume = channel.volume;
      channel.stop();
      Aeons.audio.removeChannel(channel);
    }

    channel = Aeons.audio.addChannel(sound, soundVolume, loop);
    _loop = loop;
  }

  inline function get_volume(): Float {
    #if debug
    if (channel == null) {
      trace('Cannot get volume. Channel not available');
      return 0;
    }
    #end

    return channel.volume;
  }

  inline function set_volume(value: Float): Float {
    #if debug
    if (channel == null) {
      trace('Cannot set volume. Channel not available');
      return value;
    }
    #end

    channel.volume = value;

    return value;
  }

  inline function get_position(): Float {
    #if debug
    if (channel == null) {
      trace('Cannot get position. Channel not available');
    }
    #end

    return channel.position;
  }

  inline function set_position(value: Float): Float {
    #if debug
    if (channel == null) {
      trace('Cannot set position. Channel not available');
      return value;
    }
    #end
    channel.position = position;

    return position;
  }

  inline function get_loop(): Bool {
    return _loop;
  }

  function set_loop(value: Bool): Bool {
    _loop = value;

    // Need to re-add the sound to change the loop variable.
    if (sound != null) {
      setSound(sound, value);
    }

    return value;
  }
}

/**
 * CAudio component init options.
 */
typedef CAudioOptions = {
  /**
   * The sound to play.
   */
  var sound: Sound;

  /**
   * Should the sound loop.
   */
  var ?loop: Bool;
}
