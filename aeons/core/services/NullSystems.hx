package aeons.core.services;

import aeons.math.Rect;
import aeons.graphics.RenderTarget;

class NullSystems implements Systems {

  public function new() {}

  public function addSystem<T: System>(systemType: Class<T>): T {
    trace('addSystem is not implemented');

    return null;
  }

  public function removeSystem(systemType: Class<System>) {
    trace('removeSystem is not implemented');
  }

	public function getSystem<T: System>(systemType: Class<T>): T {
    trace('getSystem is not implemented');

    return null;
	}

	public function hasSystem(systemType: Class<System>): Bool {
    trace('hasSystem is not implemented');

    return false;
	}

  public function update(dt: Float) {
    trace('update is not implemented');
  }

  public function render(target: RenderTarget, ?cameraBounds: Rect) {
    trace('render is not implemented');
  }
}