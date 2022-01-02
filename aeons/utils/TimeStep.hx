package aeons.utils;

import kha.Scheduler;

/**
 * `TimeStep` is used to calculate delta time and fps.
 */
class TimeStep {
  /**
   * Delta time. The time passed since the last frame in seconds.
   */
  public var dt(default, null): Float;

  /**
  * The frames per second.
  */
  public var fps(default, null): Int;

  /**
   * The time scale can be used to speed up or slowed down with this variable. 1.0 is normal speed.
   */
  public var timeScale = 1.0;

  /**
   * The time at the previous frame.
   */
  var prevTime: Float;

  /**
   * The last time the fps was updated.
   */
  var lastFPSUpdate: Float;

  /**
   * The last fps delta time.
   */
  var lastFrameTime: Float;

  /**
   * How often the fps updates in seconds.
   */
  var fpsUpdateInterval = 0.5;

  /**
   * Frame times for the average fps.
   */
  var frameTimes: Array<Float> = [];

  /**
   * TimeStep constructor.
   */
  public function new() {
    reset();
  }

  /**
   * Update the time. Gets called every update.
   */
  public function update() {
    final currentTime = Scheduler.time();
    dt = (currentTime - prevTime) * timeScale;
    prevTime = currentTime;
  }

  /**
   * Render function to calculate fps.
   */
  public function render() {
    final time = Scheduler.realTime();
    if (lastFPSUpdate + fpsUpdateInterval < time) {
      var avg = 0.0;
      for (t in frameTimes) {
        avg += t;
      }
      avg = avg / frameTimes.length;
      fps = Math.ceil(1.0 / avg);
      lastFPSUpdate = time;
    }

    if (frameTimes.length > 100) {
      frameTimes.shift();
    }
    frameTimes.push(time - lastFrameTime);
    lastFrameTime = time;
  }

  /**
   * Reset the timeStep.
   */
  public function reset() {
    prevTime = Scheduler.time();
    dt = 0;
    fps = 0;
    lastFPSUpdate = Scheduler.realTime();
    lastFrameTime = lastFPSUpdate;
    while (frameTimes.length > 0) {
      frameTimes.pop();
    }
  }
}