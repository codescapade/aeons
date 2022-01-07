package aeons.core;

import aeons.components.CRender;
import aeons.components.CUpdate;
import aeons.events.ComponentEvent;
import aeons.events.EventType;
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

  final componentsToAdd: Array<ComponentUpdate> = [];
  final componentsToRemove: Array<ComponentUpdate> = [];

  final updateComponents: Array<Array<Updatable>> = [];
  final renderComponents: Array<Array<Renderable>> = [];

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
      final allComponents = getAllComponentsForEntity(entity.id);

      for (component in allComponents) {
        final name = Type.getClassName(Type.getClass(component));
        components[name][entity.id] = null;
        if (Std.isOfType(component, Updatable)) {
          updateComponents[entity.id].remove(cast component);
        }
        if (Std.isOfType(component, Renderable)) {
          renderComponents[entity.id].remove(cast component);
        }

        final eventType: EventType<ComponentEvent> = '${name}_removed';
        refs.events.emit(ComponentEvent.get(eventType, entity));

        component.cleanup();
      }
    }

    while (componentsToAdd.length > 0) {
      final update = componentsToAdd.pop();
      var eventType: EventType<ComponentEvent> = '${update.componentName}_added';

      if (components[update.componentName] == null) {
        components[update.componentName] = [];
      }
      components[update.componentName][update.entity.id] = update.component;
      refs.events.emit(ComponentEvent.get(eventType, update.entity));

      if (Std.isOfType(update.component, Updatable)) {
        if (updateComponents[update.entity.id] == null) {
          updateComponents[update.entity.id] = [cast update.component];

          // Add an update component if it does not exist yet.
          if (!hasComponent(update.entity.id, CUpdate)) {
            var updateComp = Type.createInstance(CUpdate, [refs]).init();
            var updateCompName = Type.getClassName(CUpdate);
            if (components[updateCompName] == null) {
              components[updateCompName] = [];
            }
            components[updateCompName][update.entity.id] = updateComp;

            eventType = '${updateCompName}_added';
            refs.events.emit(ComponentEvent.get(eventType, update.entity));
          }
        } else {
          updateComponents[update.entity.id].push(cast update.component);
        }
      }

      if (Std.isOfType(update.component, Renderable)) {
        if (renderComponents[update.entity.id] == null) {
          renderComponents[update.entity.id] = [cast update.component];

          // Add a render component if it does not exist yet.
          if (!hasComponent(update.entity.id, CRender)) {
            var renderComp = Type.createInstance(CRender, [refs]).init();
            var renderCompName = Type.getClassName(CRender);
            if (components[renderCompName] == null) {
              components[renderCompName] = [];
            }
            components[renderCompName][update.entity.id] = renderComp;

            eventType = '${renderCompName}_added';
            refs.events.emit(ComponentEvent.get(eventType, update.entity));
          }
        } else {
          renderComponents[update.entity.id].push(cast update.component);
        }
      }
    }

    while (componentsToRemove.length > 0) {
      final update = componentsToAdd.pop();
      var eventType: EventType<ComponentEvent> = '${update.componentName}_removed';

      components[update.componentName][update.entity.id] = null;
      refs.events.emit(ComponentEvent.get(eventType, update.entity));
      update.component.cleanup();

      if (Std.isOfType(update.component, Updatable)) {

        updateComponents[update.entity.id].remove(cast update.component);

        // Remove the update component if there are no more components left to update.
        if (updateComponents[update.entity.id].length == 0) {
          updateComponents[update.entity.id] = null;
          final updateComp = getComponent(update.entity.id, CUpdate);
          final updateCompName = Type.getClassName(CUpdate);
          eventType = '${updateCompName}_removed';
          components[updateCompName][update.entity.id] = null;
          refs.events.emit(ComponentEvent.get(eventType, update.entity));
          updateComp.cleanup();
        }
      }

      if (Std.isOfType(update.component, Renderable)) {

        renderComponents[update.entity.id].remove(cast update.component);

        // Remove the render component if there are no more components left to render.
        if (renderComponents[update.entity.id].length == 0) {
          renderComponents[update.entity.id] = null;
          final renderComp = getComponent(update.entity.id, CRender);
          final renderCompName = Type.getClassName(CRender);
          eventType = '${renderCompName}_removed';
          components[renderCompName][update.entity.id] = null;
          refs.events.emit(ComponentEvent.get(eventType, update.entity));
          renderComp.cleanup();
        }
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
    componentsToAdd.push({ entity: entity, componentName: name, component: component });

    return component;
  }

  public function removeComponent(entity: Entity, componentType: Class<Component>) {
    final name = Type.getClassName(componentType);

    if (components[name] == null || components[name][entity.id] == null) {
      throw 'Component ${name} does not exist on entity ${entity.id}.';
    }

    final component = components[name][entity.id];
    componentsToRemove.push({ entity: entity, componentName: name, component: component });
  }

  public function getComponent<T: Component>(entityId: Int, componentType: Class<T>): T {
    final name = Type.getClassName(componentType);
    if (components[name] != null) {
      final component = components[name][entityId];
      if (component != null) {
        return cast component;
      }
    }

    throw 'Component ${name} does not exist on entity with id ${entityId}.';
  }

  public function getUpdateComponents(entityId: Int): Array<Updatable> {
    if (updateComponents[entityId] == null) {
      return [];
    }

    return updateComponents[entityId];
  }

  public function getRenderComponents(entityId: Int): Array<Renderable> {
    if (renderComponents[entityId] == null) {
      return [];
    }

    return renderComponents[entityId];
  }

  public function hasComponent(entityId: Int, componentType: Class<Component>): Bool {
    final name = Type.getClassName(componentType);

    if (components[name] == null) {
      return false;
    }

    return components[name][entityId] != null;
  }

  public function hasComponents(entityId: Int, componentTypes: Array<Class<Component>>): Bool {
    for (component in componentTypes) {
      if (!hasComponent(entityId, component)) {
        return false;
      }
    }

    return true;
  }

  public function hasBundleComponents(entityId: Int, componentNames: Array<String>): Bool {
    for (name in componentNames) {
      if (components[name] == null) {
        return false;
      }

      if (components[name][entityId] == null) {
        return false;
      }
    }

    return true;
  }

  public function getAllComponentsForEntity(entityId: Int): Array<Component> {
    final entityComponents: Array<Component> = [];
    for (list in components) {
      final component = list[entityId];
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
}