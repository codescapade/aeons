package aeons.utils;

import buddy.BuddySuite;
import mockatoo.Mockatoo.*;

using buddy.Should;
using mockatoo.Mockatoo;

using aeons.utils.TimSort;

class TimSortTest extends BuddySuite {

  public function new() {
    describe('aeons.utils.TimSort', {
      var hundredSortRnd: Array<Int>;
      var hundredSortAcs: Array<Int>;

      beforeEach({
        hundredSortAcs = [];
        hundredSortRnd = [];

        for (i in 0...100) {
          hundredSortAcs.push(i);
          hundredSortRnd.push(randomNumber(0, 100));
        }
        hundredSortAcs[50] = 40;
      });

      it('should sort a random array of 100 normally.', {
        hundredSortRnd.sort(compare);
        isAscending(hundredSortRnd).should.be(true);
      });

      it('should sort a random array of 100 using timsort.', {
        hundredSortRnd.timSort(compare);
        isAscending(hundredSortRnd).should.be(true);
      });
    });
  }

  function randomNumber(min: Int, max: Int): Int {
    return Std.int(Math.random() * (max - min) + min);
  }

  function compare(a: Int, b: Int): Int {
    if (a > b) {
      return 1;
    } else if (a < b) {
      return -1;
    }

    return 0;
  }

  function isAscending(array: Array<Int>): Bool {
    var last = array[0];
    for (i in 1...array.length) {
      if (last > array[i]) {
        return false;
      }
      last = array[i];
    }

    return true;
  }

}