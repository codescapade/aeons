package aeons.core.services;

import aeons.core.DebugRenderable;
import aeons.math.Rect;
import aeons.graphics.RenderTarget;

@:dox(hide)
class InternalSystems implements Systems {
  /**
   * All systems that are in the scene.
   */
  var systemMap = new Map<String, System>();

  /**
   * List of systems that need to be updated every frame.
   */
  var updateSystems: Array<Updatable> = [];

  /**
   * List of systems that need to render every frame.
   */
  var renderSystems: Array<SysRenderable> = [];

  /**
   * List of systems that need to debug render every frame.
   */
  var debugRenderSystems: Array<DebugRenderable> = [];

  public function new() {}

  public function add<T: System>(system: T): T {
    final systemClass = Type.getClass(system);
    final name = Type.getClassName(systemClass);
    if (systemMap[name] != null) {
      throw 'System $name already exists.';
    }

    systemMap[name] = system;

    // Add to the update systems.
    if (Std.isOfType(system, Updatable)) {
      updateSystems.push(cast system);
    }

    // Add to the render systems.
    if (Std.isOfType(system, SysRenderable)) {
      renderSystems.push(cast system);
    }

    // Add to the debug render systems.
    if (Std.isOfType(system, DebugRenderable)) {
      debugRenderSystems.push(cast system);
    }

    system.init();

    return system;
  }

  public function remove(systemType: Class<System>) {
    final name = Type.getClassName(systemType);
    final system = systemMap[name];
    if (system == null) {
      return;
    }

    systemMap.remove(name);

    // Remove from the update systems.
    if (Std.isOfType(system, Updatable)) {
      updateSystems.remove(cast system);
    }

    // Remove from the render systems.
    if (Std.isOfType(system, Renderable)) {
      renderSystems.remove(cast system);
    }

    // Remove from the debug render systems.
    if (Std.isOfType(system, DebugRenderable)) {
      debugRenderSystems.remove(cast system);
    }

    system.cleanup();
  }

  public function get<T: System>(systemType: Class<T>): T {
    final name = Type.getClassName(systemType);
    final system = systemMap[name];
    if (system == null) {
      return null;
    }

    return cast system;
  }

  public function has(systemType: Class<System>): Bool {
    final name = Type.getClassName(systemType);

    return systemMap[name] != null;
  }

  public function update(dt: Float) {
    for (system in updateSystems) {
      system.update(dt);
    }
  }

  public function render(target: RenderTarget, ?cameraBounds: Rect) {
    for (system in renderSystems) {
      system.render(target, cameraBounds);
    }
  }

  public function getDebugRenderSystems(): Array<DebugRenderable> {
    return debugRenderSystems;
  }
}