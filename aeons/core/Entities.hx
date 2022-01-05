package aeons.core;

import aeons.events.ComponentEvent;
import aeons.events.EventType;
import haxe.macro.Type.ClassType;
import aeons.math.AeMath;
import aeons.utils.TimeStep;
import aeons.math.Random;
import aeons.utils.Timers;
import aeons.tween.Tweens;
import aeons.assets.Assets;
import aeons.audio.Audio;
import aeons.events.EventEmitter;

class Entities {

  final components = new Map<String, Array<Component>>();
  final entities: Array<Entity> = [];

  final entitiesToAdd: Array<Entity> = [];
  final entitiesToRemove: Array<Entity> = [];

  final updatedComponents: Array<ComponentUpdate> = [];

  final freeIds: Array<Int> = [];

  final refs: EntitiesRefs;

  var nextEntityId = -1;

  public function new(refs: EntitiesRefs) {
    refs.entities = this;
    this.refs = refs;
  }

  public function updateAddRemove() {
    while (entitiesToAdd.length > 0) {
      entities.push(entitiesToAdd.pop());
    }

    while (entitiesToRemove.length > 0) {
      final entity = entitiesToRemove.pop();
      freeIds.push(entity.id);
      final allComponents = getAllComponentsForEntity(entity);

      for (component in allComponents) {
        final name = Type.getClassName(Type.getClass(component));
        components[name][entity.id] = null;
        final eventType: EventType<ComponentEvent> = '${name}_removed';
        refs.events.emit(ComponentEvent.get(eventType, entity)); 

        component.cleanup();
      }
    }

    while (updatedComponents.length > 0) {
      final update = updatedComponents.pop();
      switch (update.update) {
        case ADDED:
          components[update.componentName][update.entity.id] = update.component;
          final eventType: EventType<ComponentEvent> = '${update.componentName}_added';
          refs.events.emit(ComponentEvent.get(eventType, update.entity)); 

        case REMOVED:
          components[update.componentName][update.entity.id] = null;
          final eventType: EventType<ComponentEvent> = '${update.componentName}_removed';
          refs.events.emit(ComponentEvent.get(eventType, update.entity)); 

          update.component.cleanup();
      }
    }
  }

  public function addEntity<T: Entity>(entityType: Class<T>): T {
    final id = getNextEntityId();
    refs.id = id;

    final entity = Type.createInstance(entityType, [refs]);
    entitiesToAdd.push(entity);

    return entity;
  }

  public function removeEntity(entity: Entity) {
    entitiesToRemove.push(entity);
  }

  public function getEntityById(id: Int): Entity {
    for (entity in entities) {
      if (entity.id == id) {
        return entity;
      }
    }

    return null;
  }

  public function removeEntityById(id: Int) {
    final entity = getEntityById(id);
    if (entity != null) {
      entitiesToRemove.push(entity);
    }
  }

  public function addComponent<T: Component>(entity: Entity, componentType: Class<T>): T {
    final name = Type.getClassName(componentType);

    if (components[name] != null) {
      if (components[name][entity.id] != null) {
        throw 'Component ${name} already exists on entity ${entity.id}.';
      }
    }

    refs.id = entity.id;
    final component = Type.createInstance(componentType, [refs]);
    updatedComponents.push({ entity: entity, componentName: name, component: component, update: ADDED });

    return component;
  }

  public function removeComponent(entity: Entity, componentType: Class<Component>) {
    final name = Type.getClassName(componentType);

    if (components[name] == null || components[name][entity.id] == null) {
      throw 'Component ${name} does not exist on entity ${entity.id}.';
    }

    final component = components[name][entity.id];
    updatedComponents.push({ entity: entity, componentName: name, component: component, update: REMOVED });
  }

  public function hasComponent(entity: Entity, componentType: Class<Component>): Bool {
    final name = Type.getClassName(componentType);

    if (components[name] == null) {
      return false;
    }

    return components[name][entity.id] != null;
  }

  public function hasComponents(entity: Entity, componentTypes: Array<Class<Component>>): Bool {
    for (component in componentTypes) {
      if (!hasComponent(entity, component)) {
        return false;
      }
    }

    return true;
  }

  public function getAllComponentsForEntity(entity: Entity): Array<Component> {
    final entityComponents: Array<Component> = [];
    for (list in components) {
      final component = list[entity.id];
      if (component != null) {
        entityComponents.push(component);
      }
    }

    return entityComponents;
  }

  function getNextEntityId(): Int {
    if (freeIds.length > 0) {
      return freeIds.shift();
    } else if (nextEntityId < AeMath.MAX_VALUE_INT) {
      nextEntityId++;

      return nextEntityId;
    }

    throw 'No more entity ids available. You have reached the limit of entities.';
  }
}

typedef EntitiesRefs = {
  var audio: Audio;
  var assets: Assets;
  var events: EventEmitter;
  var display: Display;
  var tweens: Tweens;
  var timers: Timers;
  var random: Random;
  var entities: Entities;
  var timeStep: TimeStep;
  var id: Int;
}

typedef ComponentUpdate = {
  var entity: Entity;
  var component: Component;
  var componentName: String;
  var update: Update;
}

enum Update {
  ADDED;
  REMOVED;
}