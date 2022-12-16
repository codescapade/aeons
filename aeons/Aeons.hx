package aeons;

import aeons.assets.Assets;
import aeons.audio.Audio;
import aeons.core.Display;
import aeons.core.Entities;
import aeons.core.Systems;
import aeons.events.Events;
import aeons.math.Random;
import aeons.tween.Tweens;
import aeons.utils.Storage;
import aeons.utils.TimeStep;
import aeons.utils.Timers;

/**
 * With the Aeons class you can access all major systems in the engine. This uses a service locator
 * pattern to set the required services.
 */
class Aeons {
  /**
   * Asset management.
   */
  public static var assets(get, never): Assets;

  /**
   * Audio management.
   */
  public static var audio(get, never): Audio;

  /**
   * Display info.
   */
  public static var display(get, never): Display;

  /**
   * Entity manager.
   */
  public static var entities(get, never): Entities;

  /**
   * Event management.
   */
  public static var events(get, never): Events;

  /**
   * Seeded random number generator.
   */
  public static var random(get, never): Random;

  /**
   * Save an load data.
   */
  public static var storage(get, never): Storage;

  /**
   * ECS systems management.
   */
  public static var systems(get, never): Systems;

  /**
   * Timer management.
   */
  public static var timers(get, never): Timers;

  /**
   * Time step for fps and time scale.
   */
  public static var timeStep(get, never): TimeStep;

  /**
   * Tween manager.
   */
  public static var tweens(get, never): Tweens;

  static var _assets: Assets;

  static var _audio: Audio;

  static var _display: Display;

  static var _entities: Entities;

  static var _events: Events;

  static var _random: Random;

  static var _systems: Systems;

  static var _timers: Timers;

  static var _timeStep: TimeStep;

  static var _tweens: Tweens;

  static var _storage: Storage;

  /**
   * Set an assets provider.
   * @param assets The new provider.
   */
  public static function provideAssets(assets: Assets) {
    _assets = assets;
  }

  /**
   * Set an audio provider.
   * @param audio The new provider.
   */
  public static function provideAudio(audio: Audio) {
    _audio = audio;
  }

  /**
   * Set a display provider.
   * @param display The new provider.
   */
  public static function provideDisplay(display: Display) {
    _display = display;
  }

  /**
   * Set an entities provider.
   * @param entities The new provider.
   */
  public static function provideEntities(entities: Entities) {
    _entities = entities;
  }

  /**
   * Set an events provider.
   * @param events The new provider.
   */
  public static function provideEvents(events: Events) {
    _events = events;
  }

  /**
   * Set a random provider.
   * @param random The new provider.
   */
  public static function provideRandom(random: Random) {
    _random = random;
  }

  /**
   * Set a storage provider.
   * @param storage The new provider.
   */
  public static function provideStorage(storage: Storage) {
    _storage = storage;
  }

  /**
   * Set a systems provider.
   * @param systems The new provider.
   */
  public static function provideSystems(systems: Systems) {
    _systems = systems;
  }

  /**
   * Set an timers provider.
   * @param timers The new provider.
   */
  public static function provideTimers(timers: Timers) {
    _timers = timers;
  }

  /**
   * Set an time step provider.
   * @param timeStep The new provider.
   */
  public static function provideTimeStep(timeStep: TimeStep) {
    _timeStep = timeStep;
  }

  /**
   * Set an tweens provider.
   * @param tweens The new provider.
   */
  public static function provideTweens(tweens: Tweens) {
    _tweens = tweens;
  }

  static inline function get_assets(): Assets {
    return _assets;
  }

  static inline function get_audio(): Audio {
    return _audio;
  }

  static inline function get_display(): Display {
    return _display;
  }

  static inline function get_entities(): Entities {
    return _entities;
  }

  static inline function get_events(): Events {
    return _events;
  }

  static inline function get_random(): Random {
    return _random;
  }

  static inline function get_storage(): Storage {
    return _storage;
  }

  static inline function get_systems(): Systems {
    return _systems;
  }

  static inline function get_timers(): Timers {
    return _timers;
  }

  static inline function get_timeStep(): TimeStep {
    return _timeStep;
  }

  static inline function get_tweens(): Tweens {
    return _tweens;
  }
}
