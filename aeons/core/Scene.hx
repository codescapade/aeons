package aeons.core;

import aeons.assets.Assets;
import aeons.audio.Audio;
import aeons.events.EventEmitter;
import aeons.graphics.RenderTarget;
import aeons.math.Random;
import aeons.utils.TimeStep;
import aeons.utils.Timers;
import aeons.tween.Tweens;

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
   * The main event emitter.
   */
  final events: EventEmitter;

  /**
   * The tweens manager.
   */
  final tweens: Tweens;

  /**
   * The timer manager.
   */
  final timers: Timers;

  /**
   * The audio manager.
   */
  final audio: Audio;

  /**
   * The asset manager.
   */
  final assets: Assets;

  /**
   * The display info.
   */
  final display: Display;

  /**
   * The time step if you need more than just delta time in the update function.
   */
  final timeStep: TimeStep;

  /**
   * Random number generator.
   */
  final random: Random;

  final entities: Entities;

  /**
   * All systems that are in the scene.
   */
  var systemMap = new Map<String, System>();

  /**
   * List of systems that need to be updated every frame.
   */
  var updateSystems: Array<Updatable> = [];

  /**
   * List of systems that need to render every frame.
   */
  var renderSystems: Array<Renderable> = [];

  /**
   * Override this method to initalize your scene.
   */
  public function init() {}

  /**
   * Override this method to cleanup scene when it gets removed.
   */
  public function cleanup() {}

  /**
   * Called every update.
   * @param dt The time passed since the last update.
   */
  public function update(dt: Float) {
    entities.updateAddRemove();
    tweens.update(dt);
    timers.update(dt);

    for (system in updateSystems) {
      system.update(dt);
    }
  }

  /**
   * Gets called every frame.
   * @param target The target to render to.
   */
  public function render(target: RenderTarget) {
    for (system in renderSystems) {
      system.render(target);
    }
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
   * 
   */
  public function toForeground() {}

  /**
   * Creates a new scene and sets all the references.
   * @param refs 
   */
  @:allow(aeons.core.Game)
  function new(refs: SceneRefs) {
    userData = refs.userData;
    events = refs.events;
    audio = refs.audio;
    display = refs.display;
    timeStep = refs.timeStep;
    assets = refs.assets;
    random = refs.random;

    tweens = new Tweens();
    timers = new Timers();

    entities = new Entities({
      audio: audio,
      id: -1,
      entities: null,
      timeStep: timeStep,
      random: random,
      timers: timers,
      tweens: tweens,
      display: display,
      events: events,
      assets: assets
    });
  }

  inline function addEntity<T: Entity>(entityType: Class<T>): T {
    return entities.addEntity(entityType);
  }

  inline function removeEntity(entity: Entity) {
    return entities.removeEntity(entity);
  }

  inline function getEntityById(id: Int): Entity {
    return entities.getEntityById(id);
  }

  inline function removeEntityById(id: Int) {
    return entities.removeEntityById(id);
  }

  /**
   * Add a system to the scene. Throws an error if the system type has already been added.
   * @param systemType The type of system to add.
   * @return The newly created system
   */
  function addSystem<T: System>(systemType: Class<T>): T {
    final name = Type.getClassName(systemType);
    if (systemMap[name] != null) {
      throw 'System $name already exists.';
    }

    final system = Type.createInstance(systemType, [{ systemMap: systemMap, updateSystems: updateSystems,
        renderSystems: renderSystems, assets: assets, events: events, display: display, random: random, audio: audio,
        tweens: tweens }]);
    systemMap[name] = system;

    // Add to the update systems.
    if (Std.isOfType(system, Updatable)) {
      updateSystems.push(cast system);
    }
    // Add to the render systems.
    if (Std.isOfType(system, Renderable)) {
      renderSystems.push(cast system);
    }

    return system;
  }

  /**
   * Remove a system from the scene.
   * @param systemType The type of system to remove.
   */
  function removeSystem(systemType: Class<System>) {
    final name = Type.getClassName(systemType);
    final system = systemMap[name];
    if (system == null) {
      return;
    }

    systemMap.remove(name);

    // Remove from the update systems.
    if (Std.isOfType(system, Updatable)) {
      updateSystems.remove(cast system);
    }

    // Remove from the render systems.
    if (Std.isOfType(system, Renderable)) {
      renderSystems.remove(cast system);
    }

    system.cleanup();
  }

  /**
   * Get a system using its type.
   * @param systemType The type of system you want to get a reference from.
   * @return The system if it exists. Otherwise null.
   */
  function getSystem<T: System>(systemType: Class<T>): T {
    final name = Type.getClassName(systemType);
    final system = systemMap[name];
    if (system == null) {
      return null;
    }

    return cast system;
  }
}

/**
 * References to systems that are usefull in a scene.
 */
typedef SceneRefs = {
  /**
   * Data from another scene.
   */
  var userData: Dynamic;

  /**
   * The audio manager reference.
   */
  var audio: Audio;

  /**
   * The asset manager reference.
   */
  var assets: Assets;

  /**
   * The display info reference.
   */
  var display: Display;

  /**
   * The time steap reference.
   */
  var timeStep: TimeStep;

  /**
   * The random number generator.
   */
  var random: Random;

  /**
   * The event emitter reference.
   */
  var events: EventEmitter;
}