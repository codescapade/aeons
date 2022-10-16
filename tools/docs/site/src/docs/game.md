---
layout: 'layouts/docs.html'
title: 'Game'
eleventyNavigation:
  key: 'Game'
  order: 4
---

## The Game Class
The `Game` class is the entry point for Aeons. You create a new instance of this class in your `Main.hx` to start your
game.  
Below is an example on how to start your game.

```haxe
package scenes;

import aeons.core.Scene;

class GameScene extends Scene {

  public override function create() {
    // Initialize your scene here.
  }
}
```
```haxe
package;

import aeons.core.Game;

import scenes.GameScene;

class Main {
  static function main() {
    new Game({
      title: '',
      startScene: GameScene,
      preload: true,
      designWidth: 1280,
      designHeight: 720,
    });
  }
}

```