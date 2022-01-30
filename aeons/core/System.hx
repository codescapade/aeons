package aeons.core;

import aeons.assets.Assets;
import aeons.audio.Audio;
import aeons.events.EventEmitter;
import aeons.math.Random;
import aeons.tween.Tweens;
import aeons.utils.Timers;
import aeons.utils.TimeStep;

/**
 * The system base class for ECS.
 */
@:autoBuild(aeons.core.Macros.buildSystem())
class System {
  /**
   * The audio manager.
   */
  final audio: Audio;

  /**
   * The asset manager.
   */
  final assets: Assets;

  /**
   * The event manager.
   */
  final events: EventEmitter;

  /**
   * The random number generator.
   */
  final random: Random;

  /**
   * The display info.
   */
  final display: Display;

  /**
   * The tween manager.
   */
  final tweens: Tweens;

  /**
   * The timer manager.
   */
  final timers: Timers;

  /**
   * Time step for delta time and time scale.
   */
  final timeStep: TimeStep;

  /**
   * The map with all systems in the scene.
   */
  final systemMap: Map<String, System>;

  /**
   * A list of all update systems.
   */
  final updateSystems: Array<Updatable>;

  /**
   * A list of all render systems.
   */
  final renderSystems: Array<SysRenderable>;

  /**
   * Clean up variables after the scene gets removed.
   */
  public function cleanup() {}

  function new(refs: SystemRefs) {
    // TODO: Make it possible to add systems after entities have been added.
    audio = refs.audio;
    assets = refs.assets;
    events = refs.events;
    random = refs.random;
    display = refs.display;
    tweens = refs.tweens;
    timers = refs.timers;
    timeStep = refs.timeStep;
    systemMap = refs.systemMap;
    updateSystems = refs.updateSystems;
    renderSystems = refs.renderSystems;
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
      throw 'System ${name} does not exist in this scene.';
    }

    return cast system;
  }
}

@:structInit
class SystemRefs {
  /**
   * The audio manager.
   */
  public final audio: Audio;

  /**
   * The asset manager.
   */
  public final assets: Assets;

  /**
   * The event manager.
   */
  public final events: EventEmitter;

  /**
   * The random number generator.
   */
  public final random: Random;

  /**
   * The display info.
   */
  public final display: Display;

  /**
   * The tween manager.
   */
  public final tweens: Tweens;

  /**
   * The timer manager.
   */
  public final timers: Timers;

  /**
   * Time step for delta time and time scale.
   */
  public final timeStep: TimeStep;

  /**
   * The map with all systems in the scene.
   */
  public final systemMap: Map<String, System>;

  /**
   * A list of all update systems.
   */
  public final updateSystems: Array<Updatable>;

  /**
   * A list of all render systems.
   */
  public final renderSystems: Array<SysRenderable>;
}