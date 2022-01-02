package aeons.core;

import kha.Scheduler;
import aeons.events.SceneEvent;
import kha.Framebuffer;
import haxe.Timer;
import kha.Assets;
import kha.System;

class Game {

  var display: Display;

  var loadFinished: Void->Void;

  var updateRate: Int;

  public function new(options:GameOptions) {
    final designWidth = options.designWidth == null ? 800 : options.designWidth;
    final designHeight = options.designHeight == null ? 600 : options.designHeight;

    final windowWidth = options.windowWidth == null ? designWidth : options.windowWidth;
    final windowHeight = options.windowHeight == null ? designHeight : options.windowHeight;
    updateRate = options.updateFrequency == null ? kha.Display.primary.frequency : options.updateFrequency;
    loadFinished = options.loadFinished;

    display = new Display(designWidth, designHeight);

    System.start({
      title: options.title,
      width: windowWidth,
      height: windowHeight,
      framebuffer: {
        samplesPerPixel: 2
      },
    }, (_) -> {
      if (options.preload != null && options.preload) {
        Assets.loadEverything(preloadComplete);
      } else {
        // Without the timer the callback doesn't get called properly.
        Timer.delay(() -> {
          preloadComplete();
        }, 10);
      }
    });
  }

  function preloadComplete() {
    display.scaleToWindow();

    System.notifyOnApplicationState(toForeground, willResume, willPause, toBackground, shutdown);
    Scheduler.addTimeTask(update, 0, 1.0 / updateRate);

    System.notifyOnFrames(render);
  }

  function update() {
    
  }

  function render(frames: Array<Framebuffer>) {
    
  }

  function willPause() {

  }

  function willResume() {

  }

  function toBackground() {

  }

  function toForeground() {

  }

  function shutdown() {

  }

  function popScene(event: SceneEvent) {

  }

  function pushScene(event: SceneEvent) {

  }

  function replaceScene(event: SceneEvent) {

  }

  function createScene(scene: Class<Scene>, userData: Dynamic) {

  }
}

typedef GameOptions = {
  /**
   * The game title. Use in the title bar on some platforms.
   */
  var title: String;

  /**
   * The first scene to load when the game starts.
   */
  var startScene: Class<Scene>;

  /**
   * Should all assets be preloaded. Default is true.
   */
  var ?preload: Bool;

  /**
   * The width the game is designed for in pixels. Default is 800 pixels.
   */
  var ?designWidth: Int;

  /**
   * The height the game is designed for in pixels. Default is 600 pixels.
   */
  var ?designHeight: Int;

  /**
   * The width of the window in pixels on launch on supported platforms. Default is the design width.
   */
  var ?windowWidth: Int;

  /**
   * The height of the window in pixels on launch on supported platforms. Default is the design height.
   */
  var ?windowHeight: Int;

  /**
   * Is the game using pixel art. This sets the texture filtering to point. Default is false.
   */
  var ?pixelArt: Bool;

  /**
   * Function to call when the loading is complete. Normally not needed. I use it for testing.
   */
  var ?loadFinished: Void->Void;

  /**
   * How many times per second update is called. Default is same as render.
   */
  var ?updateFrequency: Int;
}