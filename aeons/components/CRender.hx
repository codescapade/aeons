package aeons.components;

import aeons.core.Renderable;
import aeons.graphics.RenderTarget;
import aeons.core.Component;

class CRender extends Component {

  var components: Array<Renderable>;

  public function init(): CRender {
    components = entities.getRenderComponents(entityId);

    return this;
  }

  public function render(target: RenderTarget) {
    for (component in components) {
      final comp: Component = cast component;
      if (comp.active) {
        component.render(target);
      }
    }
  }
}