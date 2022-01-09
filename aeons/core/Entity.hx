package aeons.core;

import aeons.audio.Audio;
import aeons.utils.TimeStep;
import aeons.events.EventEmitter;
import aeons.utils.Timers;
import aeons.tween.Tweens;
import aeons.math.Random;
import aeons.core.Entities.EntitiesRefs;
import aeons.graphics.RenderTarget;
import aeons.assets.Assets;

class Entity {
  public final id: Int;

  public var active(default, set) = true;

  final assets: Assets;

  final audio: Audio;

  final events: EventEmitter;

  @:noCompletion
  final entities: Entities;

  final display: Display;

  final random: Random;

  final tweens: Tweens;

  final timers: Timers;

  final timeStep: TimeStep;

  @:allow(aeons.core.Entities)
  function new(refs: EntitiesRefs) {
    id = refs.id;
    assets = refs.assets;
    audio = refs.audio;
    events = refs.events;
    entities = refs.entities;
    display = refs.display;
    random = refs.random;
    tweens = refs.tweens;
    timers = refs.timers;
    timeStep = refs.timeStep;
  }

  public inline function addComponent<T: Component>(componentType: Class<T>): T {
    return entities.addComponent(this, componentType);
  }

  public inline function removeComponent(componentType: Class<Component>) {
    return entities.removeComponent(this, componentType);
  }

  public inline function getComponent<T: Component>(componentType: Class<T>): T {
    return entities.getComponent(id, componentType);
  }

  public inline function hasComponent(componentType: Class<Component>): Bool {
    return entities.hasComponent(id, componentType);
  }

  public inline function hasComponents(componentTypes: Array<Class<Component>>): Bool {
    return entities.hasComponents(id, componentTypes);
  }

  public inline function hasBundleComponents(componentNames: Array<String>): Bool {
    return entities.hasBundleComponents(id, componentNames);
  }

  public function update(dt: Float) {}

  public function render(target: RenderTarget) {}

  public function cleanup() {}

  function set_active(value: Bool): Bool {
    active = value;
    var components = entities.getAllComponentsForEntity(id);
    for (component in components) {
      component.active = value;
    }

    return value;
  }
}