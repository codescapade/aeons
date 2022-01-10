package scenes;

import entities.ETest;
import aeons.core.Scene;

class TestScene extends Scene {

  public override function init() {
    trace('testing');

    var e = addEntity(ETest).init();
    trace(e.test);

    var first = true;
    var test = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
    for (t in test) {
      trace(t);
      if (t == 5 && first) {
        first = false;
        test.unshift(50);
      }
    }
    // var ee: ETest = getEntityById(e.id);
    // trace(ee.test);
  }
}