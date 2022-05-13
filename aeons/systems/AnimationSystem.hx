package aeons.systems;

import aeons.components.CAnimation;
import aeons.components.CSprite;
import aeons.core.Bundle;
import aeons.core.System;
import aeons.core.Updatable;

/**
 * Handles updating of the `CAnimation` components.
 */
class AnimationSystem extends System implements Updatable {
  @:bundle
  var animBundles: Bundle<CAnimation, CSprite>;

  /**
   * Constructor.
   */
  public function new() {
    super();
  }

  /**
   * Called every update cycle.
   * @param dt The time passed since the last update in seconds.
   */
  public function update(dt: Float) {
    // Update the sprite components with the new frame from the animation components.
    for (bundle in animBundles) {
      final anim = bundle.cAnimation;
      anim.updateAnim(dt);
      if (anim.currentFrame != null) {
        bundle.cSprite.setFrame(anim.currentFrame, anim.atlas);
      }
    }
  }
}
