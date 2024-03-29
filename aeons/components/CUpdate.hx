package aeons.components;

import aeons.core.Component;
import aeons.core.Updatable;

/**
 * CUpdate Is a component that gets added automatically to an entity that has a component that extends `Updatable`.
 * This goes through all updatable components and updates them.
 */
class CUpdate extends Component {
  /**
   * The list of updatable components.
   */
  var components: Array<Updatable>;

  /**
   * Initialize the components.
   * @return This component.
   */
  public function create(): CUpdate {
    components = Aeons.entities.getUpdateComponents(entityId);

    return this;
  }

  /**
   * Update all components.
   * @param dt The time passed since the last update in seconds.
   */
  public function update(dt: Float) {
    for (component in components) {
      final comp: Component = cast component;
      if (comp.active) {
        component.update(dt);
      }
    }
  }
}
