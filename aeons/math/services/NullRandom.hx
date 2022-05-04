package aeons.math.services;

@:dox(hide)
class NullRandom implements Random {

  public function new() {}

  public var initialSeed(default, set): Int;

  public var currentSeed(get, set): Int;

  public function int(?min: Int, ?max: Int): Int {
    trace('int is not implemented');

    return -1;
  }

  public function float(min = 0.0, max = 1.0): Float {
    trace('float is not implemented');

    return -1;
  }

  public function set_initialSeed(value: Int): Int {
    trace('set initialseed is not implemented');

    return value;
  }

  public function get_currentSeed(): Int {
    trace('get currentSeed is not implemented');

    return -1;
  }

  public function set_currentSeed(value: Int): Int {
    trace('set currentSeed is not implemented');

    return value;
  }

  public function resetSeed() {
    trace('resetSeed is not implemented');
  }
}
