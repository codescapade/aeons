package aeons.core.services;

import aeons.graphics.RenderTarget;

@:dox(hide)
class NullSystems implements Systems {
  public function new() {}

  public function add<T: System>(systemType: Class<T>, priority = 0): T {
    trace('add is not implemented');

    return null;
  }

  public function remove(systemType: Class<System>) {
    trace('remove is not implemented');
  }

  public function get<T: System>(systemType: Class<T>): T {
    trace('get is not implemented');

    return null;
  }

  public function has(systemType: Class<System>): Bool {
    trace('has is not implemented');

    return false;
  }

  public function update(dt: Float) {
    trace('update is not implemented');
  }

  public function render(target: RenderTarget) {
    trace('render is not implemented');
  }

  public function getDebugRenderSystems(): Array<DebugRenderable> {
    trace('getDebugRenderSystems is not implemented');

    return [];
  }

  public function sort() {
    trace('sort is not implemented');
  }
}
