package aeons.core;

import aeons.audio.Audio;
import aeons.utils.TimeStep;
import aeons.events.EventEmitter;
import aeons.utils.Timers;
import aeons.tween.Tweens;
import aeons.math.Random;
import aeons.core.Entities.EntitiesRefs;
import aeons.graphics.RenderTarget;
import aeons.assets.Assets;

class Entity {
  public final id: Int;

  final assets: Assets;

  final audio: Audio;

  final events: EventEmitter;

  final entities: Entities;

  final display: Display;

  final random: Random;

  final tweens: Tweens;

  final timers: Timers;

  final timeStep: TimeStep;

  @:allow(aeons.core.Entities)
  function new(refs: EntitiesRefs) {
    id = refs.id;
    assets = refs.assets;
    audio = refs.audio;
    events = refs.events;
    entities = refs.entities;
    display = refs.display;
    random = refs.random;
    tweens = refs.tweens;
    timers = refs.timers;
    timeStep = refs.timeStep;
  }

  public function update(dt: Float) {}

  public function render(target: RenderTarget) {}

  public function cleanup() {}
}