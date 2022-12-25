package aeons.systems;

import aeons.bundles.Bundle;
import aeons.components.CCamera;
import aeons.components.CLayer;
import aeons.components.CRender;
import aeons.components.CTransform;
import aeons.core.SysRenderable;
import aeons.core.System;
import aeons.events.LayerEvent;
import aeons.graphics.Color;
import aeons.graphics.RenderTarget;
import aeons.math.Rect;
import aeons.math.Vector2;

// Container to hold layer change event updates.
private typedef LayerChange = {
  var entityId: Int;
  var currentLayer: Int;
  var newLayer: Int;
}

/**
 * The SRender system renders everything on screen.
 */
class SRender extends System implements SysRenderable {
  /**
   * All camera bundles in the scene.
   */
  @:bundle
  var cameraBundles: Bundle<CCamera, CTransform>;

  /**
   * All renderable bundles in the scene.
   */
  @:bundle
  var renderBundles: Bundle<CRender, CTransform, CLayer>;

  /**
   * The layers that will be rendered.
   */
  var layers: Array<Array<Bundle<CRender, CTransform, CLayer>>> = [];

  /**
   * All layer change events since the last render.
   */
  var layerChanges: Array<LayerChange> = [];

  /**
   * Initializes the render system.
   * @return This system.
   */
  public function create(): SRender {
    // Create 16 empty layers to start with.
    for (i in 0...16) {
      layers.push([]);
    }

    Aeons.events.on(LayerEvent.LAYER_CHANGED, layerChange);

    return this;
  }

  /**
   * Gets called every frame.
   * @param target The main render target.
   */
  public function render(target: RenderTarget) {
    // Update entities in layers that have changed layer.
    while (layerChanges.length > 0) {
      final change = layerChanges.pop();

      // Make sure the layers exist in the array.
      while (layers.length - 1 < change.newLayer) {
        layers.push([]);
      }

      // New layer component, No need to remove it from a layer.
      if (change.currentLayer == -1) {
        final bundle = renderBundles.getByEntityIt(change.entityId);
        if (bundle != null) {
          layers[change.newLayer].push(bundle);
        }
      } else {
        var bundle: Bundle<CRender, CTransform, CLayer> = null;

        for (b in layers[change.currentLayer]) {
          if (b.entity.id == change.entityId) {
            bundle = b;
            break;
          }
        }

        if (bundle == null) {
          bundle = renderBundles.getByEntityIt(change.entityId);
        }

        layers[change.newLayer].push(bundle);
      }
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

      // Render entities per layer. Lowest first.
      for (bundles in layers) {
        for (renderable in bundles) {
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
          if (renderable.cRender.inCameraBounds(localBounds) || renderable.cTransform.containsParent(camTransform)) {
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
      if (camera.pipeline != null) {
        target.setPipeline(camera.pipeline);
        if (camera.pipelineCallback != null) {
          camera.pipelineCallback(target);
        }
      }
      target.drawImage(camera.viewX, camera.viewY, camera.renderTarget.image, Color.White);
      target.present();
      target.setPipeline(null);
    }
  }

  /**
   * Called when an entity changes render layer.
   * @param event The layer change event.
   */
  function layerChange(event: LayerEvent) {
    // Add the update to the list so it can be updated next frame.
    // Add to the start of the array to thy get added in the correct order.
    layerChanges.unshift({ entityId: event.entityId, currentLayer: event.currentLayer, newLayer: event.newLayer });
  }
}
