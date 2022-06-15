package aeons.audio.services;

import kha.System;

using aeons.math.AeMath;

/**
 * The standard audio implementation.
 */
@:dox(hide)
class InternalAudio implements Audio {
  public var masterVolume(default, set) = 1.0;

  var channels: Array<SoundChannel> = [];

  /**
   * Constructor.
   */
  public function new() {}

  public function addChannel(sound: Sound, volume = 1.0, loop = false): SoundChannel {
    var audioChannel = kha.audio1.Audio.play(sound, loop);
    audioChannel.stop();
    var soundChannel = new SoundChannel(audioChannel, volume, masterVolume, loop);
    channels.push(soundChannel);

    return soundChannel;
  }

  public function removeChannel(channel: SoundChannel) {
    #if debug
    if (!channels.contains(channel)) {
      trace('Channel does not exist.');
    }
    #end

    channel.stop();
    channels.remove(channel);
  }

  public function mute() {
    for (channel in channels) {
      channel.updateMasterVolume(0);
    }
  }

  public function unMute() {
    for (channel in channels) {
      channel.updateMasterVolume(masterVolume);
    }
  }

  public function pauseAll() {
    for (channel in channels) {
      channel.pause();
    }
  }

  public function resumeAll() {
    for (channel in channels) {
      channel.play();
    }
  }

  public function stopAll() {
    for (channel in channels) {
      channel.stop();
    }
  }

  public inline function vibrate(time: Int): Void {
    System.vibrate(time);
  }

  function set_masterVolume(value: Float): Float {
    masterVolume = Math.clamp(value, 0.0, 1.0);
    for (channel in channels) {
      channel.updateMasterVolume(masterVolume);
    }

    return masterVolume;
  }
}
