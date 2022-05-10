package aeons.utils;

interface Timers {
  /**
   * Create a new timer.
   * @param interval Interval to trigger the callback in seconds.
   * @param callback The function to call on trigger.
   * @param repeat How many times to repeat the timer. -1 is infinite.
   * @param startNow Should the timer start now.
   * @return The created timer.
   */
  function create(interval: Float, callback: ()->Void, repeat: Int, startNow: Bool = false): Timer;

  /**
   * Update all timers.
   * @param dt Time passed since last update in seconds.
   */
  function update(dt: Float): Void;

  /**
   * Remove a timer.
   * @param timer The timer to remove.
   */
  function remove(timer: Timer): Void;
}
