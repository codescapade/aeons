package aeons.audio.services;

/**
 * NullAudio is an empty implementation of Audio to keep
 * the engine from crashing when no audio manager is set.
 */
@:dox(hide)
class NullAudio implements Audio {
  /**
   * Constructor.
   */
  public function new() {}

  public inline function play(sound: Sound, loop = false): AudioChannel {
    trace('play not implemented');

    return null;
  }

  public inline function vibrate(time: Int): Void {
    trace('vibrate not implemented');
  }
}