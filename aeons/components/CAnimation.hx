package aeons.components;

import aeons.core.Component;
import aeons.graphics.animation.Animation;
import aeons.graphics.atlas.Atlas;

/**
 * The Animation component can play added animations.
 */
class CAnimation extends Component {
  /**
   * Is the current animation playing.
   */
  public var playing(default, null): Bool;

  /**
   * The name of the current animation.
   */
  public var current(get, never): String;

  /**
   * The current animation frame name.
   */
  public var currentFrame(default, null): String;

  /**
   * The atlas of the current animation.
   */
  public var atlas(get, never): Atlas;

  /**
   * Has the current animation finished.
   */
  public var finished(get, never): Bool;

  /**
   * The current animation.
   */
  var anim: Animation;

  /**
   * Animation play time.
   */
  var time: Float;

  /**
   * Dictionary of animations added to the component.
   */
  var anims: Map<String, Animation>;

  /**
   * CAnimation constructor.
   * @param animations Optional list of animations to add to the component.
   */
  public function new(?animations: Array<Animation>) {
    super();
    playing = false;
    currentFrame = null;
    anim = null;
    time = 0.0;
    anims = new Map<String, Animation>();

    if (animations != null) {
      for (animation in animations) {
        anims[animation.name] = animation;
      }
    }
  }

  /**
   * Updates the current animation frame. Gets called by the animation system.
   * @param dt The time passed since the last update in seconds.
   */
  public function updateAnim(dt: Float) {
    if (playing && anim != null && !finished) {
      time += dt;
      currentFrame = anim.getFrameName(time);
    }
  }

  /**
   * Play an animation. This plays from the start. If you don't include a new animation the current animation
   * restarts.
   * @param name The name of the new animation.
   */
  public function play(?name: String) {
    time = 0;
    if (name != null) {
      if (anims.exists(name)) {
        anim = anims[name];
      }
    }

    playing = true;
  }

  /**
   * Stop the animation.
   */
  public inline function stop() {
    playing = false;
  }

  /**
   * Resume the animation.
   */
  public inline function resume() {
    playing = true;
  }

  /**
   * Add a new animation.
   * @param animation The animation you want to add.
   */
  public inline function add(animation: Animation) {
    anims[animation.name] = animation;
  }

  /**
   * Get an animation that has been added.
   * @param name The name of the animation.
   * @return The animation.
   */
  public inline function getByName(name: String): Animation {
    return anims[name];
  }

  /**
   * Remove an animation.
   * @param name The name of the animation you want to remove.
   */
  public inline function remove(name: String) {
    anims.remove(name);
  }

  inline function get_current(): String {
    return anim == null ? '' : anim.name;
  }

  inline function get_finished(): Bool {
    return anim == null ? true : anim.finished(time);
  }

  inline function get_atlas(): Atlas {
    return anim == null ? null : anim.atlas;
  }
}
