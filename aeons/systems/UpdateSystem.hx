package aeons.systems;

import aeons.core.Updatable;
import aeons.components.CRender;
import aeons.components.CUpdate;
import aeons.core.Bundle;
import aeons.core.System;

class UpdateSystem extends System implements Updatable {

  var updateComps: Bundle<CUpdate>;

  public function init(): UpdateSystem {
    return this;
  }

  public function update(dt: Float) {
    for (comp in updateComps) {
      comp.c_update.update(dt);
    }
  }
}