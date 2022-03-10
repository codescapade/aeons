package aeons.utils;

interface TimeStep {
  /**
   * Delta time. The time passed since the last frame in seconds.
   */
  var dt(default, null): Float;

  /**
  * The frames per second.
  */
  var fps(default, null): Int;

  /**
   * The time scale can be used to speed up or slowed down with this variable. 1.0 is normal speed.
   */
  var timeScale: Float;

  /**
   * Update the time. Gets called every update.
   */
  function update(): Void;

  /**
   * Render function to calculate fps.
   */
  function render(): Void;

  /**
   * Reset the timeStep.
   */
  function reset(): Void;
}