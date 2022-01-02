package aeons.events;

import aeons.core.Scene;

/**
 * The `SceneEvent` event is used to switch scenes.
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
   * The type for the new scene. Not used in the pop event.
   */
  var sceneType: Class<Scene>;

  /**
   * Data you want to send between scenes.
   */
  var userData: Dynamic;

  /**
   * On the replace event you can choose if you want to clear all scenes on the stack.
   */
  var clearAll: Bool;
}