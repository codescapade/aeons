package aeons.components;

import aeons.core.Updatable;
import aeons.core.Component;

class CUpdate extends Component {

  var components: Array<Updatable>;

  public function init(): CUpdate {
    components = entities.getUpdateComponents(entityId);

    return this;
  }

  public function update(dt: Float) {
    for (component in components) {
      final comp: Component = cast component;
      if (comp.active) {
        component.update(dt);
      }
    }
  }
}