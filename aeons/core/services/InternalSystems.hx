package aeons.core.services;

import aeons.core.DebugRenderable;
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

  public function add<T: System>(systemType: Class<T>, priority = 0): T {
    final name = Type.getClassName(systemType);
    if (systemMap[name] != null) {
      throw 'System $name already exists.';
    }

    final system = Type.createInstance(systemType, []);
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
    system.priority = priority;

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

  public function render(target: RenderTarget) {
    for (system in renderSystems) {
      system.render(target);
    }
  }

  public function getDebugRenderSystems(): Array<DebugRenderable> {
    return debugRenderSystems;
  }

  public function sort() {
    updateSystems.sort((a: Updatable, b: Updatable) -> {
      final systemA: System = cast a;
      final systemB: System = cast b;

      if (systemA.priority > systemB.priority) {
        return -1;
      } else if (systemA.priority < systemB.priority) {
        return 1;
      }

      return 0;
    });

    renderSystems.sort((a: SysRenderable, b: SysRenderable) -> {
      var systemA: System = cast a;
      var systemB: System = cast b;

      if (systemA.priority > systemB.priority) {
        return -1;
      } else if (systemA.priority < systemB.priority) {
        return 1;
      }

      return 0;
    });

    debugRenderSystems.sort((a: DebugRenderable, b: DebugRenderable) -> {
      var systemA: System = cast a;
      var systemB: System = cast b;

      if (systemA.priority > systemB.priority) {
        return -1;
      } else if (systemA.priority < systemB.priority) {
        return 1;
      }

      return 0;
    });
  }
}
