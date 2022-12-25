package aeons.events;

/**
 * The layer event is used in the CLayer component so let the CRender system
 * know an entity changed layers.
 */
class LayerEvent extends Event {
  /**
   * The layer changed event type.
   */
  public static inline final LAYER_CHANGED: EventType<LayerEvent> = 'aeons_layer_changed';

  /**
   * The id of the entity the CLayer component is on.
   */
  var entityId: Int;

  /**
   * The current layer. Is -1 when the component is added to an entity.
   */
  var currentLayer: Int;

  /**
   * The new layer for the entity.
   */
  var newLayer: Int;
}
