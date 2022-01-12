package aeons.core;

import aeons.assets.Assets;
import aeons.audio.Audio;
import aeons.core.Entities.EntitiesRefs;
import aeons.events.EventEmitter;
import aeons.graphics.RenderTarget;
import aeons.math.Random;
import aeons.tween.Tweens;
import aeons.utils.Timers;
import aeons.utils.TimeStep;

/**
 * The `Entity` class is the main container class in the game.
 * Components can be added to it for functionality.
 */
class Entity {
  /**
   * The unique id for this entity.
   */
  public final id: Int;

  /**
   * Is this entity active. This also updates all components that are on this entity.
   */
  public var active(default, set) = true;

  /**
   * The asset manager.
   */
  final assets: Assets;

  /**
   * The audio manager.
   */
  final audio: Audio;

  /**
   * The event manager.
   */
  final events: EventEmitter;

  /**
   * The entity manager.
   */
  @:noCompletion
  final entities: Entities;

  /**
   * The display info.
   */
  final display: Display;

  /**
   * Random number generator.
   */
  final random: Random;

  /**
   * Tween manager.
   */
  final tweens: Tweens;

  /**
   * Timer manager.
   */
  final timers: Timers;

  /**
   * Time step.
   */
  final timeStep: TimeStep;

  /**
   * Private constructor. Only the entity manager should create an entity.
   * @param refs 
   */
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

  /**
   * Add a component to this entity.
   * @param componentType The component type to add.
   * @return The created component.
   */
  public inline function addComponent<T: Component>(componentType: Class<T>): T {
    return entities.addComponent(this, componentType);
  }

  /**
   * Remove a component from this entity.
   * @param componentType The component type to remove.
   */
  public inline function removeComponent(componentType: Class<Component>) {
    return entities.removeComponent(this, componentType);
  }

  /**
   * Retreive a component from the entity.
   * @param componentType The component type to get.
   * @return The component.
   */
  public inline function getComponent<T: Component>(componentType: Class<T>): T {
    return entities.getComponent(id, componentType);
  }

  /**
   * Check if this entity has a component type.
   * @param componentType The component type to check.
   * @return True if the entity has that component.
   */
  public inline function hasComponent(componentType: Class<Component>): Bool {
    return entities.hasComponent(id, componentType);
  }

  /**
   * Check if this entity has all components in a list.
   * @param componentTypess The component types to check.
   * @return True if the entity has all the components in the list.
   */
  public inline function hasComponents(componentTypes: Array<Class<Component>>): Bool {
    return entities.hasComponents(id, componentTypes);
  }

  /**
   * Same as hasComponents but uses the class as string instead of a type. 
   * @param componentTypess The component types to check.
   * @return True if the entity has all the components in the list.
   */
  public inline function hasBundleComponents(componentNames: Array<String>): Bool {
    return entities.hasBundleComponents(id, componentNames);
  }

  /**
   * Update function you can call from a scene if you don't want to use components or systems.
   * @param dt The time passed since the last update in seconds.
   */
  public function update(dt: Float) {}

  /**
   * Render function you can call from a scene if you don't want to use components or systems.
   * @param target The render target to render to.
   */
  public function render(target: RenderTarget) {}

  /**
   * This function gets called when an entity gets destroyed.
   * You can clean up variables here if needed.
   */
  public function cleanup() {}

  /**
   * Active setter. 
   * @param value the new active value.
   */
  function set_active(value: Bool): Bool {
    active = value;

    // Also update all components.
    var components = entities.getAllComponentsForEntity(id);
    for (component in components) {
      component.active = value;
    }

    return value;
  }
}