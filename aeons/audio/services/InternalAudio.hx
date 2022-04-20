package aeons.audio.services;

import aeons.math.AeMath;
import kha.System;

@:dox(hide)
class InternalAudio implements Audio {
  public var masterVolume(default, set) = 1.0;

  var sounds = new Map<String, SoundChannel>();

  /**
   * Constructor.
   */
  public function new() {}

  public function addSound(name: String, sound: Sound, loop = false): SoundChannel {
    var audioChannel = kha.audio1.Audio.play(sound, loop);
    audioChannel.stop();
    var soundChannel = new SoundChannel(audioChannel, masterVolume);
    sounds[name] = soundChannel;

    return soundChannel;
  }

  public function removeSound(name: String) {
    #if debug
    if (!sounds.exists(name)) {
      trace('No sound with name ${name} loaded.');
    }
    #end

    sounds.remove(name);
  }

  public function getSoundChannel(name: String): SoundChannel {
    #if debug
    if (!sounds.exists(name)) {
      trace('No sound with name ${name} loaded.');
    }
    #end

    return sounds[name];
  }

  public function mute() {
    for (sound in sounds) {
      sound.updateMasterVolume(0);
    }
  }

  public function unMute() {
    for (sound in sounds) {
      sound.updateMasterVolume(masterVolume);
    }
  }

  public function pauseAll() {
    for (sound in sounds) {
      sound.pause();
    }
  }

  public function resumeAll() {
    for (sound in sounds) {
      sound.play();
    }
  }

  public function stopAll() {
    for (sound in sounds) {
      sound.stop();
    }
  }

  public inline function vibrate(time: Int): Void {
    System.vibrate(time);
  }

  function set_masterVolume(value: Float): Float {
    masterVolume = AeMath.clamp(value, 0.0, 1.0);
    for (sound in sounds) {
      sound.updateMasterVolume(masterVolume);
    }

    return masterVolume;
  }
}
