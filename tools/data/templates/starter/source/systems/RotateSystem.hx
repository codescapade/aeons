package systems;

import components.CRotate;
import aeons.components.CTransform;
import aeons.core.Bundle;
import aeons.core.Updatable;
import aeons.core.System;

class RotateSystem extends System implements Updatable {

  @:bundle
  var bundles: Bundle<CTransform, CRotate>;

  var useDeltaTime: Bool;

  public function init(options: RotateSystemOptions): RotateSystem {
    useDeltaTime = options.useDeltaTime;

    return this;
  }

  public function update(dt: Float) {
    for (bundle in bundles) {
      if (useDeltaTime) {
        bundle.c_transform.angle += bundle.c_rotate.speed * dt;
      } else {
        bundle.c_transform.angle += bundle.c_rotate.speed;
      }
    }
  }
}

typedef RotateSystemOptions = {
  var useDeltaTime: Bool;
}