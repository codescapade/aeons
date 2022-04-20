package aeons.audio.services;

/**
 * NullAudio is an empty implementation of Audio to keep
 * the engine from crashing when no audio manager is set.
 */
@:dox(hide)
class NullAudio implements Audio {

  public var masterVolume(default, set): Float;

  /**
   * Constructor.
   */
  public function new() {}

  public function addSound(name: String, sound: Sound, loop: Bool = false): SoundChannel {
    trace('addSound not implemented');

    return null;
  }

  public function removeSound(name: String) {
    trace('removeSound not implemented');
  }

  public function getSoundChannel(name: String): SoundChannel {
    trace('getSoundChannel not implemented');

    return null;
  }

  public function mute() {
    trace('mute not implemented');
  }

  public function unMute() {
    trace('unMute not implemented');
  }

  public function pauseAll() {
    trace('pauseAll not implemented');
  };

  public function resumeAll() {
    trace('resumeAll not implemented');
  }

  public function stopAll() {
    trace('stopAll not implemented');
  };

  public inline function vibrate(time: Int): Void {
    trace('vibrate not implemented');
  }

  inline function set_masterVolume(value: Float): Float {
    trace('materVolume not implemented');

    return value;
  }
}
