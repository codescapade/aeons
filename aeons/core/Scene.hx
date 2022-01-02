package aeons.core;

import aeons.tween.Tweens;
import aeons.events.EventEmitter;

class Scene {

  public var isSubScene = false;

  final userData: Dynamic;

  final events: EventEmitter;

  final tweens: Tweens;

  @:allow(aeons.core.Game)
  function new(refs: SceneRefs) {
    userData = refs.userData;
    events = refs.events;
    tweens = refs.tweens;
  }
}

typedef SceneRefs = {
  var userData: Dynamic;
  var events: EventEmitter;
  var tweens: Tweens;
}