package scenes;

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
    Aeons.systems.addSystem(RenderSystem).init();

    // var atlas = assets.loadAtlas('atlas');
    var atlas: Atlas;
    Aeons.assets.loadAtlas('atlas', (at: Atlas) -> {
      atlas = at;
    });

    var eCam = Aeons.entities.addEntity(Entity);
    eCam.addComponent(CTransform).init();
    eCam.addComponent(CCamera).init();

    var eSprite = Aeons.entities.addEntity(Entity);
    eSprite.addComponent(CTransform).init({ x: 100, y: 100 });
    eSprite.addComponent(CSprite).init({ atlas: atlas, frameName: 'bunny' });
  }
}