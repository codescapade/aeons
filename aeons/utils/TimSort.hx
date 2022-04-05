package aeons.utils;

// Haxe port of https://github.com/mziccard/node-timsort

class TimSort<T> {
  /**
   * Default minimum size of a run.
   */
  static inline final DEFAULT_MIN_MERGE = 32;

  /**
   * Minimum ordered subsequece required to do galloping.
   */
  static inline final DEFAULT_MIN_GALLOPING = 7;

  /**
   * Default tmp storage length. Can increase depending on the size of the
   * smallest run to merge.
   */
  static inline final DEFAULT_TMP_STORAGE_LENGTH = 256;

  var array: Array<T>;

  var compare: T->T->Int;

  var minGallop: Int;

  var length: Int;

  var tmpStorageLength: Int;

  var stackLength: Int;

  var stackSize: Int;

  var runStart: Array<Int>;

  var runLength: Array<Int>;

  var tmp: Array<T>;

  /**
   * Sort an array in the range [lo, hi) using TimSort.
   *
   * @param array - The array to sort.
   * @param compare - Item comparison function.
   * @param lo - First element in the range (inclusive).
   * @param hi - Last element in the range.
   */
  public static function timSort<T>(array: Array<T>, compare: T->T->Int, ?lo: Int, ?hi: Int) {
    if (lo == null) {
      lo = 0;
    }
    if (hi == null) {
      hi = array.length;
    }

    var remaining = hi - lo;

    if (remaining < 2) {
      return;
    }

    var l = array.length;

    var runLength = 0;

    if (remaining < DEFAULT_MIN_MERGE) {
      runLength = makeAscendingRun(array, lo, hi, compare);
      binaryInsertionSort(array, lo, hi, lo + runLength, compare);
      return;
    }

    var ts = new TimSort(array, compare);

    var minRun = minRunLength(remaining);

    do {
      runLength = makeAscendingRun(array, lo, hi, compare);
      if (runLength < minRun) {
        var force = remaining;
        if (force > minRun) {
          force = minRun;
        }
        binaryInsertionSort(array, lo, lo + force, lo + runLength, compare);
        runLength = force;
      }

      ts.pushRun(lo, runLength);
      ts.mergeRuns();

      remaining -= runLength;
      lo += runLength;
    } while (remaining != 0);

    ts.forceMergeRuns();
  }

  /**
   * Compute minimum run length for TimSort
   *
   * @param n - The size of the array to sort.
   */
  static function minRunLength(n: Int): Int {
    var r = 0;
    while (n >= DEFAULT_MIN_MERGE) {
      r |= n & 1;
      n >>= 1;
    }

    return n + r;
  }

  /**
   * Counts the length of a monotonically ascending or strictly monotonically
   * descending sequence (run) starting at array[lo] in the range [lo, hi). If
   * the run is descending it is made ascending.
   *
   * @param array The array to reverse.
   * @param lo First element in the range (inclusive).
   * @param hi Last element in the range.
   * @param compare Item comparison function.
   * @return The length of the run.
   */
  static function makeAscendingRun<T>(array: Array<T>, lo: Int, hi: Int, compare:T->T->Int): Int {
    var runHi = lo + 1;

    if (runHi == hi) {
      return 1;
    }

    // Descending
    if (compare(array[runHi++], array[lo]) < 0) {
      while (runHi < hi && compare(array[runHi], array[runHi - 1]) < 0) {
        runHi++;
      }

      reverseRun(array, lo, runHi);
    // Ascending
    } else {
      while (runHi < hi && compare(array[runHi], array[runHi - 1]) >= 0) {
        runHi++;
      }
    }

    return runHi - lo;
  }

  /**
   * Find the position at which to insert a value in a sorted range. If the range
   * contains elements equal to the value the leftmost element index is returned
   * (for stability).
   *
   * @param value Value to insert.
   * @param array The array in which to insert value.
   * @param start First element in the range.
   * @param length Length of the range.
   * @param hint The index at which to begin the search.
   * @param compare Item comparison function.
   * @return The index where to insert value.
   */
  static function gallopLeft<T>(value: T, array: Array<T>, start: Int, length: Int, hint: Int,
      compare: T->T->Int): Int {
    var lastOffset = 0;
    var maxOffset = 0;
    var offset = 1;

    if (compare(value, array[start + hint]) > 0) {
      maxOffset = length - hint;

      while (offset < maxOffset && compare(value, array[start + hint + offset]) > 0) {
        lastOffset = offset;
        offset = (offset << 1) + 1;

        if (offset <= 0) {
          offset = maxOffset;
        }
      }

      if (offset > maxOffset) {
        offset = maxOffset;
      }

      // Make offsets relative to start
      lastOffset += hint;
      offset += hint;

    // value <= array[start + hint]
    } else {
      maxOffset = hint + 1;
      while (offset < maxOffset && compare(value, array[start + hint - offset]) <= 0) {
        lastOffset = offset;
        offset = (offset << 1) + 1;

        if (offset <= 0) {
          offset = maxOffset;
        }
      }
      if (offset > maxOffset) {
        offset = maxOffset;
      }

      // Make offsets relative to start
      var tmp = lastOffset;
      lastOffset = hint - offset;
      offset = hint - tmp;
    }

    /*
    * Now array[start+lastOffset] < value <= array[start+offset], so value
    * belongs somewhere in the range (start + lastOffset, start + offset]. Do a
    * binary search, with invariant array[start + lastOffset - 1] < value <=
    * array[start + offset].
    */
    lastOffset++;
    while (lastOffset < offset) {
      var m = lastOffset + (offset - lastOffset >>> 1);

      if (compare(value, array[start + m]) > 0) {
        lastOffset = m + 1;
      } else {
        offset = m;
      }
    }
    return offset;
  }

  /**
   * Find the position at which to insert a value in a sorted range. If the range
   * contains elements equal to the value the rightmost element index is returned
   * (for stability).
   *
   * @param value Value to insert.
   * @param array The array in which to insert value.
   * @param start First element in the range.
   * @param length Length of the range.
   * @param hint The index at which to begin the search.
   * @param compare Item comparison function.
   * @return The index where to insert value.
   */
  static function gallopRight<T>(value: T, array: Array<T>, start: Int, length: Int, hint: Int,
      compare: T->T->Int): Int {
    var lastOffset = 0;
    var maxOffset = 0;
    var offset = 1;

    if (compare(value, array[start + hint]) < 0) {
      maxOffset = hint + 1;

      while (offset < maxOffset && compare(value, array[start + hint - offset]) < 0) {
        lastOffset = offset;
        offset = (offset << 1) + 1;

        if (offset <= 0) {
          offset = maxOffset;
        }
      }

      if (offset > maxOffset) {
        offset = maxOffset;
      }

      // Make offsets relative to start
      var tmp = lastOffset;
      lastOffset = hint - offset;
      offset = hint - tmp;

    // value >= array[start + hint]
    } else {
      maxOffset = length - hint;

      while (offset < maxOffset && compare(value, array[start + hint + offset]) >= 0) {
        lastOffset = offset;
        offset = (offset << 1) + 1;

        if (offset <= 0) {
          offset = maxOffset;
        }
      }

      if (offset > maxOffset) {
        offset = maxOffset;
      }

      // Make offsets relative to start
      lastOffset += hint;
      offset += hint;
    }

    /*
    * Now array[start+lastOffset] < value <= array[start+offset], so value
    * belongs somewhere in the range (start + lastOffset, start + offset]. Do a
    * binary search, with invariant array[start + lastOffset - 1] < value <=
    * array[start + offset].
    */
    lastOffset++;

    while (lastOffset < offset) {
      var m = lastOffset + (offset - lastOffset >>> 1);

      if (compare(value, array[start + m]) < 0) {
        offset = m;
      } else {
        lastOffset = m + 1;
      }
    }

    return offset;
  }

  /**
   * Reverse an array in the range [lo, hi).
   *
   * @param array The array to reverse.
   * @param lo First element in the range (inclusive).
   * @param hi Last element in the range.
   */
  static function reverseRun<T>(array: Array<T>, lo: Int, hi: Int) {
    hi--;

    while (lo < hi) {
      var t = array[lo];
      array[lo++] = array[hi];
      array[hi--] = t;
    }
  }

  /**
   * Perform the binary sort of the array in the range [lo, hi) where start is
   * the first element possibly out of order.
   *
   * @param array The array to sort.
   * @param lo First element in the range (inclusive).
   * @param hi Last element in the range.
   * @param start First element possibly out of order.
   * @param compare Item comparison function.
   */
   static function binaryInsertionSort<T>(array: Array<T>, lo: Int, hi: Int, start: Int, compare: T->T->Int) {
    if (start == lo) {
      start++;
    }

    for (i in start...hi) {
      var pivot = array[i];

      // Ranges of the array where pivot belongs
      var left = lo;
      var right = i;

      /*
       * pivot >= array[i] for i in [lo, left)
       * pivot <  array[i] for i in  in [right, start)
       */
      while (left < right) {
        var mid = left + ((right - left) >>> 1);

        if (compare(pivot, array[mid]) < 0) {
          right = mid;
        } else {
          left = mid + 1;
        }
      }

      /*
       * Move elements right to make room for the pivot. If there are elements
       * equal to pivot, left points to the first slot after them: this is also
       * a reason for which TimSort is stable
       */
      var n = i - left;
      if (n == 3) {
        array[left + 3] = array[left + 2];
        array[left + 2] = array[left + 1];
        array[left + 1] = array[left];
      } else if (n == 2) {
        array[left + 2] = array[left + 1];
        array[left + 1] = array[left];
      } else if (n == 1) {
        array[left + 1] = array[left];
      } else {
        while (n > 0) {
          array[left + n] = array[left + n - 1];
          n--;
        }
      }

      array[left] = pivot;
    }
  }

  function new(array: Array<T>, compare: T->T->Int) {
    this.array = array;
    this.compare = compare;
    minGallop = DEFAULT_MIN_GALLOPING;
    length = array.length;
    stackSize = 0;
    tmpStorageLength = DEFAULT_TMP_STORAGE_LENGTH;

    if (length < 2 * DEFAULT_TMP_STORAGE_LENGTH) {
      tmpStorageLength = length >>> 2;
    }

    tmp = [];
    for (i in 0...tmpStorageLength) {
      tmp.push(null);
    }

    stackLength = length < 120 ? 5 : length < 1542 ? 10 : length < 119151 ? 19 : 40;

    runStart = [];
    runLength = [];
    for (i in 0... stackLength) {
      runStart.push(0);
      runLength.push(0);
    }
  }
  
  /**
   * Push a new run on TimSort's stack.
   *
   * @param runStart Start index of the run in the original array.
   * @param runLength Length of the run;
   */
  function pushRun(runStart: Int, runLength: Int) {
    this.runStart[stackSize] = runStart;
    this.runLength[stackSize] = runLength;
    stackSize += 1;
  }

  /**
   * Merge runs on TimSort's stack so that the following holds for all i:
   * 1) runLength[i - 3] > runLength[i - 2] + runLength[i - 1]
   * 2) runLength[i - 2] > runLength[i - 1]
   */
  function mergeRuns() {
    while (stackSize > 1) {
      var n = stackSize - 2;

      if (n >= 1 && runLength[n - 1] <= runLength[n] + runLength[n + 1] || n >= 2 &&
          runLength[n - 2] <= runLength[n] + runLength[n - 1]) {

        if (runLength[n - 1] < runLength[n + 1]) {
          n--;
        }
      } else if (runLength[n] > runLength[n + 1]) {
        break;
      }
      mergeAt(n);
    }
  }

  /**
   * Merge all runs on TimSort's stack until only one remains.
   */
  function forceMergeRuns() {
    while (stackSize > 1) {
      var n = stackSize - 2;

      if (n > 0 && runLength[n - 1] < runLength[n + 1]) {
        n--;
      }

      mergeAt(n);
    }
  }

  /**
   * Merge the runs on the stack at positions i and i+1. Must be always be called
   * with i=stackSize-2 or i=stackSize-3 (that is, we merge on top of the stack).
   *
   * @param i Index of the run to merge in TimSort's stack.
   */
  function mergeAt(i: Int) {
    var start1 = runStart[i];
    var length1 = runLength[i];
    var start2 = runStart[i + 1];
    var length2 = runLength[i + 1];

    runLength[i] = length1 + length2;

    if (i == stackSize - 3) {
      runStart[i + 1] = runStart[i + 2];
      runLength[i + 1] = runLength[i + 2];
    }

    stackSize--;

    /*
     * Find where the first element in the second run goes in run1. Previous
     * elements in run1 are already in place
     */
    var k = gallopRight(array[start2], array, start1, length1, 0, compare);
    start1 += k;
    length1 -= k;

    if (length1 == 0) {
      return;
    }

    /*
     * Find where the last element in the first run goes in run2. Next elements
     * in run2 are already in place
     */
    length2 = gallopLeft(array[start1 + length1 - 1], array, start2, length2, length2 - 1, compare);

    if (length2 == 0) {
      return;
    }

    /*
     * Merge remaining runs. A tmp array with length = min(length1, length2) is
     * used
     */
    if (length1 <= length2) {
      mergeLow(start1, length1, start2, length2);
    } else {
      mergeHigh(start1, length1, start2, length2);
    }
  }

  /**
   * Merge two adjacent runs in a stable way. The runs must be such that the
   * first element of run1 is bigger than the first element in run2 and the
   * last element of run1 is greater than all the elements in run2.
   * The method should be called when run1.length <= run2.length as it uses
   * TimSort temporary array to store run1. Use mergeHigh if run1.length >
   * run2.length.
   *
   * @param start1 First element in run1.
   * @param length1 Length of run1.
   * @param start2 First element in run2.
   * @param length2 Length of run2.
   */
  function mergeLow(start1: Int, length1: Int, start2: Int, length2: Int) {

    for (i in 0...length1) {
      tmp[i] = array[start1 + i];
    }

    var cursor1 = 0;
    var cursor2 = start2;
    var dest = start1;

    array[dest++] = array[cursor2++];

    length2--;
    if (length2 == 0) {
      for (i in 0...length1) {
        array[dest + i] = tmp[cursor1 + i];
      }
      return;
    }

    if (length1 == 1) {
      for (i in 0...length2) {
        array[dest + i] = array[cursor2 + i];
      }
      array[dest + length2] = tmp[cursor1];
      return;
    }

    var minGallop = this.minGallop;

    while (true) {
      var count1 = 0;
      var count2 = 0;
      var exit = false;

      do {
        if (compare(array[cursor2], tmp[cursor1]) < 0) {
          array[dest++] = array[cursor2++];
          count2++;
          count1 = 0;

          if (--length2 == 0) {
            exit = true;
            break;
          }
        } else {
          array[dest++] = tmp[cursor1++];
          count1++;
          count2 = 0;
          if (--length1 == 1) {
            exit = true;
            break;
          }
        }
      } while ((count1 | count2) < minGallop);

      if (exit) {
        break;
      }

      do {
        count1 = gallopRight(array[cursor2], tmp, cursor1, length1, 0, compare);

        if (count1 != 0) {
          for (i in 0...count1) {
            array[dest + i] = tmp[cursor1 + i];
          }

          dest += count1;
          cursor1 += count1;
          length1 -= count1;
          if (length1 <= 1) {
            exit = true;
            break;
          }
        }

        array[dest++] = array[cursor2++];

        if (--length2 == 0) {
          exit = true;
          break;
        }

        count2 = gallopLeft(tmp[cursor1], array, cursor2, length2, 0, compare);

        if (count2 != 0) {
          for (i in 0...count2) {
            array[dest + i] = array[cursor2 + i];
          }

          dest += count2;
          cursor2 += count2;
          length2 -= count2;

          if (length2 == 0) {
            exit = true;
            break;
          }
        }
        array[dest++] = tmp[cursor1++];

        if (--length1 == 1) {
          exit = true;
          break;
        }

        minGallop--;
      } while (count1 >= DEFAULT_MIN_GALLOPING || count2 >= DEFAULT_MIN_GALLOPING);

      if (exit) {
        break;
      }

      if (minGallop < 0) {
        minGallop = 0;
      }

      minGallop += 2;
    }

    this.minGallop = minGallop;

    if (minGallop < 1) {
      this.minGallop = 1;
    }

    if (length1 == 1) {
      for (i in 0...length2) {
        array[dest + i] = array[cursor2 + i];
      }
      array[dest + length2] = tmp[cursor1];
    } else if (length1 == 0) {
      throw 'mergeLow preconditions were not respected';
    } else {
      for (i in 0...length1) {
        array[dest + i] = tmp[cursor1 + i];
      }
    }
  }

  /**
   * Merge two adjacent runs in a stable way. The runs must be such that the
   * first element of run1 is bigger than the first element in run2 and the
   * last element of run1 is greater than all the elements in run2.
   * The method should be called when run1.length > run2.length as it uses
   * TimSort temporary array to store run2. Use mergeLow if run1.length <=
   * run2.length.
   *
   * @param start1 First element in run1.
   * @param length1 Length of run1.
   * @param start2 First element in run2.
   * @param length2 Length of run2.
   */
  function mergeHigh(start1: Int, length1: Int, start2: Int, length2: Int) {
    for (i in 0...length2) {
      tmp[i] = array[start2 + i];
    }

    var cursor1 = start1 + length1 - 1;
    var cursor2 = length2 - 1;
    var dest = start2 + length2 - 1;
    var customCursor = 0;
    var customDest = 0;

    array[dest--] = array[cursor1--];

    if (--length1 == 0) {
      customCursor = dest - (length2 - 1);

      for (i in 0...length2) {
        array[customCursor + i] = tmp[i];
      }

      return;
    }

    if (length2 == 1) {
      dest -= length1;
      cursor1 -= length1;
      customDest = dest + 1;
      customCursor = cursor1 + 1;

      var i = length - 1;
      while ( i >= 0) {
        array[customDest + i] = array[customCursor + i];
        i--;
      }

      array[dest] = tmp[cursor2];
      return;
    }

    var minGallop = this.minGallop;

    while (true) {
      var count1 = 0;
      var count2 = 0;
      var exit = false;

      do {
        if (compare(tmp[cursor2], array[cursor1]) < 0) {
          array[dest--] = array[cursor1--];
          count1++;
          count2 = 0;
          if (--length1 == 0) {
            exit = true;
            break;
          }
        } else {
          array[dest--] = tmp[cursor2--];
          count2++;
          count1 = 0;
          if (--length2 == 1) {
            exit = true;
            break;
          }
        }
      } while ((count1 | count2) < minGallop);

      if (exit) {
        break;
      }

      do {
        count1 = length1 - gallopRight(tmp[cursor2], array, start1, length1, length1 - 1, compare);

        if (count1 != 0) {
          dest -= count1;
          cursor1 -= count1;
          length1 -= count1;
          customDest = dest + 1;
          customCursor = cursor1 + 1;

          var i = count1 - 1;
          while (i >= 0) {
            array[customDest + i] = array[customCursor + i];
            i--;
          }

          if (length1 == 0) {
            exit = true;
            break;
          }
        }

        array[dest--] = tmp[cursor2--];

        if (--length2 == 1) {
          exit = true;
          break;
        }

        count2 = length2 - gallopLeft(array[cursor1], tmp, 0, length2, length2 - 1, compare);

        if (count2 != 0) {
          dest -= count2;
          cursor2 -= count2;
          length2 -= count2;
          customDest = dest + 1;
          customCursor = cursor2 + 1;

          for (i in 0...count2) {
            array[customDest + i] = tmp[customCursor + i];
          }

          if (length2 <= 1) {
            exit = true;
            break;
          }
        }

        array[dest--] = array[cursor1--];

        if (--length1 == 0) {
          exit = true;
          break;
        }

        minGallop--;
      } while (count1 >= DEFAULT_MIN_GALLOPING || count2 >= DEFAULT_MIN_GALLOPING);

      if (exit) {
        break;
      }

      if (minGallop < 0) {
        minGallop = 0;
      }

      minGallop += 2;
    }

    this.minGallop = minGallop;

    if (minGallop < 1) {
      this.minGallop = 1;
    }

    if (length2 == 1) {
      dest -= length1;
      cursor1 -= length1;
      customDest = dest + 1;
      customCursor = cursor1 + 1;

      var i = length1 - 1;
      while (i >= 0) {
        array[customDest + i] = array[customCursor + i];
        i--;
      }

      array[dest] = tmp[cursor2];
    } else if (length2 == 0) {
      throw 'mergeHigh preconditions were not respected';
    } else {
      customCursor = dest - (length2 - 1);
      for (i in 0...length2) {
        array[customCursor + i] = tmp[i];
      }
    }
  }
}