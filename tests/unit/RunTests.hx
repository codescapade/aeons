package;

import aeons.utils.TimSortTest;

import buddy.BuddySuite;
import buddy.SuitesRunner;
import buddy.reporting.ConsoleColorReporter;

class RunTests {
  static function main() {
    final reporter = new ConsoleColorReporter();
    final tests = getTests();
    final runner = new SuitesRunner(tests, reporter);

    runner.run();

    #if sys
    Sys.exit(runner.statusCode());
    #end
  }


  static function getTests(?test: Class<BuddySuite>): Array<BuddySuite> {
    if (test == null) {
      return getAllTests();
    } else {
      return getSingleTest(test);
    }
  }

  static function getAllTests(): Array<BuddySuite> {

    return [
      new TimSortTest()
    ];
  }

  static function getSingleTest(test: Class<BuddySuite>): Array<BuddySuite> {
    return [Type.createInstance(test, [])];
  }
}