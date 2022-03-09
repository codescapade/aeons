package scenes;

import aeons.components.CSprite;
import aeons.components.CTransform;
import aeons.components.CCamera;
import aeons.core.Entity;
import aeons.systems.RenderSystem;
import aeons.core.Scene;

class RenderScene extends Scene {

  public override function init() {
    addSystem(RenderSystem).init();

    var bunnyImg = assets.getImage('bunny');

    var eCam = addEntity(Entity);
    eCam.addComponent(CTransform).init();
    eCam.addComponent(CCamera).init();

    var eSprite = addEntity(Entity);
    eSprite.addComponent(CTransform).init({ x: 100, y: 100 });
    // eSprite.addComponent(CSprite).init({ image: bunnyImg });
  }
}