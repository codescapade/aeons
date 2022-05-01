package aeons.events.services;

@:dox(hide)
class NullEvents implements Events {

  public function new() {}

  public function on<T: Event>(type: EventType<T>, callback: T -> Void, canCancel = true, priority = 0,
      isGlobal = false) {
    trace('on is not implemented');
  }

	public function off<T: Event>(type: EventType<T>, callback: T -> Void, isGlobal = false) {
    trace('off is not implemented');
  }

  public function has<T: Event>(type: EventType<T>, isGlobal = false, ?callback: (T)->Void): Bool {
    trace('has is not implemented');
    return false;
  }

  public function emit(event: Event) {
    trace('emit is not implemented');
  }

  public function pushSceneList() {
    trace('pushSceneList is not implemented');
  }

  public function popSceneList() {
    trace('popSceneList is not implemented');
  }

  public function replaceSceneList(index: Int) {
    trace('replaceSceneList is not implemented');
  }

  public function resetIndex() {
    trace('resetIndex is not implemented');
  }

  public function setIndex(index: Int) {
    trace('setIndex is not implemented');
  }
}
