package;

import aeons.core.Game;

import scenes.GameScene;

class Main {
  static function main() {
    new Game({
      title: '{{game_name}}',
      preload: true,
      startScene: GameScene,
      designWidth: 800,
      designHeight: 600
    });
  }
}
