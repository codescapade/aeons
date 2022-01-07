package aeons.utils;

/**
 * The `Timers` class managers all timers.
 */
 class Timers {
  /**
   * List of current timers.
   */
  final timers: Array<Timer> = [];

  /**
   * Timers constructor.
   */
  public function new() {}

  /**
   * Create a new timer.
   * @param interval Interval to trigger the callback in seconds.
   * @param callback The function to call on trigger.
   * @param repeat How many times to repeat the timer. -1 is infinite.
   * @param startNow Should the timer start now.
   * @return The created timer.
   */
  public function create(interval: Float, callback: Void->Void, repeat: Int, startNow = false): Timer {
    final timer = new Timer(interval, callback, repeat);
    timers.push(timer);

    if (startNow) {
      timer.start();
    }

    return timer;
  }

  /**
   * Remove a timer.
   * @param timer The timer to remove.
   */
  public inline function remove(timer: Timer) {
    timers.remove(timer);
  }

  /**
   * Update all timers.
   * @param dt Time passed since last update in seconds.
   */
  @:allow(aeons.core.Scene)
  function update(dt: Float) {
    for (timer in timers) {
      timer.update(dt);
    }
  }
}