package aeons.core;

import aeons.utils.services.InternalTimeStep;
import aeons.math.services.InternalRandom;
import aeons.events.services.InternalEvents;
import aeons.core.services.InternalDisplay;
import aeons.audio.services.InternalAudio;
import aeons.assets.services.InternalAssets;
import aeons.events.SceneEvent;
import aeons.input.Input;
import aeons.graphics.RenderTarget;

import haxe.Timer;

import kha.Framebuffer;
import kha.Scaler;
import kha.Scheduler;
import kha.System;

/**
 * The `Game` class is use to start Aeons. You create a new instance of it to start it.
 */
class Game {
  /**
   * The update refresh rate in frames per second.
   */
  var updateRate: Int;

  /**
   * The main render target.
   */
  var renderTarget: RenderTarget;

  /**
   * Input manager reference.
   */
  var input: Input;

  /**
   * The scene that is active.
   */
  var currentScene: Scene;

  /**
   * The index in the scenes array for the current scene.
   */
  var currentSceneIndex = 0;

  /**
   * The scene stack.
   */
  final scenes: Array<Scene> = [];

  /**
   * The first scene in the game.
   */
  final startScene: Class<Scene>;

  /**
   * Callback when the game has finished loading.
   */
  final loadFinished: Void->Void;

  /**
   * Game constructor.
   * @param options Start options.
   */
  public function new(options:GameOptions) {
    final designWidth = options.designWidth == null ? 800 : options.designWidth;
    final designHeight = options.designHeight == null ? 600 : options.designHeight;

    final windowWidth = options.windowWidth == null ? designWidth : options.windowWidth;
    final windowHeight = options.windowHeight == null ? designHeight : options.windowHeight;
    updateRate = options.updateFrequency == null ? kha.Display.primary.frequency : options.updateFrequency;
    loadFinished = options.loadFinished;
    startScene = options.startScene;

    Aeons.provideDisplay(new InternalDisplay());
    Aeons.display.init(designWidth, designHeight);

    // Start Kha.
    System.start({
      title: options.title,
      width: windowWidth,
      height: windowHeight,
      framebuffer: {
        samplesPerPixel: 2
      },
    }, (_) -> {
      if (options.preload != null && options.preload) {
        kha.Assets.loadEverything(preloadComplete);
      } else {
        // Without the timer the callback doesn't get called properly.
        Timer.delay(() -> {
          preloadComplete();
        }, 10);
      }
    });
  }

  /**
   * Setup the game when Kha has finished loading.
   */
  function preloadComplete() {
    Aeons.display.scaleToWindow();

    renderTarget = new RenderTarget(Aeons.display.viewWidth, Aeons.display.viewHeight);

    Aeons.provideAssets(new InternalAssets());
    Aeons.provideAudio(new InternalAudio());
    Aeons.provideEvents(new InternalEvents());
    Aeons.provideRandom(new InternalRandom());
    Aeons.provideTimeStep(new InternalTimeStep());
    
    input = new Input();

    Aeons.events.pushSceneList();

    // Setup the scene change listeners.
    Aeons.events.on(SceneEvent.PUSH, pushScene, true, 0, true);
    Aeons.events.on(SceneEvent.POP, pushScene, true, 0, true);
    Aeons.events.on(SceneEvent.REPLACE, pushScene, true, 0, true);

    createScene(startScene, null);

    // Setup kha callbacks.
    System.notifyOnApplicationState(toForeground, willResume, willPause, toBackground, shutdown);
    Scheduler.addTimeTask(update, 0, 1.0 / updateRate);
    System.notifyOnFrames(render);

    if (loadFinished != null) {
      loadFinished();
    }
  }

  /**
   * Called at the specified update frequency or same as frame update.
   */
  function update() {
    Aeons.timeStep.update();
    currentScene.update(Aeons.timeStep.dt);
  }

  /**
   * Called every frame.
   * @param frames List of frame buffers.
   */
  function render(frames: Array<Framebuffer>) {
    Aeons.timeStep.render();

    // Render the scene below the current scene if the current scene is a sub scene.
    if (currentScene.isSubScene && currentSceneIndex > 0) {
      scenes[currentSceneIndex - 1].render(renderTarget);
    }
    currentScene.render(renderTarget);

    /**
     * Render the main renderTarget to the screen.
     */
    final mainBuffer = frames[0].g2;
    mainBuffer.color = White;
    mainBuffer.begin();
    mainBuffer.imageScaleQuality = High;
    Scaler.scale(renderTarget.image, frames[0], System.screenRotation);
    mainBuffer.end();
  }

  /**
   * Called when Kha will pause.
   */
  function willPause() {
    currentScene.willPause();
  }

  /**
   * Called when Kha will resume.
   */
  function willResume() {
    currentScene.willResume();
  }

  /**
   * Called when Kha goes to the background.
   */
  function toBackground() {
    currentScene.toBackground();
  }

  /**
   * Called when Kha goes to the foreground.
   */
  function toForeground() {
    Aeons.timeStep.reset();
    currentScene.toForeground();
  }

  /**
   * Called when kha shuts down.
   */
  function shutdown() {}

  /**
   * Pop a scene from the stack. Does nothing if there is only one scene in the stack.
   * @param event The scene event.
   */
  function popScene(event: SceneEvent) {
    event.canceled = true;
    if (scenes.length > 1) {
      scenes.pop().cleanup();
      Aeons.events.popSceneList();

      currentSceneIndex--;
      currentScene = scenes[currentSceneIndex];
      currentScene.willResume();
    }
  }

  /**
   * Push a scene to the stack. This pauses the current scene.
   * @param event The scene event with the new scene type and user data.
   */
  function pushScene(event: SceneEvent) {
    event.canceled = true;
    currentScene.willPause();
    currentSceneIndex++;

    Aeons.events.pushSceneList();
    createScene(event.sceneType, event.userData);
  }

  /**
   * Replace the current scene. This removes the current scene and cleans it up.
   * @param event The scene event with the new scene type and user data.
   */
  function replaceScene(event: SceneEvent) {
    event.canceled = true;
    if (event.clearAll) {
      while (scenes.length > 0) {
        scenes.pop().cleanup();
        Aeons.events.popSceneList();
      }

      Aeons.events.resetIndex();
      currentSceneIndex = 0;
    } else {
      scenes.pop().cleanup();
      Aeons.events.popSceneList();
    }

    Aeons.events.pushSceneList();
    createScene(event.sceneType, event.userData);
  }

  /**
   * Create a new scene instance.
   * @param sceneType The scene type to instantiate.
   * @param userData Data to transfer between scenes.
   */
  function createScene(sceneType: Class<Scene>, userData: Dynamic) {
    final scene = Type.createInstance(sceneType, [userData]);
    scenes.push(scene);
    currentScene = scene;
    scene.init();
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