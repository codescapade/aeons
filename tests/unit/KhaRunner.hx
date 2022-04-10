package;

import kha.System;

class KhaRunner {
  static var isRunning = false;

  public static function startKha(callback: ()->Void) {
    if (!isRunning) {
      isRunning = true;
      System.start({}, (_) -> {
        callback();
      });
    } else {
      callback();
    }
  }
}
