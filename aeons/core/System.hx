package aeons.core;

import aeons.utils.TimeStep;
import aeons.utils.Timers;
import aeons.tween.Tweens;
import aeons.math.Random;
import aeons.events.EventEmitter;
import aeons.assets.Assets;
import aeons.audio.Audio;

@:autoBuild(aeons.core.Macros.buildSystem())
class System {

  final audio: Audio;

  final assets: Assets;

  final events: EventEmitter;

  final random: Random;

  final display: Display;

  final tweens: Tweens;

  final timers: Timers;

  final timeStep: TimeStep;

  final systemMap: Map<String, System>;

  final updateSystems: Array<Updatable>;

  final renderSystems: Array<Renderable>;

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

typedef SystemRefs = {
  var audio: Audio;
  var assets: Assets;
  var events: EventEmitter;
  var random: Random;
  var tweens: Tweens;
  var timers: Timers;
  var timeStep: TimeStep;
  var display: Display;
  var systemMap: Map<String, System>;
  var renderSystems: Array<Renderable>;
  var updateSystems: Array<Updatable>;
}