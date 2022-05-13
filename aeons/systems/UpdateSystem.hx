package aeons.systems;

import aeons.components.CUpdate;
import aeons.core.Bundle;
import aeons.core.System;
import aeons.core.Updatable;

class UpdateSystem extends System implements Updatable {
  @:bundle
  var updateComps: Bundle<CUpdate>;

  public function new() {
    super();
  }

  public function update(dt: Float) {
    for (comp in updateComps) {
      comp.cUpdate.update(dt);
    }
  }
}
