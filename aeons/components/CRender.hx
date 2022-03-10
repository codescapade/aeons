package aeons.components;

import aeons.core.Component;
import aeons.core.Renderable;
import aeons.graphics.RenderTarget;
import aeons.math.Rect;

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
    components = Aeons.entities.getRenderComponents(entityId);

    return this;
  }

  /**
   * Render the components.
   * @param target The render target to render to.
   * @param cameraBounds Used to render only what the camera can see.
   */
  public function render(target: RenderTarget, cameraBounds: Rect) {
    for (component in components) {
      final comp: Component = cast component;
      if (comp.active) {
        component.render(target, cameraBounds);
      }
    }
  }
}