package aeons.utils.services;

@:dox(hide)
class NullStorage implements Storage {
  public function new() {}

  public function readData(name: String): Blob {
    trace('readData not implemented');

    return null;
  }

  public function readString(name: String): String {
    trace('readString not implemented');

    return null;
  }

  public function readObject(name: String): Dynamic {
    trace('readObject not implemented');

    return null;
  }

  public function writeData(name: String, data: Blob) {
    trace('writeData not implemented');
  }

  public function writeString(name: String, data: String) {
    trace('writeString not implemented');
  }

  public function writeObject(name: String, data: Dynamic) {
    trace('writeObject not implemented');
  }

  public function appendData(name: String, data: Blob) {
    trace('appendData not implemented');
  }

  public function appendString(name: String, data: String) {
    trace('appendString not implemented');
  }

  public function canAppend(name: String): Bool {
    trace('canAppend not implemented');

    return false;
  }
}
