package;

import aeons.events.ComponentEvent;
import aeons.core.Game;
import aeons.core.Scene;

class Main {
  public static function main() {
    new Game({ title: 'Bunnies', startScene: Scene });

    var ev = new ComponentEvent();
  }
}