package aeons.systems;

import aeons.graphics.Color;
import aeons.events.SortEvent;
import aeons.components.CRender;
import aeons.components.CTransform;
import aeons.components.CCamera;
import aeons.core.Bundle;
import aeons.graphics.RenderTarget;
import aeons.core.SysRenderable;
import aeons.core.System;

using aeons.utils.TimSort;

class RenderSystem extends System implements SysRenderable {

  @:bundle
  var cameras: Bundle<CCamera, CTransform>;

  @:bundle
  var renderables: Bundle<CRender, CTransform>;

  var sortZ: Bool = false;

  public function init(): RenderSystem {
    return this;
  }

  public function render(target: RenderTarget) {
    if (sortZ) {
      renderables.bundles.timSort(sort);
    }

    for (renderable in renderables) {
      renderable.c_transform.updateMatrix();
    }

    for (camera in cameras) {
      var cam = camera.c_camera;
      var camTransform = camera.c_transform;
      cam.updateMatrix();
      var camTarget = cam.renderTarget;

      camTarget.start();
      for (renderable in renderables) {
        if (renderable.c_transform.containsParent(camTransform)) {
          camTarget.transform.setFrom(renderable.c_transform.matrix);
        } else {
          camTarget.transform.setFrom(camTransform.matrix.multmat(renderable.c_transform.matrix));
        }
        renderable.c_render.render(camTarget);
      }
      camTarget.present();
    }

    target.start();
    for (camera in cameras) {
      final cam = camera.c_camera;
      target.drawImage(cam.viewX, cam.viewY, cam.renderTarget.image, Color.White);
    }
    target.present();
  }

  function sortListener(event: SortEvent) {
    sortZ = true;
  }

  function sort(a: aeons.bundles.BundleCRenderCTransform, b: aeons.bundles.BundleCRenderCTransform) {
    if (a.c_transform.zIndex > b.c_transform.zIndex) {
      return 1;
    } else if (a.c_transform.zIndex < b.c_transform.zIndex) {
      return -1;
    }

    return 0;
  }
}