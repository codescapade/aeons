package scenes;

import aeons.Aeons;
import aeons.components.CCamera;
import aeons.components.CSprite;
import aeons.components.CTransform;
import aeons.core.Entity;
import aeons.core.Scene;
import aeons.events.SceneEvent;
import aeons.events.input.KeyboardEvent;
import aeons.systems.RenderSystem;

class RenderScene extends Scene {
  public override function init() {
    Aeons.systems.add(new RenderSystem());

    var atlas = Aeons.assets.loadAtlas('atlas');

    final eCam = Aeons.entities.addEntity(new Entity());
    eCam.addComponent(new CTransform());
    eCam.addComponent(new CCamera());

    final eSprite = Aeons.entities.addEntity(new Entity());
    eSprite.addComponent(new CTransform({ x: 100, y: 100 }));
    eSprite.addComponent(new CSprite({ atlas: atlas, frameName: 'bunny' }));

    Aeons.events.on(KeyboardEvent.KEY_DOWN, keyDown);
  }

  function keyDown(event: KeyboardEvent) {
    SceneEvent.emit(SceneEvent.REPLACE, new RenderScene());
  }
}
