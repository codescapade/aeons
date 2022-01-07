package aeons.core;

import aeons.core.Entities.EntitiesRefs;
import aeons.utils.TimeStep;
import aeons.utils.Timers;
import aeons.tween.Tweens;
import aeons.events.EventEmitter;
import aeons.math.Random;
import aeons.assets.Assets;
import aeons.audio.Audio;

class Component {
  public final entityId: Int;

  public var active = true;

  var requiredComponents(get, never): Array<Class<Component>>;

  var audio: Audio;
  var assets: Assets;
  var display: Display;
  var random: Random;
  var events: EventEmitter;
  var tweens: Tweens;
  var timers: Timers;
  var timeStep: TimeStep;
  var entities: Entities;

  public function cleanup() {}

  function new(refs: EntitiesRefs) {
    entityId = refs.id;
    audio = refs.audio;
    assets = refs.assets;
    display = refs.display;
    random = refs.random;
    events = refs.events;
    tweens = refs.tweens;
    timers = refs.timers;
    timeStep = refs.timeStep;
    entities = refs.entities;
  }

  public inline function getComponent<T: Component>(componentType: Class<T>): T {
    return entities.getComponent(entityId, componentType);
  }

  public inline function hasComponent(componentType: Class<Component>): Bool {
    return entities.hasComponent(entityId, componentType);
  }

  public inline function hasComponents(componentTypes: Array<Class<Component>>): Bool {
    return entities.hasComponents(entityId, componentTypes);
  }

  function get_requiredComponents(): Array<Class<Component>> {
    return [];
  }
}