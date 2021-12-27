package aeons.core;

class Game {

  public function new(options:GameOptions) {
    trace('this is a test');
  }
}

typedef GameOptions = {
  var title: String;
  var startScene: Scene;
  var ?preload: Bool;
  var ?designWidth: Int;
  var ?designHeight: Int;
  var ?windowWidth: Int;
  var ?windowHeight: Int;
  var ?pixelArt: Bool;
  var ?loadFinished: Void->Void;
}