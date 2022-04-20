package aeons.utils.services;

@:dox(hide)
class InternalStorage implements Storage {

  public function new() {}

  public function readData(name: String): Blob {
    return kha.Storage.namedFile(name).read();
  }

  public function readString(name: String): String {
    return kha.Storage.namedFile(name).readString();
  }

  public function readObject(name: String): Dynamic {
    return kha.Storage.namedFile(name).readObject();
  }

  public function writeData(name: String, data: Blob) {
    kha.Storage.namedFile(name).write(data);
  }

  public function writeString(name: String, data: String) {
    kha.Storage.namedFile(name).writeString(data);
  }

  public function writeObject(name: String, data: Dynamic) {
    kha.Storage.namedFile(name).writeObject(data);
  }

  public function appendData(name: String, data: Blob) {
    kha.Storage.namedFile(name).append(data);
  }

  public function appendString(name: String, data: String) {
    kha.Storage.namedFile(name).appendString(data);
  }

  public function canAppend(name: String): Bool {
    return kha.Storage.namedFile(name).canAppend();
  }
}
