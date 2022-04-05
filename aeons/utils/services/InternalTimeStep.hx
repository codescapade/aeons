package aeons.utils.services;

import kha.Scheduler;

/**
 * InternalTimeStep is used to calculate delta time and fps.
 */
@:dox(hide)
class InternalTimeStep implements TimeStep {

  public var dt(default, null): Float;

  public var fps(default, null): Int;

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

  public function update() {
    final currentTime = Scheduler.time();
    dt = (currentTime - prevTime) * timeScale;
    prevTime = currentTime;
  }

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