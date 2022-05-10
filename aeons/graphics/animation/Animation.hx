package aeons.graphics.animation;

import aeons.graphics.atlas.Atlas;
import aeons.graphics.atlas.Frame;

/**
 * The Animation class can be used for sprite sheet animations.
 */
class Animation {
  /**
   * The name of the animation.
   */
  public var name(default, null): String;

  /**
   * The frame names of the animation.
   */
  public var frames(default, null): Array<String>;

  /**
   * How long one frame stays on the screen in seconds.
   */
  public var frameDuration: Float;

  /**
   * The animation mode.
   */
  public var playMode: AnimationMode;

  /**
   * The atlas used for the animation.
   */
  public var atlas: Atlas;

  /**
   * Animation constructor.
   * @param name The name of the animation.
   * @param atlas The atlas used in the animation.
   * @param frames The frame names.
   * @param frameDuration The duration of a frame in seconds.
   * @param animationMode The animation play mode.
   */
  public function new(name: String, atlas: Atlas, frames: Array<String>, frameDuration: Float,
      playMode: AnimationMode = NORMAL) {
    this.name = name;
    this.atlas = atlas;
    this.frames = frames;
    this.frameDuration = frameDuration;
    this.playMode = playMode;
  }

  /**
   * Get an animation frame for a point in time since the animation started.
   * @param time The time passed since the animation started in seconds.
   * @return The frame from the animation.
   */
  public function getFrame(time: Float): Frame {
    return atlas.getFrame(frames[getFrameIndex(time)]);
  }

  /**
   * Get an animation frame name for a point in time since the animation started.
   * @param time The time passed since the animation started in seconds.
   * @return The frame name.
   */
  public function getFrameName(time: Float): String {
    return frames[getFrameIndex(time)];
  }

  /**
   * Is an animation finished based on a time.
   * @param time The time passed since the animation started in seconds.
   * @return True if the animation is finished.
   */
  public function finished(time: Float): Bool {
    if (playMode != NORMAL || playMode != REVERSED) {
      return false;
    }

    return Math.floor(time / frameDuration) > frames.length;
  }

  /**
   * Get the array index of a frame base on time.
   * @param time The time passed since the animation started in seconds.
   * @return The frame index.
   */
  function getFrameIndex(time: Float): Int {
    if (frames.length == 1) {
      return 0;
    }

    var frameNumber: Int = Math.floor(time / frameDuration);
    switch (playMode) {
      case NORMAL:
        frameNumber = Math.floor(Math.min(frames.length - 1, frameNumber));

      case LOOP:
        frameNumber = frameNumber % frames.length;

      case LOOP_PING_PONG:
        frameNumber = frameNumber % ((frames.length * 2) - 2);
        if (frameNumber >= frames.length) {
          frameNumber = frames.length - 2 - (frameNumber - frames.length);
        }

      case REVERSED:
        frameNumber = Math.floor(Math.max(frames.length - frameNumber - 1, 0));

      case LOOP_REVERSED:
        frameNumber = frameNumber % frames.length;
        frameNumber = frames.length - frameNumber - 1;
    }

    return frameNumber;
  }
}
