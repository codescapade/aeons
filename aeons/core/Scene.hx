package aeons.core;

import aeons.core.services.InternalEntities;
import aeons.core.services.InternalSystems;
import aeons.graphics.RenderTarget;
import aeons.tween.services.InternalTweens;
import aeons.utils.services.InternalTimers;

/**
 * The Scene class is meant to be sub classes and used to initialze and run a scene in your game.
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

  @:noCompletion
  final sceneProviders: SceneProviders;

  /**
   * Constructor.
   * @param userData Any data you want to carry over between scenes.
   */
  public function new(?userData: Dynamic) {
    this.userData = userData;
    sceneProviders = {
      entities: new InternalEntities(),
      systems: new InternalSystems(),
      timers: new InternalTimers(),
      tweens: new InternalTweens()
    };
    setProviders();
  }

  /**
   * Override this method to initalize your scene.
   */
  public function init() {}

  /**
   * Override this method to cleanup scene when it gets removed.
   */
  public function cleanup() {
    sceneProviders.entities.cleanup();
    Aeons.provideEntities(null);
    Aeons.provideSystems(null);
    Aeons.provideTimers(null);
    Aeons.provideTweens(null);
  }

  public function setProviders() {
    Aeons.provideEntities(sceneProviders.entities);
    Aeons.provideSystems(sceneProviders.systems);
    Aeons.provideTimers(sceneProviders.timers);
    Aeons.provideTweens(sceneProviders.tweens);
  }

  /**
   * Called every update.
   * @param dt The time passed since the last update.
   */
  public function update(dt: Float) {
    sceneProviders.entities.updateRemoved();
    sceneProviders.tweens.update(dt);
    sceneProviders.timers.update(dt);
    sceneProviders.systems.update(dt);
  }

  /**
   * Gets called every frame.
   * @param target The target to render to.
   */
  public function render(target: RenderTarget) {
    sceneProviders.systems.render(target);
  }

  /**
   * Add a new entity to the manager.
   * @param entity The entity you want to add.
   * @return The id the entity got when it was added to the entities.
   */
  public inline function addEntity<T: Entity>(entity: T): T {
    return sceneProviders.entities.addEntity(entity);
  }

  /**
   * Remove an entity from the manager.
   * @param entity The entity to remove.
   */
  public inline function removeEntity(entity: Entity) {
    sceneProviders.entities.removeEntity(entity);
  }

  /**
   * Get an entity using the id.
   * @param id The id of the entity.
   * @return The entity.
   */
  public inline function getEntityById(id: Int): Entity {
    return sceneProviders.entities.getEntityById(id);
  }

  /**
   * Remove an entity by its id.
   * @param id The entity id.
   */
  public inline function removeEntityById(id: Int) {
    sceneProviders.entities.removeEntityById(id);
  }

  /**
   * Add a system to the scene. Throws an error if the system type has already been added.
   * @param systemType The type of system to add.
   * @return The newly created system
   */
  public inline function addSystem<T: System>(system: T): T {
    return sceneProviders.systems.add(system);
  }

  /**
   * Remove a system from the scene.
   * @param systemType The type of system to remove.
   */
  public inline function removeSystem(systemType: Class<System>) {
    sceneProviders.systems.remove(systemType);
  }

  /**
   * Get a system using its type.
   * @param systemType The type of system you want to get a reference from.
   * @return The system if it exists. Otherwise null.
   */
  public inline function getSystem<T: System>(systemType: Class<T>): T {
    return sceneProviders.systems.get(systemType);
  }

  /**
   * Check if a system has been added.
   * @param systemType The type of system you want to check for.
   * @return True is the system was found.
   */
  public inline function hasSystem(systemType: Class<System>): Bool {
    return sceneProviders.systems.has(systemType);
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

}

/**
 * To keep track of the providers for this scene.
 */
private typedef SceneProviders = {
  var entities: InternalEntities;
  var systems: InternalSystems;
  var tweens: InternalTweens;
  var timers: InternalTimers;
}