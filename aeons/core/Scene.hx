package aeons.core;

import aeons.core.services.InternalSystems;
import aeons.core.services.InternalEntities;
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
   * Add a new entity to the manager.
   * @param entity The entity you want to add.
   * @return The id the entity got when it was added to the entities.
   */
  public inline function addEntity<T: Entity>(entity: T): T {
    return Aeons.entities.addEntity(entity);
  }

  /**
   * Remove an entity from the manager.
   * @param entity The entity to remove.
   * @param pool Should the components on this entity be put back in their object pools.
   */
  public inline function removeEntity(entity: Entity, pool: Bool = false) {
    Aeons.entities.removeEntity(entity, pool);
  }

  /**
   * Get an entity using the id.
   * @param id The id of the entity.
   * @return The entity.
   */
  public inline function getEntityById<T: Entity>(id: Int): T {
    return Aeons.entities.getEntityById(id);
  }

  /**
   * Remove an entity by its id.
   * @param id The entity id.
   * @param pool Should the components on this entity be put back in their object pools.
   */
  public inline function removeEntityById(id: Int, pool: Bool = false) {
    Aeons.entities.removeEntityById(id, pool);
  }

  /**
   * Add a system to the scene. Throws an error if the system type has already been added.
   * @param systemType The type of system to add.
   * @return The newly created system
   */
  public inline function addSystem<T: System>(system: T): T {
    return Aeons.systems.add(system);
  }

  /**
   * Remove a system from the scene.
   * @param systemType The type of system to remove.
   */
  public inline function removeSystem(systemType: Class<System>) {
    Aeons.systems.remove(systemType);
  }

  /**
   * Get a system using its type.
   * @param systemType The type of system you want to get a reference from.
   * @return The system if it exists. Otherwise null.
   */
  public inline function getSystem<T: System>(systemType: Class<T>): T {
    return Aeons.systems.get(systemType);
  }

  /**
   * Check if a system has been added.
   * @param systemType The type of system you want to check for.
   * @return True is the system was found.
   */
  public inline function hasSystem(systemType: Class<System>): Bool {
    return Aeons.systems.has(systemType);
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