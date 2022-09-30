package scenes;

import aeons.Aeons;
import aeons.components.CBoxShape;
import aeons.components.CCamera;
import aeons.components.CTransform;
import aeons.core.Entity;
import aeons.core.Scene;
import aeons.graphics.Color;
import aeons.systems.SRender;
import aeons.systems.SUpdate;

import components.CRotate;

class GameScene extends Scene {
  public override function create() {
    addSystem(SUpdate).create();
    addSystem(SRender).create();

    createCamera();
    createBox();
  }

  function createCamera() {
    final camera = addEntity(Entity);
    camera.addComponent(CTransform).create();
    camera.addComponent(CCamera).create();
  }

  function createBox() {
    final box = addEntity(Entity);
    box.addComponent(CTransform).create({
      x: Aeons.display.viewCenterX,
      y: Aeons.display.viewCenterY
    });

    box.addComponent(CBoxShape).create({
      width: 100,
      height: 100,
      hasStroke: false,
      filled: true,
      fillColor: Color.Orange
    });

    box.addComponent(CRotate).create();
  }
}
