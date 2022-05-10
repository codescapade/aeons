package aeons.tween.services;

@:dox(hide)
class NullTweens implements Tweens {
  public function new() {}

  public function create(target: Dynamic, duration: Float, properties: Dynamic, isColor: Bool = false): Tween {
    trace('create is not implemented');

    return null;
  }

  public function pauseAll() {
    trace('pauseAll is not implemented');
  }

  public function resumeAll() {
    trace('resumeAll is not implemented');
  }

  public function remove(tween: Tween) {
    trace('remove is not implemented');
  }

  public function removeAllFrom(target: Dynamic) {
    trace('removeAllFrom is not implemented');
  }

  public function update(dt: Float) {
    trace('update is not implemented');
  }

  public function clear() {
    trace('clear is not implemented');
  }
}
