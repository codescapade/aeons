package aeons.core.services;

import aeons.components.CRender;
import aeons.components.CUpdate;
import aeons.events.ComponentEvent;
import aeons.events.EventType;
import aeons.math.AeMath;

/**
 * `Entities` is the entity manager for a scene.
 */
class InternalEntities implements Entities {
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
   * A list of entities to remove at the start of the next update.
   */
  final entitiesToRemove: Array<EntityRemovedInfo> = [];

  /**
   * A list of components to add at the start of the next update.
   */
  final componentsToAdd: Array<ComponentEvent> = [];

  /**
   * A list of components to remove at the start of the next update.
   */
  final componentsToRemove: Array<ComponentRemovedInfo> = [];

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
   * The id to use for the next entity if there are no free ids in the list above.
   */
  var nextEntityId = -1;

  /**
   * Entities constructor.
   */
  public function new() {}

  public function addEntity<T: Entity>(entity: T): T {
    final id = getNextEntityId();
    entities.push(entity);
    entity.init(id);

    return entity;
  }

  public function removeEntity(entity: Entity, pool = false) {
    entitiesToRemove.push({ entity: entity, pool: pool });
  }

  public function getEntityById<T: Entity>(id: Int): T {
    for (entity in entities) {
      if (entity.id == id) {
        return cast entity;
      }
    }

    return null;
  }

  public function removeEntityById(id: Int, pool = false) {
    final entity = getEntityById(id);
    if (entity != null) {
      entitiesToRemove.push({ entity: entity, pool: pool });
    }
  }

  public function addComponent<T: Component>(entity: Entity, component: T): T {
    final componentClass = Type.getClass(component);
    final name = Type.getClassName(componentClass);

    if (components[name] != null) {
      if (components[name][entity.id] != null) {
        throw 'Component ${name} already exists on entity ${entity.id}.';
      }
    }

    final eventType: EventType<ComponentEvent> = 'aeons_${name}_added';

    if (components[name] == null) {
      components[name] = [];
    }
    components[name][entity.id] = component;
    component.init(entity.id);

    componentsToAdd.push(ComponentEvent.get(eventType, entity));

    if (Std.isOfType(component, Updatable)) {
      if (updateComponents[entity.id] == null) {
        updateComponents[entity.id] = [cast component];

        // Add an update component if it does not exist yet.
        if (!hasComponent(entity.id, CUpdate)) {
          final updateComp = new CUpdate();
          final updateCompName = Type.getClassName(CUpdate);
          if (components[updateCompName] == null) {
            components[updateCompName] = [];
          }
          components[updateCompName][entity.id] = updateComp;
          updateComp.init(entity.id);

          final updateEventType = 'aeons_${updateCompName}_added';
          componentsToAdd.push(ComponentEvent.get(updateEventType, entity));
        }
      } else {
        updateComponents[entity.id].push(cast component);
      }
    }

    if (Std.isOfType(component, Renderable)) {
      if (renderComponents[entity.id] == null) {
        renderComponents[entity.id] = [cast component];

        // Add a render component if it does not exist yet.
        if (!hasComponent(entity.id, CRender)) {
          final renderComp = new CRender();
          final renderCompName = Type.getClassName(CRender);
          if (components[renderCompName] == null) {
            components[renderCompName] = [];
          }
          components[renderCompName][entity.id] = renderComp;
          renderComp.init(entity.id);

          final renderEventType = 'aeons_${renderCompName}_added';
          componentsToAdd.push(ComponentEvent.get(renderEventType, entity));
        }
      } else {
        renderComponents[entity.id].push(cast component);
      }
    }

    return component;
  }

  public function removeComponent(entity: Entity, componentType: Class<Component>, pool: Bool = false) {
    final name = Type.getClassName(componentType);

    if (components[name] == null || components[name][entity.id] == null) {
      throw 'Component ${name} does not exist on entity ${entity.id}.';
    }

    final component = components[name][entity.id];
    componentsToRemove.push({ entity: entity, componentName: name, component: component, pool: pool });
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

  public function cleanup() {
    for (entity in entities) {
      removeEntity(entity);
    }
    updateAddRemove();
  }

  public function updateAddRemove() {
    // Remove entities.
    while (entitiesToRemove.length > 0) {
      final entityInfo = entitiesToRemove.pop();
      freeIds.push(entityInfo.entity.id);

      // Loop through all components and remove them.
      final allComponents = getAllComponentsForEntity(entityInfo.entity.id);
      for (component in allComponents) {
        final name = Type.getClassName(Type.getClass(component));
        components[name][entityInfo.entity.id] = null;
        if (Std.isOfType(component, Updatable)) {
          updateComponents[entityInfo.entity.id].remove(cast component);
        }
        if (Std.isOfType(component, Renderable)) {
          renderComponents[entityInfo.entity.id].remove(cast component);
        }

        // Send the component_removed message to all the systems that care about them so they can be updated.
        final eventType: EventType<ComponentEvent> = 'aeons_${name}_removed';
        Aeons.events.emit(ComponentEvent.get(eventType, entityInfo.entity));

        if (entityInfo.pool) {
          component.put();
        } else {
          component.cleanup();
        }
      }
      entityInfo.entity.cleanup();
    }

    // Send to systems the notifications of the new components.
    while (componentsToAdd.length > 0) {
      Aeons.events.emit(componentsToAdd.pop());
    }

    // Remove components.
    while (componentsToRemove.length > 0) {
      final update = componentsToRemove.pop();
      var eventType: EventType<ComponentEvent> = 'aeons_${update.componentName}_removed';

      components[update.componentName][update.entity.id] = null;

      // Send an event to systems that listen for this component.
      Aeons.events.emit(ComponentEvent.get(eventType, update.entity));
      update.component.cleanup();

      if (Std.isOfType(update.component, Updatable)) {
        updateComponents[update.entity.id].remove(cast update.component);

        // Remove the update component if there are no more components left to update.
        if (updateComponents[update.entity.id].length == 0) {
          updateComponents[update.entity.id] = null;
          final updateComp = getComponent(update.entity.id, CUpdate);
          final updateCompName = Type.getClassName(CUpdate);
          eventType = 'aeons_${updateCompName}_removed';
          components[updateCompName][update.entity.id] = null;
          Aeons.events.emit(ComponentEvent.get(eventType, update.entity));
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
          eventType = 'aeons_${renderCompName}_removed';
          components[renderCompName][update.entity.id] = null;
          Aeons.events.emit(ComponentEvent.get(eventType, update.entity));
          renderComp.cleanup();
        }
      }
    }
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

/**
 * Component info that is stored when a component is removed so it can be deleted and the start of the next frame.
 */
@:structInit
class ComponentRemovedInfo {
  /**
   * The entity that was changed.
   */
  public final entity: Entity;

  /**
   * The component that was removed from the entity.
   */
  public final component: Component;

  /**
   * The class name of the component as string.
   */
  public final componentName: String;

  /**
   * Should the component be put back in its object pool.
   */
  public final pool: Bool;
}

@:structInit
class EntityRemovedInfo {
  /**
   * The entity to remove.
   */
  public final entity: Entity;

  /**
   * Should the components be pooled.
   */
  public final pool: Bool;
}