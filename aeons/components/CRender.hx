package aeons.components;

import aeons.core.Component;
import aeons.core.Renderable;
import aeons.graphics.RenderTarget;

/**
 * `CRender` Is a component that gets added automatically to an entity that has a component that extends `Renderable`.
 * This goes through all renderable components and renders them.
 */
class CRender extends Component {
  /**
   * The list of renderable components.
   */
  var components: Array<Renderable>;

  /**
   * Initialize the component.
   * @return This component.
   */
  public function init(): CRender {
    components = entities.getRenderComponents(entityId);

    return this;
  }

  /**
   * Render the components.
   * @param target The render target to render to.
   */
  public function render(target: RenderTarget) {
    for (component in components) {
      final comp: Component = cast component;
      if (comp.active) {
        component.render(target);
      }
    }
  }
}