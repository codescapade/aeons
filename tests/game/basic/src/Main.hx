package;

import aeons.core.Game;

import scenes.TestScene;

class Main {
  static function main() {
    new Game({ title: 'Basic', startScene: TestScene });
  }
}