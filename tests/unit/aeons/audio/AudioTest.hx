package aeons.audio;

import aeons.assets.Assets;
import aeons.assets.services.InternalAssets;
import aeons.audio.Sound;
import aeons.audio.services.InternalAudio;

import buddy.BuddySuite;

using buddy.Should;

class AudioTest extends BuddySuite {
  public function new() {
    describe('aeons.audio.Audio Tests.', {
      var assets: Assets;
      var audio: Audio;

      beforeAll((done) -> {
        KhaRunner.startKha(() -> {
          assets = new InternalAssets();
          audio = new InternalAudio();
          done();
        });
      });

      it('Should play a sound.', (done) -> {
        assets.loadSound('testSound', (sound: Sound) -> {
          final channel = audio.play(sound);
          channel.should.not.be(null);
          channel.stop();
          done();
        });
      });
    });
  }
}
