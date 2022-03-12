package scenes;

import aeons.Aeons;
import aeons.components.CBoxShape;
import aeons.components.CCamera;
import aeons.components.CTransform;
import aeons.core.Entity;
import aeons.core.Scene;
import aeons.graphics.Color;
import aeons.systems.RenderSystem;

import components.CRotate;
import systems.RotateSystem;

class GameScene extends Scene {

  public override function init() {
    Aeons.systems.add(RotateSystem).init({ useDeltaTime: true });
    Aeons.systems.add(RenderSystem).init();

    createCamera();

    final box1 = createBox(Aeons.display.viewCenterX, Aeons.display.viewCenterY, 100, 100, Color.Green, 30);
    final parent = box1.getComponent(CTransform);

    createBox(-200, 0, 40, 50, Color.Red, -100, parent);
    createBox(200, 0, 70, 20, Color.Blue, 60, parent);
  }

  function createCamera() {
    final eCamera = Aeons.entities.addEntity(Entity);
    eCamera.addComponent(CTransform).init();
    eCamera.addComponent(CCamera).init();
  }

  function createBox(x: Float, y: Float, width: Float, height: Float, color: Color, speed: Float,
      ?parent: CTransform): Entity {

    final box = Aeons.entities.addEntity(Entity);

    box.addComponent(CTransform).init({
      x: x,
      y: y,
      parent: parent
    });

    box.addComponent(CBoxShape).init({
      width: width,
      height: height,
      filled: true,
      fillColor: color,
      hasStroke: false
    });

    box.addComponent(CRotate).init({
      speed: speed
    });

    return box;
  }
}