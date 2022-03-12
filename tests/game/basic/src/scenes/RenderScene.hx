package scenes;

import aeons.systems.AnimationSystem;
import aeons.graphics.atlas.Atlas;
import aeons.Aeons;
import aeons.components.CSprite;
import aeons.components.CTransform;
import aeons.components.CCamera;
import aeons.core.Entity;
import aeons.systems.RenderSystem;
import aeons.core.Scene;

class RenderScene extends Scene {

  public override function init() {
    Aeons.systems.add(new RenderSystem());

    var atlas: Atlas;
    Aeons.assets.loadAtlas('atlas', (at: Atlas) -> {
      atlas = at;
    });

    final eCam = Aeons.entities.addEntity(new Entity());
    eCam.addComponent(new CTransform());
    eCam.addComponent(new CCamera());

    final eSprite = Aeons.entities.addEntity(new Entity());
    eSprite.addComponent(new CTransform({ x: 100, y: 100 }));
    eSprite.addComponent(new CSprite({ atlas: atlas, frameName: 'bunny' }));
  }
}