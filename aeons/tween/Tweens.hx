package aeons.tween;

interface Tweens {
  /**
   * Create a new tween.
   * @param target The target to tween.
   * @param duration The duration in seconds.
   * @param properties The properties of the target class to tween.
   * @param isColor Is the property a color.
   */
  function create(target: Dynamic, duration: Float, properties: Dynamic, isColor: Bool = false): Tween;

  /**
   * Pause all tweens.
   */
  function pauseAll(): Void;

  /**
   * Resume all tweens.
   */
  function resumeAll(): Void;

  /**
   * Remove a tween.
   * @param tween 
   */
  function remove(tween: Tween): Void;

  /**
   * Remove all tweens from a target.
   * @param target 
   */
  function removeAllFrom(target: Dynamic): Void;

  /**
   * Update all active tweens.
   * @param dt Time passed since the last update in seconds.
   */
  function update(dt: Float): Void;

  /**
   * Clear all active tweens.
   */
  function clear(): Void;
}