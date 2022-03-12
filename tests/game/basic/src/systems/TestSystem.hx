package systems;

import aeons.core.Bundle;
import components.CAdd;
import aeons.events.input.KeyboardEvent;
import aeons.core.System;

class TestSystem extends System {

  @:bundle
  var add: Bundle<CAdd>;

  public function new() {
    super();
    events.on(KeyboardEvent.KEY_DOWN, keyDown);
  }

  function keyDown(event: KeyboardEvent) {
    if (event.key == A) {
      trace(add.count);
    } else if (event.key == D) {

    }
  }
}