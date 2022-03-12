package aeons.core;

/**
 * The component base class.
 */
class Component {
  /**
   * The entity this component belongs to.
   */
  public var entityId(default, null): Int;

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
   * Component constructor.
   */
  public function new() {}

  public function init(entityId: Int) {
    this.entityId = entityId;

    for (component in requiredComponents) {
      if (!hasComponent(component)) {
        throw 'Entity ${entityId} is missing a required ${Type.getClassName(component)} component.';
      }
    }
  }

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
    return Aeons.entities.getComponent(entityId, componentType);
  }

  /**
   * Check if this entity has a type of component.
   * @param componentType The type of component to check.
   * @return True if the entity has the component.
   */
  public inline function hasComponent(componentType: Class<Component>): Bool {
    return Aeons.entities.hasComponent(entityId, componentType);
  }

  /**
   * Check if this entity a multiple components.
   * @param componentTypes The list of components to check.
   * @return True if the entity has all components.
   */
  public inline function hasComponents(componentTypes: Array<Class<Component>>): Bool {
    return Aeons.entities.hasComponents(entityId, componentTypes);
  }

  /**
   * Required components getter. Override this in a derived class to set the required components.
   */
  function get_requiredComponents(): Array<Class<Component>> {
    return [];
  }
}