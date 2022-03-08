package aeons.core;

import aeons.assets.Assets;
import aeons.audio.Audio;
import aeons.core.Entities.EntitiesRefs;
import aeons.events.EventEmitter;
import aeons.math.Random;
import aeons.tween.Tweens;
import aeons.utils.TimeStep;
import aeons.utils.Timers;

/**
 * The component base class.
 */
class Component {
  /**
   * The entity this component belongs to.
   */
  public final entityId: Int;

  /**
   * Is this component active.
   */
  public var active = true;

  /**
   * A list of components that this component depends on. For when you have more than data in components and are
   * using other components directly in this component.
   */
  var requiredComponents(get, never): Array<Class<Component>>;

  /**
   * The audio manager.
   */
  var audio: Audio;

  /**
   * The asset manager.
   */
  var assets: Assets;

  /**
   * Display info.
   */
  var display: Display;

  /**
   * Random number generator.
   */
  var random: Random;

  /**
   * Event manager.
   */
  var events: EventEmitter;

  /**
   * Tween manager.
   */
  var tweens: Tweens;

  /**
   * Timer manager.
   */
  var timers: Timers;

  /**
   * Time step.
   */
  var timeStep: TimeStep;

  /**
   * Entity manager.
   */
  var entities: Entities;

  /**
   * Called before a component is removed.
   */
  public function cleanup() {}

  /**
   * Get another component on the same entity.
   * @param componentType The type of component you want.
   * @return The component.
   */
  public inline function getComponent<T: Component>(componentType: Class<T>): T {
    return entities.getComponent(entityId, componentType);
  }

  /**
   * Check if this entity has a type of component.
   * @param componentType The type of component to check.
   * @return True if the entity has the component.
   */
  public inline function hasComponent(componentType: Class<Component>): Bool {
    return entities.hasComponent(entityId, componentType);
  }

  /**
   * Check if this entity a multiple components.
   * @param componentTypes The list of components to check.
   * @return True if the entity has all components.
   */
  public inline function hasComponents(componentTypes: Array<Class<Component>>): Bool {
    return entities.hasComponents(entityId, componentTypes);
  }
  
  /**
   * Private constructor. Components should only be created by the entity manager.
   * @param refs Manager references.
   */
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

    for (component in requiredComponents) {
      if (!hasComponent(component)) {
        throw 'Entity ${entityId} is missing a required ${Type.getClassName(component)} component.';
      }
    }
  }

  /**
   * Required components getter. Override this in a derived class to set the required components.
   */
  function get_requiredComponents(): Array<Class<Component>> {
    return [];
  }
}