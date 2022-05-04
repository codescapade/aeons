package aeons.core;

import aeons.events.SceneEvent;

/**
 * The transition class can be used for transition effects between scenes.
 * This scene goes on top of the the current scene. Runs from old swaps to the new scene and runs to new.
 */
class Transition extends Scene {
  /**
   * The scene to transition to.
   */
  var nextScene: Scene;

  /**
   * How long the transition takes.
   */
  var duration: Float;

  /**
   * Constructor.
   * @param nextScene The scene to transition to. 
   * @param duration The length of the total transition in seconds. Half to transition out and half for in.
   */
  public function new(nextScene: Scene, duration: Float) {
    super(null);
    isSubScene = true;
    this.nextScene = nextScene;
    this.duration = duration / 2.0;
  }

  /**
   * Initialize the scene.
   */
  public override function init() {
    transitionFromOld();
    Aeons.timers.create(duration, () -> {
      SceneEvent.emit(SceneEvent.REPLACE, nextScene, false, true);
      transitionToNew();
      Aeons.timers.create(duration, () -> {
        SceneEvent.emit(SceneEvent.POP);
      }, 0, true);
    }, 0, true);
  }

  /**
   * The transition from the current scene.
   */
  public function transitionFromOld() {}

  /**
   * The transition to the next scene.
   */
  public function transitionToNew() {}
}
