package aeons.components;

import aeons.core.Component;
import aeons.events.LayerEvent;

using aeons.math.AeMath;

/**
 * The layer component is used in the SRender system to order the renderable entities.
 */
class CLayer extends Component {
  /**
   * The current layer the entity is on. Cannot be lower than 0.
   */
  public var index(default, set): Int = -1; // Starts as -1 so the render system knows this is a new entry.

  /**
   * Initialize the component.
   * @param index Which layer the entity is on. Defaults to 0.
   * @return This component.
   */
  public function create(index = 0): CLayer {
    this.index = index;

    return this;
  }

  inline function set_index(value: Int): Int {
    value = Math.clampInt(value, 0, Std.int(AeMath.MAX_VALUE_INT));

    // Send a layer changed event.
    LayerEvent.emit(LayerEvent.LAYER_CHANGED, entityId, index, value);
    index = value;

    return index;
  }
}
