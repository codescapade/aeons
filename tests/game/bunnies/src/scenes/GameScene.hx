package scenes;

import aeons.graphics.RenderTarget;
import aeons.core.Scene;

class GameScene extends Scene {

  public override function init() {
    trace('this works!');
  }

  public override function update(dt: Float) {
    
  }

  public override function render(target: RenderTarget) {
    target.start();
    target.drawRect(10, 10, 200, 100, Green, 4, Inside);
    target.present();
  }
}