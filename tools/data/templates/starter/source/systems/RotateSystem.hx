package systems;

import aeons.components.CTransform;
import aeons.core.Bundle;
import aeons.core.System;
import aeons.core.Updatable;

import components.CRotate;

class RotateSystem extends System implements Updatable {
  @:bundle
  var bundles: Bundle<CTransform, CRotate>;

  var useDeltaTime: Bool;

  public function new(options: RotateSystemOptions) {
    super();
    useDeltaTime = options.useDeltaTime;
  }

  public function update(dt: Float) {
    for (bundle in bundles) {
      if (useDeltaTime) {
        bundle.cTransform.angle += bundle.cRotate.speed * dt;
      } else {
        bundle.cTransform.angle += bundle.cRotate.speed;
      }
    }
  }
}

typedef RotateSystemOptions = {
  var useDeltaTime: Bool;
}
