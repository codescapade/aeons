package aeons.tween;

/**
* `Tweens` is the tween manager.
*/
@:allow(aeons.core.Scene)
class Tweens {
  /**
   * Current active tweens.
   */
  final tweens: Array<Tween> = [];

  /**
   * Tween that completed but are in the active tweens.
   */
  final completed: Array<Tween> = [];

  /**
   * Create a new tween.
   * @param target The target to tween.
   * @param duration The duration in seconds.
   * @param properties The properties of the target class to tween.
   */
  public function create(target: Dynamic, duration: Float, properties: Dynamic): Tween {
    final tween = Tween.get(target, duration, properties);
    tweens.push(tween);

    return tween;
  }

  /**
   * Pause all tweens.
   */
  public function pauseAll() {
    for (tween in tweens) {
      tween.pause();
    }
  }

  /**
   * Resume all tweens.
   */
  public function resumeAll() {
    for (tween in tweens) {
      tween.resume();
    }
  }

  /**
   * Remove a tween.
   * @param tween 
   */
  public function remove(tween: Tween) {
    tweens.remove(tween);
    tween.put();
  }

  /**
   * Remove all tweens from a target.
   * @param target 
   */
  public function removeAllFrom(target: Dynamic) {
    final tweensToRemove: Array<Tween> = [];
    for (tween in tweens) {
      if (tween.target == target) {
        tweensToRemove.push(tween);
      }
    }
    for (tween in tweensToRemove) {
      tweens.remove(tween);
      tween.put();
    }
  }

  /**
   * Tweens constructor.
   */
  function new() {}

  /**
   * Update all active tweens.
   * @param dt Time passed since the last update in seconds.
   */
  function update(dt: Float) {
    for (tween in tweens) {
      tween.update(dt);
      if (tween.complete) {
        completed.push(tween);
      }
    }

    // Remove completed tweens.
    while (completed.length > 0) {
      final tween = completed.pop();
      tweens.remove(tween);
      tween.runComplete();
      tween.put();
    }
  }

  /**
   * Clear all active tweens.
   */
  function clear() {
    while (tweens.length > 0) {
      tweens.pop();
    }

    while (completed.length > 0) {
      completed.pop();
    }
    Tween.clearPool();
  }
}