package aeons.events;

import aeons.core.Scene;

/**
 * The SceneEvent event is used to switch scenes.
 */
class SceneEvent extends Event {
  /**
   * Push a scene onto the scene stack.
   */
  public static inline final PUSH: EventType<SceneEvent> = 'aeons_push_scene';

  /**
   * Pop the current scene off the stack. This only works when there is more than one scene on the stack.
   */
  public static inline final POP: EventType<SceneEvent> = 'aeons_pop_scene';

  /**
   * Replace the current scene with a new scene.
   */
  public static inline final REPLACE: EventType<SceneEvent> = 'aeons_replace_scene';

  /**
   * The new scene to start. Not used in pop.
   */
  var newScene: Class<Scene> = null;

  /**
   * Any data you want to pass to the new scene.
   */
  var userData: Dynamic = null;

  /**
   * On the replace event you can choose if you want to clear all scenes on the stack.
   */
  var clearAll = false;

  /**
   * Should the new scene replace the scene below this one.
   */
  var below = false;
}
