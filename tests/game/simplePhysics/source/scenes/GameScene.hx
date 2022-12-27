package scenes;

import aeons.math.Vector2;
import aeons.events.input.MouseEvent;
import aeons.components.CSimpleBody;
import aeons.systems.SSimplePhysics;
import aeons.Aeons;
import aeons.components.CBoxShape;
import aeons.components.CCamera;
import aeons.components.CLayer;
import aeons.components.CTransform;
import aeons.core.Entity;
import aeons.core.Scene;
import aeons.graphics.Color;
import aeons.systems.SRender;

class GameScene extends Scene {
  public override function create() {
    addSystem(SSimplePhysics).create({
      worldWidth: Aeons.display.viewWidth,
      worldHeight: Aeons.display.viewHeight,
      gravity: { x: 0, y: 700 }
    });
    addSystem(SRender).create();

    createCamera();
    createBox(Aeons.display.viewCenterX, Aeons.display.viewHeight - 20, Aeons.display.viewWidth, 40, Color.White, true);

    Aeons.events.on(MouseEvent.MOUSE_DOWN, mouseDown);
  }

  function createCamera() {
    final camera = addEntity(Entity);
    camera.addComponent(CTransform).create();
    camera.addComponent(CCamera).create();
  }

  function createBox(x: Int, y: Int, width: Int, height: Int, color: Color, isStatic = false) {
    final box = addEntity(Entity);
    box.addComponent(CTransform).create({
      x: x,
      y: y
    });

    box.addComponent(CBoxShape).create({
      width: width,
      height: height,
      hasStroke: false,
      filled: true,
      fillColor: color
    });

    box.addComponent(CLayer).create();

    final body = box.addComponent(CSimpleBody).create({ width: width, height: height });
    if (isStatic) {
      body.type = STATIC;
    }
  }

  function mouseDown(event: MouseEvent) {
    final pos = Vector2.get();
    CCamera.main.screenToView(event.x, event.y, pos);

    final width = Aeons.random.int(40, 60);
    final height = Aeons.random.int(40, 60);
    final color = Color.fromFloats(Aeons.random.float(), Aeons.random.float(), Aeons.random.float());

    createBox(Std.int(pos.x), Std.int(pos.y), width, height, color);
    pos.put();
  }
}
