package aeons.core;

import aeons.assets.Assets;
import aeons.audio.Audio;
import aeons.events.EventEmitter;
import aeons.graphics.RenderTarget;
import aeons.math.Random;
import aeons.utils.TimeStep;
import aeons.utils.Timers;
import aeons.tween.Tweens;

/**
 * The `Scene` class is meant to be sub classes and used to initialze and run a scene in your game.
 * Like a main menu, the game itself or a level.
 */
class Scene {
  /**
   * If set to true and there is a scene below this on the stack this scene will be renered on top.
   * Could be used for pause scenes.
   */
  public var isSubScene = false;

  /**
   * Some data sent from the previous scene. So you can store data between scenes.
   */
  final userData: Dynamic;

  /**
   * The main event emitter.
   */
  final events: EventEmitter;

  /**
   * The tweens manager.
   */
  final tweens: Tweens;

  /**
   * The timer manager.
   */
  final timers: Timers;

  /**
   * The audio manager.
   */
  final audio: Audio;

  /**
   * The asset manager.
   */
  final assets: Assets;

  /**
   * The display info.
   */
  final display: Display;

  /**
   * The time step if you need more than just delta time in the update function.
   */
  final timeStep: TimeStep;

  /**
   * Random number generator.
   */
  final random: Random;

  /**
   * Override this method to initalize your scene.
   */
  public function init() {}

  /**
   * Override this method to cleanup scene when it gets removed.
   */
  public function cleanup() {}

  /**
   * Called every update.
   * @param dt The time passed since the last update.
   */
  public function update(dt: Float) {}

  /**
   * Gets called every frame.
   * @param target The target to render to.
   */
  public function render(target: RenderTarget) {

  }

  /**
   * Called before the scene gets paused.
   */
  public function willPause() {}

  /**
   * Called before the scene resumes after pausing.
   */
  public function willResume() {}

  /**
   * Called when to game goes to the background.
   */
  public function toBackground() {}

  /**
   * Called when the game comes back from the background to the foreground.
   * 
   */
  public function toForeground() {}

  /**
   * Creates a new scene and sets all the references.
   * @param refs 
   */
  @:allow(aeons.core.Game)
  function new(refs: SceneRefs) {
    userData = refs.userData;
    events = refs.events;
    audio = refs.audio;
    display = refs.display;
    timeStep = refs.timeStep;
    assets = refs.assets;
    random = refs.random;

    tweens = new Tweens();
    timers = new Timers();
  }
}

/**
 * References to systems that are usefull in a scene.
 */
typedef SceneRefs = {
  /**
   * Data from another scene.
   */
  var userData: Dynamic;

  /**
   * The audio manager reference.
   */
  var audio: Audio;

  /**
   * The asset manager reference.
   */
  var assets: Assets;

  /**
   * The display info reference.
   */
  var display: Display;

  /**
   * The time steap reference.
   */
  var timeStep: TimeStep;

  /**
   * The random number generator.
   */
  var random: Random;

  /**
   * The event emitter reference.
   */
  var events: EventEmitter;
}