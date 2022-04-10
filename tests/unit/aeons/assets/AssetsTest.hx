package aeons.assets;

import aeons.assets.services.InternalAssets;
import aeons.audio.Sound;
import aeons.graphics.Font;
import aeons.graphics.Image;
import aeons.graphics.Video;
import aeons.utils.Blob;

import buddy.BuddySuite;

using buddy.Should;

class AssetsTest extends BuddySuite {

  public function new() {
    describe('aeons.assets.Assets Tests.', {
      var assets: Assets;

      beforeAll((done) -> {
        KhaRunner.startKha(done);
      });

      beforeEach({
        assets = new InternalAssets();
      });

      it('Should load an image.', (done) -> {
        assets.loadImage('tiles', (image: Image) -> {
          image.should.not.be(null);
          assets.unloadImage('tiles');
          done();
        });
      });

      it('Should throw when an image can\'t be loaded.', () -> {
        assets.loadImage.bind('noImage', (_) -> {}).should.throwAnything();
      });

      it('Should get an image.', (done) -> {
        assets.loadImage('tiles', (_) -> {
          final image = assets.getImage('tiles');
          image.should.not.be(null);
          assets.unloadImage('tiles');
          done();
        });
      });

      it('Should unload an image.', (done) -> {
        var image = assets.getImage('tiles');
        image.should.be(null);

        assets.loadImage('tiles', (_) -> {
          image = assets.getImage('tiles');
          image.should.not.be(null);

          assets.unloadImage('tiles');

          image = assets.getImage('tiles');
          image.should.be(null);
          done();
        });
      });

      it('Should load a font.', (done) -> {
        assets.loadFont('testFont', (font: Font) -> {
          font.should.not.be(null);
          assets.unloadFont('testFont');
          done();
        });
      });

      it('Should throw when a font can\'t be loaded.', () -> {
        assets.loadFont.bind('noFont', (_) -> {}).should.throwAnything();
      });

      it('Should get a font.', (done) -> {
        assets.loadFont('testFont', (_) -> {
          final font = assets.getFont('testFont');
          font.should.not.be(null);
          assets.unloadFont('testFont');
          done();
        });
      });

      it('Should unload a font', (done) -> {
        var font = assets.getFont('testFont');
        font.should.be(null);

        assets.loadFont('testFont', (_) -> {
          font = assets.getFont('testFont');
          font.should.not.be(null);

          assets.unloadFont('testFont');

          font = assets.getFont('testFont');
          font.should.be(null);
          done();
        });
      });

      it('Should load a sound.', (done) -> {
        assets.loadSound('testSound', (sound: Sound) -> {
          sound.should.not.be(null);
          assets.unloadSound('testSound');
          done();
        });
      });

      it('Should throw when a sound can\'t be loaded.', () -> {
        assets.loadSound.bind('noSound', (_) -> {}).should.throwAnything();
      });

      it('Should get a sound.', (done) -> {
        assets.loadSound('testSound', (_) -> {
          final sound = assets.getSound('testSound');
          sound.should.not.be(null);
          assets.unloadSound('testSound');
          done();
        });
      });

      it('Should unload a sound', (done) -> {
        var sound = assets.getSound('testSound');
        sound.should.be(null);

        assets.loadSound('testSound', (_) -> {
          sound = assets.getSound('testSound');
          sound.should.not.be(null);

          assets.unloadSound('testSound');

          sound = assets.getSound('testSound');
          sound.should.be(null);
          done();
        });
      });

      it('Should load a video.', (done) -> {
        assets.loadVideo('testVideo', (video: Video) -> {
          video.should.not.be(null);
          assets.unloadVideo('testVideo');
          done();
        });
      });

      it('Should throw when a video can\'t be loaded.', () -> {
        assets.loadVideo.bind('noVideo', (_) -> {}).should.throwAnything();
      });

      it('Should get a video.', (done) -> {
        assets.loadVideo('testVideo', (_) -> {
          final video = assets.getVideo('testVideo');
          video.should.not.be(null);
          assets.unloadVideo('testVideo');
          done();
        });
      });

      it('Should unload a video', (done) -> {
        var video = assets.getVideo('testVideo');
        video.should.be(null);

        assets.loadVideo('testVideo', (_) -> {
          video = assets.getVideo('testVideo');
          video.should.not.be(null);

          assets.unloadVideo('testVideo');

          video = assets.getVideo('testVideo');
          video.should.be(null);
          done();
        });
      });

      it('Should load a blob.', (done) -> {
        assets.loadBlob('testSprites_json', (blob: Blob) -> {
          blob.should.not.be(null);
          assets.unloadBlob('testSprites_json');
          done();
        });
      });

      it('Should throw when a blob can\'t be loaded.', () -> {
        assets.loadBlob.bind('noBlob', (_) -> {}).should.throwAnything();
      });

      it('Should get a blob.', (done) -> {
        assets.loadBlob('testSprites_json', (_) -> {
          final blob = assets.getBlob('testSprites_json');
          blob.should.not.be(null);
          assets.unloadBlob('testSprites_json');
          done();
        });
      });

      it('Should unload a blob', (done) -> {
        var blob = assets.getBlob('testSprites_json');
        blob.should.be(null);

        assets.loadBlob('testSprites_json', (_) -> {
          blob = assets.getBlob('testSprites_json');
          blob.should.not.be(null);

          assets.unloadBlob('testSprites_json');

          blob = assets.getBlob('testSprites_json');
          blob.should.be(null);
          done();
        });
      });
    });
  }
}
