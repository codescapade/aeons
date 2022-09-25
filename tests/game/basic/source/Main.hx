package;

import aeons.core.Game;

import scenes.RenderScene;

class Main {
  static function main() {
    new Game({ title: 'Basic', startScene: RenderScene, preload: true });
  }
}
