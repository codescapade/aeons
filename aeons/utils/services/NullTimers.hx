package aeons.utils.services;

class NullTimers implements Timers {

  public function new() {}

  public function create(interval: Float, callback: ()->Void, repeat: Int, startNow = false): Timer {
    trace('create is not implemented');

    return null;
  }

  public function update(dt: Float) {
    trace('update is not implemented');
  }

  public function remove(timer: Timer) {
    trace('remove is not implemented');
  }
}