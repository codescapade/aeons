package;

import scenes.RenderScene;
import aeons.core.Game;

class Main {
  static function main() {
    new Game({ title: 'Basic', startScene: new RenderScene(), preload: true });
  }
}
