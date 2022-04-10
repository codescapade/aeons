package aeons.systems;

import aeons.components.CSprite;
import aeons.components.CAnimation;
import aeons.core.Bundle;
import aeons.core.Updatable;
import aeons.core.System;

class AnimationSystem extends System implements Updatable {

  @:bundle
  var animBundles: Bundle<CAnimation, CSprite>;

  public function new() {
    super();
  }

  public function update(dt: Float) {
    for (bundle in animBundles) {
      final anim = bundle.c_animation;
      anim.updateAnim(dt);
      if (anim.currentFrame != null) {
        bundle.c_sprite.setFrame(anim.currentFrame, anim.atlas);
      }
    }
  }
}
