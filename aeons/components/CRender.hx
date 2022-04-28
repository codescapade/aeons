package aeons.components;

import aeons.core.Component;
import aeons.core.Renderable;
import aeons.graphics.RenderTarget;
import aeons.math.Rect;

/**
 * CRender Is a component that gets added automatically to an entity that has a component that extends `Renderable`.
 * This goes through all renderable components and renders them.
 */
class CRender extends Component {
  /**
   * The list of renderable components.
   */
  var components: Array<Renderable>;

  /**
   * CRender constructor.
   */
  public function new() {
    super();
  }

  /**
   * Init gets called after the component has been added to an entity.
   * @param entityId The id of the entity the component got added to.
   */
  public override function init(entityId: Int) {
    super.init(entityId);
    components = Aeons.entities.getRenderComponents(entityId);
  }

  /**
   * Render the components.
   * @param target The render target to render to.
   * @param cameraBounds Used to render only what the camera can see.
   */
  public function render(target: RenderTarget) {
    for (component in components) {
      final comp: Component = cast component;
      if (comp.active) {
        component.render(target);
      }
    }
  }

  /**
   * Check if the component is inside the camera bounds and should be rendered.
   * @param cameraBounds Used to render only what the camera can see.
   * The bounds are in the local space of the component.
   * @return True if in bounds. Out of bounds will not render using the RenderSystem.
   */
  public function inCameraBounds(cameraBounds: Rect): Bool {
    var inBounds = false;
    for (component in components) {
      if (component.inCameraBounds(cameraBounds)) {
        inBounds = true;
      }
    }

    return inBounds;
  }
}
