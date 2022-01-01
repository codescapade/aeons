package;

import aeons.core.Entity;
import aeons.events.EventType;
import aeons.events.ComponentEvent;
import aeons.core.Game;
import aeons.core.Scene;

class Main {
  public static function main() {
    new Game({ title: 'Bunnies', startScene: Scene });

    final eventType: EventType<ComponentEvent> = 'added';
    final entity = new Entity(124);

    var event = ComponentEvent.get(eventType, entity);
    trace(event.entity.id);
    event.put();
  }
}