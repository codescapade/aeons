package scenes;

import aeons.Aeons;
import aeons.components.CCamera;
import aeons.components.CTransform;
import aeons.core.Entity;
import aeons.core.Scene;
import aeons.systems.RenderSystem;

class GameScene extends Scene {

  public override function init() {
    Aeons.systems.add(RenderSystem).init();
    createCamera();

    passIn(Test);
  }

  function createCamera() {
    final eCamera = Aeons.entities.addEntity(Entity);
    eCamera.addComponent(CTransform).init();
    eCamera.addComponent(CCamera).init();
  }

  function passIn(something: Class<Test>) {
    Reflect.callMethod(something, Reflect.field(something, 'thisWorks'), []);
  }
}

class Test {
  public static function thisWorks() {
    trace('this works');
  }
}