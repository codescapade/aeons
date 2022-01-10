package aeons.core;

import aeons.assets.Assets;
import aeons.audio.Audio;
import aeons.components.CRender;
import aeons.components.CUpdate;
import aeons.events.ComponentEvent;
import aeons.events.EventEmitter;
import aeons.events.EventType;
import aeons.math.AeMath;
import aeons.math.Random;
import aeons.utils.TimeStep;
import aeons.utils.Timers;
import aeons.tween.Tweens;

/**
 * `Entities` is the entity manager for a scene.
 */
class Entities {
  /**
   * A map with all components in the scene.
   * They are stored [componentClassName][entityId]
   */
  final components = new Map<String, Array<Component>>();

  /**
   * A list of all entities in the game.
   */
  final entities: Array<Entity> = [];

  /**
   * A list of entities to add at the start of the next update.
   */
  final entitiesToAdd: Array<Entity> = [];

  /**
   * A list of entities to remove at the start of the next update.
   */
  final entitiesToRemove: Array<Entity> = [];

  /**
   * A list of components to add at the start of the next update.
   */
  final componentsToAdd: Array<ComponentUpdate> = [];

  /**
   * A list of components to remove at the start of the next update.
   */
  final componentsToRemove: Array<ComponentUpdate> = [];

  /**
   * A list of components that should be updated every update call.
   * These are stored [entityId][List of components]
   */
  final updateComponents: Array<Array<Updatable>> = [];

  /**
   * A list of components that should be rendered every frame.
   * These are stored [entityId][List of components]
   */
  final renderComponents: Array<Array<Renderable>> = [];

  /**
   * Entity ids that have been used but are free now.
   */
  final freeIds: Array<Int> = [];

  /**
   * The manager references.
   */
  final refs: EntitiesRefs;

  /**
   * The id to use for the next entity if there are no free ids in the list above.
   */
  var nextEntityId = -1;

  /**
   * Entities constructor.
   * @param refs The manager references.
   */
  public function new(refs: EntitiesRefs) {
    // Set this manager in the refs because this is used by entities and components.
    refs.entities = this;
    this.refs = refs;
  }

  /**
   * Update the entities and components that have been added or removed in the last update.
   */
  public function updateAddRemove() {
    // TODO: FIXME: This has a major design flaw. You can't access an entity or component until the
    // next frame. Multiple components added on the same frame on an enity cannot check for required components
    // like this. Probably update this to only send the events here for adding and do the actual adding in the addEntity
    // and addComponent.

    // Add entities.
    while (entitiesToAdd.length > 0) {
      entities.push(entitiesToAdd.pop());
    }

    // Remove entities.
    while (entitiesToRemove.length > 0) {
      final entity = entitiesToRemove.pop();
      freeIds.push(entity.id);

      // Loop through all components and remove them.
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

        // Send the component_removed message to all the systems that care about them so they can be updated.
        final eventType: EventType<ComponentEvent> = '${name}_removed';
        refs.events.emit(ComponentEvent.get(eventType, entity));

        component.cleanup();
      }
    }

    // Add new components.
    while (componentsToAdd.length > 0) {
      final update = componentsToAdd.pop();
      var eventType: EventType<ComponentEvent> = '${update.componentName}_added';

      if (components[update.componentName] == null) {
        components[update.componentName] = [];
      }
      components[update.componentName][update.entity.id] = update.component;

      // Send an event to systems that listen for this component.
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

    // Remove components.
    while (componentsToRemove.length > 0) {
      final update = componentsToRemove.pop();
      var eventType: EventType<ComponentEvent> = '${update.componentName}_removed';

      components[update.componentName][update.entity.id] = null;

      // Send an event to systems that listen for this component.
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

  /**
   * Add a new entity to the manager.
   * @param entityType The type of entity to add.
   * @return The created entity.
   */
  public function addEntity<T: Entity>(entityType: Class<T>): T {
    final id = getNextEntityId();
    refs.id = id;

    final entity = Type.createInstance(entityType, [refs]);
    entitiesToAdd.push(entity);

    return entity;
  }

  /**
   * Remove an entity from the manager.
   * @param entity The entity to remove.
   */
  public function removeEntity(entity: Entity) {
    entitiesToRemove.push(entity);
  }

  /**
   * Get an entity using the id.
   * @param id The id of the entity.
   * @return The entity.
   */
  public function getEntityById<T: Entity>(id: Int): T {
    for (entity in entities) {
      if (entity.id == id) {
        return cast entity;
      }
    }

    return null;
  }

  /**
   * Remove an entity by its id.
   * @param id The entity id.
   */
  public function removeEntityById(id: Int) {
    final entity = getEntityById(id);
    if (entity != null) {
      entitiesToRemove.push(entity);
    }
  }

  /**
   * Add a component to an entity.
   * @param entity The entity to add to.
   * @param componentType The type of component to add.
   * @return The created component.
   */
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

  /**
   * Remove a component from an entity.
   * @param entity The entity to remove from.
   * @param componentType The component type to remove.
   */
  public function removeComponent(entity: Entity, componentType: Class<Component>) {
    final name = Type.getClassName(componentType);

    if (components[name] == null || components[name][entity.id] == null) {
      throw 'Component ${name} does not exist on entity ${entity.id}.';
    }

    final component = components[name][entity.id];
    componentsToRemove.push({ entity: entity, componentName: name, component: component });
  }

  /**
   * Get a component from an entity.
   * @param entityId The id of the entity.
   * @param componentType The type of component you want.
   * @return The component. Throws if the component does not exist.
   */
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

  /**
   * Get all updatable components on an entity. The order will be the order they are added in with addComponent.
   * @param entityId The entity id
   * @return The list of updatable components.
   */
  public function getUpdateComponents(entityId: Int): Array<Updatable> {
    if (updateComponents[entityId] == null) {
      return [];
    }

    return updateComponents[entityId];
  }

  /**
   * Get all renderable components on an entity. The order will be the order they are added in with addComponent.
   * @param entityId The entity id
   * @return The list of renderable components.
   */
  public function getRenderComponents(entityId: Int): Array<Renderable> {
    if (renderComponents[entityId] == null) {
      return [];
    }

    return renderComponents[entityId];
  }

  /**
   * Check if an entity has a component type.
   * @param entityId The entity id to check.
   * @param componentType The component type to check.
   * @return True if the entity has that component.
   */
  public function hasComponent(entityId: Int, componentType: Class<Component>): Bool {
    final name = Type.getClassName(componentType);

    if (components[name] == null) {
      return false;
    }

    return components[name][entityId] != null;
  }

  /**
   * Check if an entity has all components in a list.
   * @param entityId The entity id to check.
   * @param componentTypess The component types to check.
   * @return True if the entity has all the components in the list.
   */
  public function hasComponents(entityId: Int, componentTypes: Array<Class<Component>>): Bool {
    for (component in componentTypes) {
      if (!hasComponent(entityId, component)) {
        return false;
      }
    }

    return true;
  }

  /**
   * Same as hasComponents but uses the class as string instead of a type. 
   * @param entityId The entity id to check.
   * @param componentTypess The component types to check.
   * @return True if the entity has all the components in the list.
   */
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

  /**
   * Get a list of all components an entity has. This will be a list of base components.
   * @param entityId The entity to get the components from.
   * @return The list of components.
   */
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

  /**
   * Get an id for the next entity. All entities should have a unique id.
   * @return The id.
   */
  function getNextEntityId(): Int {
    // First check if we can reuse an existing id.
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