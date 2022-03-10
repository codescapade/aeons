package aeons.core;

import aeons.core.services.InternalSystems;
import aeons.core.services.InternalEntities;
import aeons.graphics.RenderTarget;
import aeons.tween.services.InternalTweens;
import aeons.utils.services.InternalTimers;

/**
 * The `Scene` class is meant to be sub classes and used to initialze and run a scene in your game.
 * Like a main menu, the game itself or a level.
 */
class Scene {
  /**
   * If set to true and there is a scene below this on the stack this scene will be renered on top.
   * Could be used for pause scenes.
   */
  public var isSubScene = false;

  /**
   * Some data sent from the previous scene. So you can store data between scenes.
   */
  final userData: Dynamic;

  /**
   * Override this method to initalize your scene.
   */
  public function init() {}

  /**
   * Override this method to cleanup scene when it gets removed.
   */
  public function cleanup() {
    Aeons.entities.cleanup();
    Aeons.provideEntities(null);
    Aeons.provideTimers(null);
    Aeons.provideTweens(null);
    Aeons.provideSystems(null);
  }

  /**
   * Called every update.
   * @param dt The time passed since the last update.
   */
  public function update(dt: Float) {
    Aeons.entities.updateAddRemove();
    Aeons.tweens.update(dt);
    Aeons.timers.update(dt);
    Aeons.systems.update(dt);
  }

  /**
   * Gets called every frame.
   * @param target The target to render to.
   */
  public function render(target: RenderTarget) {
    Aeons.systems.render(target);
  }

  /**
   * Called before the scene gets paused.
   */
  public function willPause() {}

  /**
   * Called before the scene resumes after pausing.
   */
  public function willResume() {}

  /**
   * Called when to game goes to the background.
   */
  public function toBackground() {}

  /**
   * Called when the game comes back from the background to the foreground.
   */
  public function toForeground() {}

  /**
   * Creates a new scene and sets all the references.
   * @param refs 
   */
  @:allow(aeons.core.Game)
  function new(userData: Dynamic) {
    this.userData = userData;

    Aeons.provideEntities(new InternalEntities());
    Aeons.provideSystems(new InternalSystems());
    Aeons.provideTimers(new InternalTimers());
    Aeons.provideTweens(new InternalTweens());
  }
}