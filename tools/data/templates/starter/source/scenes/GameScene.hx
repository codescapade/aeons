package scenes;

import aeons.Aeons;
import aeons.components.CBoxShape;
import aeons.components.CCamera;
import aeons.components.CTransform;
import aeons.core.Entity;
import aeons.core.Scene;
import aeons.graphics.Color;
import aeons.systems.RenderSystem;
import aeons.systems.UpdateSystem;

import components.CRotate;

class GameScene extends Scene {
  public override function init() {
    addSystem(new UpdateSystem());
    addSystem(new RenderSystem());

    createCamera();
    createBox();
  }

  function createCamera() {
    final camera = addEntity(new Entity());
    camera.addComponent(new CTransform());
    camera.addComponent(new CCamera());
  }

  function createBox() {
    final box = addEntity(new Entity());
    box.addComponent(new CTransform({
      x: Aeons.display.viewCenterX,
      y: Aeons.display.viewCenterY
    }));

    box.addComponent(new CBoxShape({
      width: 100,
      height: 100,
      hasStroke: false,
      filled: true,
      fillColor: Color.Orange
    }));

    box.addComponent(new CRotate());
  }
}
