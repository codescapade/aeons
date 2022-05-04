package aeons.core;

interface Entities {

  /**
   * Add a new entity to the manager.
   * @param entity The entity you want to add.
   * @return The id the entity got when it was added to the entities.
   */
  function addEntity<T: Entity>(entity: T): T;

  /**
   * Remove an entity from the manager.
   * @param entity The entity to remove.
   */
  function removeEntity(entity: Entity): Void;

  /**
   * Get an entity using the id.
   * @param id The id of the entity.
   * @return The entity.
   */
  function getEntityById(id: Int): Entity;

  /**
   * Remove an entity by its id.
   * @param id The entity id.
   */
  function removeEntityById(id: Int): Void;

  /**
   * Update the entities and components that have been removed in the last update.
   */
  function updateRemoved(): Void;

  /**
   * Add a component to an entity.
   * @param entity The entity to add to.
   * @param componentType The type of component to add.
   * @return The created component.
   */
  function addComponent<T: Component>(entity: Entity, component: T): T;

  /**
   * Remove a component from an entity.
   * @param entity The entity to remove from.
   * @param componentType The component type to remove.
   */
  function removeComponent(entity: Entity, componentType: Class<Component>): Void;

  /**
   * Get a component from an entity.
   * @param entityId The id of the entity.
   * @param componentType The type of component you want.
   * @return The component. Throws if the component does not exist.
   */
  function getComponent<T: Component>(entityId: Int, componentType: Class<T>): T;

  /**
   * Get all updatable components on an entity. The order will be the order they are added in with addComponent.
   * @param entityId The entity id
   * @return The list of updatable components.
   */
  function getUpdateComponents(entityId: Int): Array<Updatable>;

  /**
   * Get all renderable components on an entity. The order will be the order they are added in with addComponent.
   * @param entityId The entity id
   * @return The list of renderable components.
   */
  function getRenderComponents(entityId: Int): Array<Renderable>;

  /**
   * Get all debug renderable components on an entity. The order will be the order they are added in with addComponent.
   * @param entityId The entity id
   * @return The list of debug renderable components.
   */
  function getDebugRenderComponents(entityId: Int): Array<DebugRenderable>;

  /**
   * Check if an entity has a component type.
   * @param entityId The entity id to check.
   * @param componentType The component type to check.
   * @return True if the entity has that component.
   */
  function hasComponent(entityId: Int, componentType: Class<Component>): Bool;

  /**
   * Check if an entity has all components in a list.
   * @param entityId The entity id to check.
   * @param componentTypess The component types to check.
   * @return True if the entity has all the components in the list.
   */
  function hasComponents(entityId: Int, componentTypes: Array<Class<Component>>): Bool;

  /**
   * Same as hasComponents but uses the class as string instead of a type. 
   * @param entityId The entity id to check.
   * @param componentTypess The component types to check.
   * @return True if the entity has all the components in the list.
   */
  function hasBundleComponents(entityId: Int, componentNames: Array<String>): Bool;

  /**
   * Get a list of all components an entity has. This will be a list of base components.
   * @param entityId The entity to get the components from.
   * @return The list of components.
   */
  function getAllComponentsForEntity(entityId: Int): Array<Component>;

  /**
   * Remove all entities from the manager.
   */
  function cleanup(): Void;
}
