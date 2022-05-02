package aeons.systems;

import aeons.graphics.Color;
import aeons.math.Vector2;
import aeons.components.CDebugRender;
import aeons.core.DebugRenderable;
import aeons.components.CCamera;
import aeons.components.CTransform;
import aeons.core.Bundle;
import aeons.math.Rect;
import aeons.graphics.RenderTarget;
import aeons.core.SysRenderable;
import aeons.core.System;

/**
 * Debug render system renders `CDebugRender` components and `DebugRenderable` systems.
 * This system should be added last so it renders on top of the other rendered images.
 */
class DebugRenderSystem extends System implements SysRenderable {
  /**
   * Is the system currently enabled. Can be used to toggle debug rendering.
   */
  public var enabled = true;

  @:bundle
  var cameraBundles: Bundle<CTransform, CCamera>;

  @:bundle
  var debugRenderBundles: Bundle<CDebugRender, CTransform>;

  var systems: Array<DebugRenderable>;

  /**
   * Constructor.
   */
  public function new() {
    super();
  }

  /**
   * Initialize the system. This gets all systems that can be rendered using this system.
   */
  public override function init() {
    systems = Aeons.systems.getDebugRenderSystems();
  }

  /**
   * Render the systems and components.
   * @param target The target to render to.
   */
  public function render(target: RenderTarget) {
    if (!enabled) {
      return;
    }

    // Loop through all cameras and render the entities.
    for (camBundle in cameraBundles) {
      var camera = camBundle.c_camera;
      camera.updateMatrix();
      var camTransform = camBundle.c_transform;
      var camTarget = camera.renderTarget;
      var localBounds = new Rect(0, 0, camera.bounds.width, camera.bounds.height);
      var boundsPos = Vector2.get();
      // Render all the bundles to the current camera.
      camTarget.start(false, Color.Transparent);

      camTarget.transform.setFrom(camera.matrix);
      boundsPos.set(camera.bounds.x, camera.bounds.y);
      localBounds.x = boundsPos.x;
      localBounds.y = boundsPos.y;
      for (system in systems) {
        if (system.debugDrawEnabled) {
          system.debugRender(camTarget);
        }
      }

      // Render all components.
      for (renderable in debugRenderBundles) {
        if (renderable.c_transform.containsParent(camTransform)) {
          camTarget.transform.setFrom(renderable.c_transform.matrix);
          renderable.c_debug_render.render(camTarget);
        } else {
          boundsPos.set(camera.bounds.x, camera.bounds.y);
          renderable.c_transform.worldToLocalPosition(boundsPos);
          boundsPos.x = boundsPos.x - renderable.c_transform.x;
          boundsPos.y = boundsPos.y - renderable.c_transform.y;
          localBounds.x = boundsPos.x;
          localBounds.y = boundsPos.y;

          // Only render components that are inside the camera bounds.
          if (renderable.c_debug_render.inCameraBounds(localBounds)) {
            camTarget.transform.setFrom(camera.matrix.multmat(renderable.c_transform.matrix));
            renderable.c_debug_render.render(camTarget);
          }
        }
      }

      boundsPos.put();
      camTarget.present();
    }

    // Render all cameras to the main target.
    target.start(false, Color.Transparent);
    for (camBundle in cameraBundles) {
      final camera = camBundle.c_camera;
      target.drawImage(camera.viewX, camera.viewY, camera.renderTarget.image, Color.White);
    }
    target.present();
  }
}
