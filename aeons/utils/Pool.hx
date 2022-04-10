package aeons.utils;

import haxe.ds.List;

/**
 * Pool is a generic object pool class that you can use to reuse objects. Objects need to be able to be instantiated
 * one or no parameters.
 */
class Pool<T> {
  /**
   * How many objects are currently in the pool.
   */
  public var count(get, never): Int;

  /**
   * The actual array of objects.
   */
  final pool: List<T> = new List<T>();

  /**
   * The type for this pool.
   */
  final classType: Class<T>;

  /**
   * Pool contructor.
   * @param type The class to use in the pool.
   */
  public function new(type: Class<T>) {
    classType = type;
  }

  /**
   * Get an object from the pool. If the pool is empty create a new instance.
   * TODO: Need to figure out how to do object pools with arguments better.
   * @return The object.
   */
  public function get(?options: Dynamic): T {
    if (pool.length > 0) {
      final item = pool.pop();

      return item;
    } else {
      if (options == null) {
        return Type.createInstance(classType, []);
      } else {
        return Type.createInstance(classType, [options]);
      }
    }
  }

  /**
   * Put an object back into the pool. Don't keep using the object after you put it back into the pool.
   * @param object The object to put back.
   */
  public function put(object: T) {
    if (object != null) {
      for (item in pool) {
        if (item == object) {
          return;
        }
      }

      pool.push(object);
    }
  }

  /**
   * Clear all objects out of the pool.
   */
  public function clear() {
    while (pool.length > 0) {
      pool.pop();
    }
  }

  /**
   * Count getter.
   * @return The amount of items in the pool.
   */
  inline function get_count(): Int {
    return pool.length;
  }
}
