package aeons.events;

import aeons.core.Entity;

/**
 * ComponentEvent is used to update systems when components get added or removed.
 */
class ComponentEvent extends Event {
  /**
   * The entity the component changed on.
   */
  var entity: Entity;
}
