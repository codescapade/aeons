package aeons.utils;

/**
 * The Timer class is to create timers to delay things or repeat them.
 */
class Timer {
  /**
   * True if the time is complete.
   */
  public var complete(default, null) = false;

  /**
   * True if the timer is paused.
   */
  public var paused(default, null) = false;

  /**
   * True if the timer has started.
   */
  public var started(default, null) = false;

  /**
   * Time passed in seconds.
   */
  public var time = 0.0;

  /**
   * The timer interval in seconds.
   */
  var interval: Float;

  /**
   * The function to call when the timer is completed.
   */
  var callback: ()->Void;

  /**
   * Number of repeats. -1 Repeats forever.
   */
  var repeat: Int;

  /**
   * How many times the timer has been repeated.
   */
  var repeated = 0;

  /**
   * Constructor.
   * @param interval The timer interval in seconds.
   * @param callback The function to call after the interval time has passed.
   * @param repeat How many times to repeat. -1 is infinite.
   */
  @:allow(aeons.utils.services.InternalTimers)
  function new(interval: Float, callback: Void->Void, repeat = 0) {
    this.interval = interval;
    this.callback = callback;
    this.repeat = repeat;
  }

  /**
   * Start the timer.
   */
  public function start() {
    time = 0;
    repeated = 0;
    started = true;
    complete = false;
  }

  /**
   * Stop the timer.
   */
  public inline function stop() {
    started = false;
  }

  /**
   * Pause the timer.
   */
  public inline function pause() {
    paused = true;
  }

  /**
   * Resume the timer.
   */
  public inline function resume() {
    paused = false;
  }

  /**
   * Reset the timer.
   * @param interval The timer interval in seconds.
   * @param repeat How many times to repeat. -1 is infinite.
   */
  public function reset(interval: Float, repeat: Int, startNow = false) {
    this.interval = interval;
    this.repeat = repeat;
    time = 0;
    repeated = 0;
    complete = false;
    paused = false;
    started = false;

    if (startNow) {
      start();
    }
  }

  /**
   * Update the timer.
   * @param dt The time passed since the last frame in seconds.
   */
  @:allow(aeons.utils.services.InternalTimers)
  function update(dt: Float) {
    if (!started || paused || complete) {
      return;
    }

    if (time < interval) {
      time += dt;
    } else {
      if (repeat == -1 || repeated < repeat) {
        time = 0;
        repeated++;
      } else {
        stop();
        complete = true;
      }
      callback();
    }
  }
}
