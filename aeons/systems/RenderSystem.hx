package aeons.systems;

import aeons.bundles.Bundle;
import aeons.components.CCamera;
import aeons.components.CRender;
import aeons.components.CTransform;
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
   * Initializes the render system. Gets called automatically after creation.
   */
  public override function init() {
    Aeons.events.on(SortEvent.SORT_Z, sortListener);
  }

  /**
   * Gets called every frame.
   * @param target The main render target.
   */
  public function render(target: RenderTarget) {
    // Sort all bundles if required.
    if (sortZ) {
      renderBundles.bundles.timSort(sort);
      sortZ = false;
    }

    /**
     * Update all transforms so the multiply further down goes correct.
     */
    for (renderable in renderBundles) {
      renderable.cTransform.updateMatrix();
    }

    // Loop through all cameras and render the entities.
    for (camBundle in cameraBundles) {
      var camera = camBundle.cCamera;
      camera.updateMatrix();
      var camTransform = camBundle.cTransform;
      var camTarget = camera.renderTarget;
      var localBounds = new Rect(0, 0, camera.bounds.width, camera.bounds.height);
      var tlPos = Vector2.get();
      var brPos = Vector2.get();
      // Render all the bundles to the current camera.
      camTarget.start(true, camera.backgroundColor);
      for (renderable in renderBundles) {
        if (renderable.cTransform.containsParent(camTransform)) {
          camTarget.transform.setFrom(renderable.cTransform.matrix);
          renderable.cRender.render(camTarget);
        } else {
          tlPos.set(camera.visibilityBounds.x, camera.visibilityBounds.y);
          brPos.set(camera.visibilityBounds.x + camera.visibilityBounds.width,
            camera.visibilityBounds.y + camera.visibilityBounds.height);
          renderable.cTransform.worldToLocalPosition(tlPos);
          renderable.cTransform.worldToLocalPosition(brPos);
          var x = Math.min(tlPos.x, brPos.x) - renderable.cTransform.x;
          var y = Math.min(tlPos.y, brPos.y) - renderable.cTransform.y;
          var width = Math.abs(tlPos.x - brPos.x);
          var height = Math.abs(tlPos.y - brPos.y);
          localBounds.set(x, y, width, height);

          // Only render components that are inside the camera bounds.
          if (renderable.cRender.inCameraBounds(localBounds)) {
            camTarget.transform.setFrom(camera.matrix.multmat(renderable.cTransform.matrix));
            renderable.cRender.render(camTarget);
          }
        }
      }

      tlPos.put();
      brPos.put();
      camTarget.present();
    }

    for (renderable in renderBundles) {
      renderable.cTransform.resetChanged();
    }

    // Render all cameras to the main target.
    target.start();
    for (camBundle in cameraBundles) {
      final camera = camBundle.cCamera;
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
    if (a.cTransform.zIndex > b.cTransform.zIndex) {
      return 1;
    } else if (a.cTransform.zIndex < b.cTransform.zIndex) {
      return -1;
    }

    return 0;
  }
}
