package aeons.core;

import aeons.events.SceneEvent;

/**
 * The transition class can be used for transition effects between scenes.
 * This scene goes on top of the the current scene. Runs from old swaps to the new scene and runs to new.
 */
class Transition extends Scene {
  /**
   * Initialize the scene.
   */
  var duration: Float;

  public override function create() {
    isSubScene = true;
    duration = userData.duration / 2.0;

    transitionFromOld();
    Aeons.timers.create(duration, () -> {
      SceneEvent.emit(SceneEvent.REPLACE, userData.nextScene, userData.data, false, true);
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

typedef TransitionData = {
  var ?data: Dynamic;
  var nextScene: Class<Scene>;
  var duration: Float;
}
