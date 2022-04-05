package aeons.utils.services;

@:dox(hide)
class NullTimeStep implements TimeStep {

  public var dt(default, null): Float;

  public var fps(default, null): Int;

  public var timeScale: Float;

  public function new() {}

	public function update() {
    trace('update is not implemented');
  }

  public function render() {
    trace('render is not implemented');
  }

  public function reset() {
    trace('reset is not implemented');
  }
}