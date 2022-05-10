package aeons.systems;

import aeons.components.CCamera;
import aeons.components.CRender;
import aeons.components.CTransform;
import aeons.core.Bundle;
import aeons.core.SysRenderable;
import aeons.core.System;
import aeons.events.SortEvent;
import aeons.graphics.Color;
import aeons.graphics.RenderTarget;
import aeons.math.Rect;
import aeons.math.Vector2;

using aeons.utils.TimSort;

/**
 * The RenderSystem renders everything on screen.
 */
class RenderSystem extends System implements SysRenderable {
  /**
   * All camera bundles in the scene.
   */
  @:bundle
  var cameraBundles: Bundle<CCamera, CTransform>;

  /**
   * All renderable bundles in the scene.
   */
  @:bundle
  var renderBundles: Bundle<CRender, CTransform>;

  /**
   * Should the bundles be sorted the next frame.
   */
  var sortZ: Bool = false;

  /**
   * Constructor.
   */
  public function new() {
    super();
  }

  /**
   * Gets called every frame.
   * @param target The main render target.
   */
  public function render(target: RenderTarget) {
    // Sort all bundles if required.
    if (sortZ) {
      renderBundles.bundles.timSort(sort);
    }

    /**
     * Update all transforms so the multiply further down goes correct.
     */
    for (renderable in renderBundles) {
      renderable.c_transform.updateMatrix();
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
      camTarget.start(true, camera.backgroundColor);
      for (renderable in renderBundles) {
        if (renderable.c_transform.containsParent(camTransform)) {
          camTarget.transform.setFrom(renderable.c_transform.matrix);
          renderable.c_render.render(camTarget);
        } else {
          boundsPos.set(camera.bounds.x, camera.bounds.y);
          renderable.c_transform.worldToLocalPosition(boundsPos);
          boundsPos.x = boundsPos.x - renderable.c_transform.x;
          boundsPos.y = boundsPos.y - renderable.c_transform.y;
          localBounds.x = boundsPos.x;
          localBounds.y = boundsPos.y;

          // Only render components that are inside the camera bounds.
          if (renderable.c_render.inCameraBounds(localBounds)) {
            camTarget.transform.setFrom(camera.matrix.multmat(renderable.c_transform.matrix));
            renderable.c_render.render(camTarget);
          }
        }
      }

      boundsPos.put();
      camTarget.present();
    }

    for (renderable in renderBundles) {
      renderable.c_transform.resetChanged();
    }

    // Render all cameras to the main target.
    target.start();
    for (camBundle in cameraBundles) {
      final camera = camBundle.c_camera;
      target.drawImage(camera.viewX, camera.viewY, camera.renderTarget.image, Color.White);
    }
    target.present();
  }

  /**
   * The sort z event listener.
   * @param event The sort event.
   */
  function sortListener(event: SortEvent) {
    sortZ = true;
  }

  /**
   * Sort function for render bundles.
   * Have to use the full path for the bundles because they don't exist before the macros create them.
   * @param a The first bundle.
   * @param b The next bundle.
   */
  function sort(a: aeons.bundles.BundleCRenderCTransform, b: aeons.bundles.BundleCRenderCTransform) {
    if (a.c_transform.zIndex > b.c_transform.zIndex) {
      return 1;
    } else if (a.c_transform.zIndex < b.c_transform.zIndex) {
      return -1;
    }

    return 0;
  }
}
