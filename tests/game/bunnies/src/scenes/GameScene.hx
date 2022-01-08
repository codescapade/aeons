package scenes;

import components.CSimpleUpdate;
import aeons.core.Entity;
import aeons.systems.UpdateSystem;
import aeons.graphics.RenderTarget;
import aeons.core.Scene;

using aeons.utils.TimSort;

class GameScene extends Scene {

  public override function init() {
    trace('this works!');
    addSystem(UpdateSystem).init();

    var e = addEntity(Entity);
    e.addComponent(CSimpleUpdate).init();

    var numbers = [];
    for (i in 0...300) {
      numbers.push(random.int(0, 1000));
    }
    numbers.timSort(compare);
  }

  function compare(a: Int, b: Int): Int {
    return a - b;
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