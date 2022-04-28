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

class DebugRenderSystem extends System implements SysRenderable {

  public var enabled = true;

  @:bundle
  var cameraBundles: Bundle<CTransform, CCamera>;

  @:bundle
  var debugRenderBundles: Bundle<CDebugRender, CTransform>;

  var systems: Array<DebugRenderable>;

  public function new() {
    super();
  }

  public override function init() {
    systems = Aeons.systems.getDebugRenderSystems();
  }

  public function render(target:RenderTarget, ?cameraBounds: Rect) {
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

      for (renderable in debugRenderBundles) {
        if (renderable.c_transform.containsParent(camTransform)) {
          camTarget.transform.setFrom(renderable.c_transform.matrix);
        } else {
          camTarget.transform.setFrom(camera.matrix.multmat(renderable.c_transform.matrix));
        }
        boundsPos.set(camera.bounds.x, camera.bounds.y);
        renderable.c_transform.worldToLocalPosition(boundsPos);
        localBounds.x = boundsPos.x;
        localBounds.y = boundsPos.y;

        renderable.c_debug_render.render(camTarget);
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
