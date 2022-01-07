package scenes;

import components.CSimpleUpdate;
import aeons.core.Entity;
import aeons.systems.UpdateSystem;
import aeons.graphics.RenderTarget;
import aeons.core.Scene;

class GameScene extends Scene {

  public override function init() {
    trace('this works!');
    addSystem(UpdateSystem).init();

    var e = addEntity(Entity);
    e.addComponent(CSimpleUpdate).init();
  }

  public override function update(dt: Float) {
    super.update(dt);
  }

  public override function render(target: RenderTarget) {
    super.render(target);

    target.start();
    target.drawRect(10, 10, 200, 100, Green, 4, Inside);
    target.present();
  }
}