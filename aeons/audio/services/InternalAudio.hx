package aeons.audio.services;

import kha.System;

class InternalAudio implements Audio {
  /**
   * Constructor.
   */
  public function new() {}

  public inline function play(sound: Sound, loop = false): AudioChannel {
    return kha.audio1.Audio.play(sound, loop);
  }

  public inline function vibrate(time: Int): Void {
    System.vibrate(time);
  }
}