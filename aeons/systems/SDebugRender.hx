package aeons.systems;

import aeons.bundles.Bundle;
import aeons.components.CCamera;
import aeons.components.CDebugRender;
import aeons.components.CTransform;
import aeons.core.DebugRenderable;
import aeons.core.SysRenderable;
import aeons.core.System;
import aeons.graphics.Color;
import aeons.graphics.RenderTarget;
import aeons.math.Rect;
import aeons.math.Vector2;

/**
 * Debug render system renders `CDebugRender` components and `DebugRenderable` systems.
 * This system should be added last so it renders on top of the other rendered images.
 */
class SDebugRender extends System implements SysRenderable {
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
   * Initialize the system. This gets all systems that can be rendered using this system.
   * @return This system.
   */
  public function create(): SDebugRender {
    systems = Aeons.systems.getDebugRenderSystems();

    return this;
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
      var camera = camBundle.cCamera;
      camera.updateMatrix();
      var camTransform = camBundle.cTransform;
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
        boundsPos.set(camera.bounds.x, camera.bounds.y);
        renderable.cTransform.worldToLocalPosition(boundsPos);
        boundsPos.x = boundsPos.x - renderable.cTransform.x;
        boundsPos.y = boundsPos.y - renderable.cTransform.y;
        localBounds.x = boundsPos.x;
        localBounds.y = boundsPos.y;

        // Only render components that are inside the camera bounds.
        if (renderable.cDebugRender.inCameraBounds(localBounds) || renderable.cTransform.containsParent(camTransform)) {
          camTarget.transform.setFrom(camera.matrix.multmat(renderable.cTransform.matrix));
          renderable.cDebugRender.render(camTarget);
        }
      }

      boundsPos.put();
      camTarget.present();
    }

    // Render all cameras to the main target.
    target.start(false, Color.Transparent);
    for (camBundle in cameraBundles) {
      final camera = camBundle.cCamera;
      target.drawImage(camera.viewX, camera.viewY, camera.renderTarget.image, Color.White);
    }
    target.present();
  }
}
