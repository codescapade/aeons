package scenes;

import components.CSimpleUpdate;
import aeons.core.Entity;
import aeons.systems.UpdateSystem;
import aeons.graphics.RenderTarget;
import aeons.core.Scene;
import aeons.events.input.KeyboardEvent;

class GameScene extends Scene {

  var entity: Entity;
  public override function init() {
    trace('this works!');
    addSystem(UpdateSystem).init();

    entity = addEntity(Entity);
    entity.addComponent(CSimpleUpdate).init();

    events.on(KeyboardEvent.KEY_DOWN, keyDown);
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

  function keyDown(event: KeyboardEvent) {
    entity.removeComponent(CSimpleUpdate);
  }
}