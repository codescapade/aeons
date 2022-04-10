package aeons;

import aeons.assets.Assets;
import aeons.assets.services.NullAssets;
import aeons.audio.Audio;
import aeons.audio.services.NullAudio;
import aeons.core.Display;
import aeons.core.Entities;
import aeons.core.Systems;
import aeons.core.services.NullDisplay;
import aeons.core.services.NullEntities;
import aeons.core.services.NullSystems;
import aeons.events.Events;
import aeons.events.services.NullEvents;
import aeons.math.Random;
import aeons.math.services.NullRandom;
import aeons.tween.Tweens;
import aeons.tween.services.NullTweens;
import aeons.utils.Timers;
import aeons.utils.TimeStep;
import aeons.utils.services.NullTimeStep;
import aeons.utils.services.NullTimers;

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
  static var nullAssets = new NullAssets();

  static var _audio: Audio;
  static var nullAudio = new NullAudio();

  static var _display: Display;
  static var nullDisplay = new NullDisplay();

  static var _entities: Entities;
  static var nullEntities = new NullEntities();

  static var _events: Events;
  static var nullEvents = new NullEvents();

  static var _random: Random;
  static var nullRandom = new NullRandom();

  static var _systems: Systems;
  static var nullSystems = new NullSystems();

  static var _timers: Timers;
  static var nullTimers = new NullTimers();

  static var _timeStep: TimeStep;
  static var nullTimeStep = new NullTimeStep();

  static var _tweens: Tweens;
  static var nullTweens = new NullTweens();

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
    #if debug
    return _assets == null ? nullAssets : _assets;
    #else
    return _assets;
    #end
  }

  static inline function get_audio(): Audio {
    #if debug
    return _audio == null ? nullAudio : _audio;
    #else
    return _audio;
    #end
  }

  static inline function get_display(): Display {
    #if debug
    return _display == null ? nullDisplay : _display;
    #else
    return _display;
    #end
  }

  static inline function get_entities(): Entities {
    #if debug
    return _entities == null ? nullEntities : _entities;
    #else
    return _entities;
    #end
  }

  static inline function get_events(): Events {
    #if debug
    return _events == null ? nullEvents : _events;
    #else
    return _events;
    #end
  }

  static inline function get_random(): Random {
    #if debug
    return _random == null ? nullRandom : _random;
    #else
    return _random;
    #end
  }

  static inline function get_systems(): Systems {
    #if debug
    return _systems == null ? nullSystems : _systems;
    #else
    return _systems;
    #end
  }

  static inline function get_timers(): Timers {
    #if debug
    return _timers == null ? nullTimers : _timers;
    #else
    return _timers;
    #end
  }

  static inline function get_timeStep(): TimeStep {
    #if debug
    return _timeStep == null ? nullTimeStep : _timeStep;
    #else
    return _timeStep;
    #end
  }

  static inline function get_tweens(): Tweens {
    #if debug
    return _tweens == null ? nullTweens : _tweens;
    #else
    return _tweens;
    #end
  }
}
