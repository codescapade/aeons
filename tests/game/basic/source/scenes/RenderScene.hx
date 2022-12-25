package scenes;

import aeons.Aeons;
import aeons.components.CCamera;
import aeons.components.CLayer;
import aeons.components.CSprite;
import aeons.components.CTransform;
import aeons.core.Entity;
import aeons.core.Scene;
import aeons.events.SceneEvent;
import aeons.events.input.KeyboardEvent;
import aeons.systems.SRender;

class RenderScene extends Scene {
  public override function create() {
    Aeons.systems.add(SRender).create();

    var atlas = Aeons.assets.loadAtlas('atlas');

    final eCam = Aeons.entities.addEntity(Entity);
    eCam.addComponent(CTransform).create();
    eCam.addComponent(CCamera).create();

    final eSprite = Aeons.entities.addEntity(Entity);
    eSprite.addComponent(CTransform).create({ x: 100, y: 100 });
    eSprite.addComponent(CSprite).create({ atlas: atlas, frameName: 'bunny' });
    eSprite.addComponent(CLayer).create();

    Aeons.events.on(KeyboardEvent.KEY_DOWN, keyDown);
  }

  function keyDown(event: KeyboardEvent) {
    SceneEvent.emit(SceneEvent.REPLACE, RenderScene);
  }
}
