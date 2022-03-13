package aeons.core;

import aeons.graphics.RenderTarget;

/**
 * The `Entity` class is the main container class in the game.
 * Components can be added to it for functionality.
 */
@:autoBuild(aeons.core.Macros.buildPool())
class Entity {
  /**
   * The unique id for this entity.
   */
  public var id(default, null): Int;

  /**
   * Is this entity active. This also updates all components that are on this entity.
   */
  public var active(default, set) = true;

  /**
   * Entity constructor.
   */
  public function new() {}

  /**
   * Initialize variables in the entity. This gets called when the entity is added to the entity manager
   * using `Aeons.entities.addEntity`.
   * @param id 
   */
  public function init(id: Int) {
    this.id = id;
  }

  /**
   * Add a component to this entity.
   * @param componentType The component type to add.
   * @return The created component.
   */
  public inline function addComponent(component: Component) {
    return Aeons.entities.addComponent(this, component);
  }

  /**
   * Remove a component from this entity.
   * @param componentType The component type to remove.
   */
  public inline function removeComponent(componentType: Class<Component>) {
    return Aeons.entities.removeComponent(this, componentType);
  }

  /**
   * Retreive a component from the entity.
   * @param componentType The component type to get.
   * @return The component.
   */
  public inline function getComponent<T: Component>(componentType: Class<T>): T {
    return Aeons.entities.getComponent(id, componentType);
  }

  /**
   * Check if this entity has a component type.
   * @param componentType The component type to check.
   * @return True if the entity has that component.
   */
  public inline function hasComponent(componentType: Class<Component>): Bool {
    return Aeons.entities.hasComponent(id, componentType);
  }

  /**
   * Check if this entity has all components in a list.
   * @param componentTypess The component types to check.
   * @return True if the entity has all the components in the list.
   */
  public inline function hasComponents(componentTypes: Array<Class<Component>>): Bool {
    return Aeons.entities.hasComponents(id, componentTypes);
  }

  /**
   * Same as hasComponents but uses the class as string instead of a type. 
   * @param componentTypess The component types to check.
   * @return True if the entity has all the components in the list.
   */
  public inline function hasBundleComponents(componentNames: Array<String>): Bool {
    return Aeons.entities.hasBundleComponents(id, componentNames);
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
    var components = Aeons.entities.getAllComponentsForEntity(id);
    for (component in components) {
      component.active = value;
    }

    return value;
  }
}