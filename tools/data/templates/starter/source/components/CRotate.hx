package components;

import aeons.components.CTransform;
import aeons.core.Component;
import aeons.core.Updatable;

/**
 * A simple component that rotates an entity at a speed.
 */
class CRotate extends Component implements Updatable {

  var transform: CTransform;

  final speed = 40;

  public function create(): CRotate {
    // Get the transform component reference so we can update the angle in the update function.
    transform = getComponent(CTransform);

    return this;
  }

  public function update(dt: Float) {
    transform.angle += speed * dt;
  }

  // This will check if a transform component exists on the entity this component gets added to,
  // because we need that component to rotate it.
  override function get_requiredComponents(): Array<Class<Component>> {
    return [CTransform];
  }
}
