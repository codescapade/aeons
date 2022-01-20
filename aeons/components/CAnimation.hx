package aeons.components;

import aeons.graphics.texturepacker.SpriteSheet;
import aeons.core.Component;
import aeons.graphics.texturepacker.Frame;
import aeons.graphics.animation.Animation;

/**
 * The Animation component can play added animations.
 */
class CAnimation extends Component {

  /**
   * Is the current animation playing.
   */
  public var playing(default, null) = false;

  /**
   * The name of the current animation.
   */
  public var current(get, never): String;

  /**
   * The current animation frame name.
   */
  public var currentFrame(default, null): String;

  /**
   * The sprite sheet of the current animation.
   */
  public var spriteSheet(get, never): SpriteSheet;

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
  var time = 0.0;

  /**
   * Dictionary of animations added to the component.
   */
  var anims = new Map<String, Animation>();

  /**
   * Initialize the component.
   * @return A reference to this component.
   */
  public function init(): CAnimation {

    return this;
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
   * restarts
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
   * @param name The name of the animation. Used when you want to play.
   * @param animation The animation you want to add.
   */
  public inline function add(name: String, animation: Animation) {
    anims[name] = animation;
  }

  /**
   * Remove an animation.
   * @param name The name of the animation you want to remove.
   */
  public inline function remove(name: String) {
    anims.remove(name);
  }

  /**
   * Current animation name getter.
   */
  inline function get_current(): String {
    return anim == null ? '' : anim.name;
  }

  /**
   * Is the animation finished getter.
   */
  inline function get_finished(): Bool {
    return anim == null ? true : anim.finished(time);
  }

  /**
   * Sprite sheet getter.
   */
  inline function get_spriteSheet(): SpriteSheet {
    return anim == null ? null : anim.sheet;
  }
}