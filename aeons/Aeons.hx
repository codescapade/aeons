package aeons;

import aeons.core.Systems;
import aeons.core.Entities;
import aeons.core.Display;
import aeons.tween.services.NullTweens;
import aeons.utils.services.NullTimeStep;
import aeons.utils.services.NullTimers;
import aeons.math.services.NullRandom;
import aeons.events.services.NullEvents;
import aeons.core.services.NullEntities;
import aeons.core.services.NullDisplay;
import aeons.core.services.NullSystems;
import aeons.utils.TimeStep;
import aeons.utils.Timers;
import aeons.tween.Tweens;
import aeons.math.Random;
import aeons.events.Events;
import aeons.audio.services.NullAudio;
import aeons.audio.Audio;
import aeons.assets.services.NullAssets;
import aeons.assets.Assets;

class Aeons {

  public static var assets(get, never): Assets;

  public static var audio(get, never): Audio;

  public static var display(get, never): Display;

  public static var entities(get, never): Entities;

  public static var events(get, never): Events;

  public static var random(get, never): Random;

  public static var systems(get, never): Systems;

  public static var timers(get, never): Timers;

  public static var timeStep(get, never): TimeStep;

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

  public static function provideAssets(assets: Assets) {
    _assets = assets;
  }

  public static function provideAudio(audio: Audio) {
    _audio = audio;
  }

  public static function provideDisplay(display: Display) {
    _display = display;
  }

  public static function provideEntities(entities: Entities) {
    _entities = entities;
  }

  public static function provideEvents(events: Events) {
    _events = events;
  }

  public static function provideRandom(random: Random) {
    _random = random;
  }

  public static function provideSystems(systems: Systems) {
    _systems = systems;
  }

  public static function provideTimers(timers: Timers) {
    _timers = timers;
  }

  public static function provideTimeStep(timeStep: TimeStep) {
    _timeStep = timeStep;
  }

  public static function provideTweens(tweens: Tweens) {
    _tweens = tweens;
  }

  static function get_assets(): Assets {
    return _assets == null ? nullAssets : _assets;
  }

  static function get_audio(): Audio {
    return _audio == null ? nullAudio : _audio;
  }

  static function get_display(): Display {
    return _display == null ? nullDisplay : _display;
  }

  static function get_entities(): Entities {
    return _entities == null ? nullEntities : _entities;
  }

  static function get_events(): Events {
    return _events == null ? nullEvents : _events;
  }

  static function get_random(): Random {
    return _random == null ? nullRandom : _random;
  }

  static function get_systems(): Systems {
    return _systems == null ? nullSystems : _systems;
  }

  static function get_timers(): Timers {
    return _timers == null ? nullTimers : _timers;
  }

  static function get_timeStep(): TimeStep {
    return _timeStep == null ? nullTimeStep : _timeStep;
  }

  static function get_tweens(): Tweens {
    return _tweens == null ? nullTweens : _tweens;
  }
}