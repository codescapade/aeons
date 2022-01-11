package scenes;

import aeons.events.input.KeyboardEvent;
import components.CSimpleUpdate;
import aeons.systems.UpdateSystem;
import aeons.core.Entity;
import entities.ETest;
import aeons.core.Scene;

class TestScene extends Scene {

  var entity: Entity;

  public override function init() {
    addSystem(UpdateSystem).init();

    var e = addEntity(ETest).init();
    trace(e.test);

    var ee: ETest = getEntityById(e.id);
    trace(ee.test);

    entity = addEntity(Entity);
    entity.addComponent(CSimpleUpdate).init();

    events.on(KeyboardEvent.KEY_DOWN, keyDown);
  }

  function keyDown(event: KeyboardEvent) {
    if (event.key == S) {
      if (entity.hasComponent(CSimpleUpdate)) {
        entity.removeComponent(CSimpleUpdate);
      }
    }
  }
}