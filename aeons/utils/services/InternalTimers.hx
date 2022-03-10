package aeons.utils.services;

/**
 * The `Timers` class managers all timers.
 */
class InternalTimers implements Timers {
  /**
   * List of current timers.
   */
  final timers: Array<Timer> = [];

  /**
   * Timers constructor.
   */
  public function new() {}

  public function create(interval: Float, callback: ()->Void, repeat: Int, startNow = false): Timer {
    final timer = new Timer(interval, callback, repeat);
    timers.push(timer);

    if (startNow) {
      timer.start();
    }

    return timer;
  }

  public inline function remove(timer: Timer) {
    timers.remove(timer);
  }

  public function update(dt: Float) {
    for (timer in timers) {
      timer.update(dt);
    }
  }
}
