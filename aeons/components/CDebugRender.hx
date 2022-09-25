package aeons.components;

import aeons.core.Component;
import aeons.core.DebugRenderable;
import aeons.graphics.RenderTarget;
import aeons.math.Rect;

/**
 * CDebugRender is a component that gets added automatically to an entity that has a component that extends
 * `DebugRenderable`. This goes through all renderable components and renders them.
 */
class CDebugRender extends Component {
  /**
   * The list of renderable components.
   */
  var components: Array<DebugRenderable>;

  /**
   * Initialize the component.
   * @return This component.
   */
  public function create(): CDebugRender {
    components = Aeons.entities.getDebugRenderComponents(entityId);

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
        component.debugRender(target);
      }
    }
  }

  /**
   * Check if the component is inside the camera bounds and should be rendered.
   * @param cameraBounds Used to render only what the camera can see.
   * @return True if in bounds.
   */
  public function inCameraBounds(cameraBounds: Rect): Bool {
    return true;
  }
}
