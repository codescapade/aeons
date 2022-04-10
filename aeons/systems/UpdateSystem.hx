package aeons.systems;

import aeons.core.Updatable;
import aeons.components.CUpdate;
import aeons.core.Bundle;
import aeons.core.System;

class UpdateSystem extends System implements Updatable {

  @:bundle
  var updateComps: Bundle<CUpdate>;

  public function new() {
    super();
  }

  public function update(dt: Float) {
    for (comp in updateComps) {
      comp.c_update.update(dt);
    }
  }
}
