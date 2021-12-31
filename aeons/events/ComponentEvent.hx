package aeons.events;

import aeons.core.Entity;

class ComponentEvent extends Event {

  public var entity(default, null): Entity;

  public function new() {
    super();
  }
}