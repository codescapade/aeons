package aeons.tween.services;

/**
* `Tweens` is the tween manager.
*/
class InternalTweens implements Tweens {
  /**
   * Current active tweens.
   */
  final tweens: Array<Tween> = [];

  /**
   * Tween that completed but are in the active tweens.
   */
  final completed: Array<Tween> = [];

  /**
   * Tweens constructor.
   */
  public function new() {}

  public function create(target: Dynamic, duration: Float, properties: Dynamic, isColor = false): Tween {
    final tween = Tween.get(target, duration, properties, isColor);
    tweens.push(tween);

    return tween;
  }

  public function pauseAll() {
    for (tween in tweens) {
      tween.pause();
    }
  }

  public function resumeAll() {
    for (tween in tweens) {
      tween.resume();
    }
  }

  public function remove(tween: Tween) {
    tweens.remove(tween);
    tween.put();
  }

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

  public function update(dt: Float) {
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

  public function clear() {
    while (tweens.length > 0) {
      tweens.pop();
    }

    while (completed.length > 0) {
      completed.pop();
    }
    Tween.clearPool();
  }
}