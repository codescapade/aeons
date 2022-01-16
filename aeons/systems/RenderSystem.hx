package aeons.systems;

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