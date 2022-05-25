package aeons.systems;

import aeons.bundles.Bundle;
import aeons.components.CUpdate;
import aeons.core.System;
import aeons.core.Updatable;

/**
 * This system updates all components that implement updatable.
 */
class UpdateSystem extends System implements Updatable {
  @:bundle
  var updateComps: Bundle<CUpdate>;

  /**
   * Update all the components.
   * @param dt The time passed since the last update in seconds.
   */
  public function update(dt: Float) {
    for (comp in updateComps) {
      comp.cUpdate.update(dt);
    }
  }
}
