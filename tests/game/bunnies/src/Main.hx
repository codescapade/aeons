package;

import aeons.core.Game;

import scenes.GameScene;

class Main {
  public static function main() {
    new Game({ title: 'Bunnies', startScene: GameScene });
  }
}