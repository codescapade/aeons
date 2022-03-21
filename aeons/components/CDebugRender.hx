package aeons.components;

import aeons.core.DebugRenderable;
import aeons.core.Component;

import aeons.core.Component;
import aeons.core.Renderable;
import aeons.graphics.RenderTarget;
import aeons.math.Rect;

/**
 * `CDebugRender` Is a component that gets added automatically to an entity that has a component that extends
 * `DebugRenderable`. This goes through all renderable components and renders them.
 */
class CDebugRender extends Component {
  /**
   * The list of renderable components.
   */
  var components: Array<DebugRenderable>;

  public function new() {
    super();
  }

  /**
   * Initialize the component.
   * @return This component.
   */
  public override function init(entityId: Int) {
    super.init(entityId);
    components = Aeons.entities.getDebugRenderComponents(entityId);
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
        component.debugRender(target, cameraBounds);
      }
    }
  }
}