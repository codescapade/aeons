package aeons.systems;

import aeons.bundles.Bundle;
import aeons.components.CAnimation;
import aeons.components.CSprite;
import aeons.core.System;
import aeons.core.Updatable;

/**
 * Handles updating of the `CAnimation` components.
 */
class SAnimation extends System implements Updatable {
  @:bundle
  var animBundles: Bundle<CAnimation, CSprite>;

  /**
   * Initialize the system.
   * @return This system.
   */
  public function create(): SAnimation {
    return this;
  }

  /**
   * Called every update cycle.
   * @param dt The time passed since the last update in seconds.
   */
  public function update(dt: Float) {
    // Update the sprite components with the new frame from the animation components.
    for (bundle in animBundles) {
      if (!bundle.cAnimation.active) {
        continue;
      }
      final anim = bundle.cAnimation;
      anim.updateAnim(dt);
      if (anim.currentFrame != null) {
        bundle.cSprite.setFrame(anim.currentFrame, anim.atlas);
      }
    }
  }
}
