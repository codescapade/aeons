package aeons.core;

import haxe.iterators.ArrayIterator;

/**
 * A BundleList holds an array of all bundles that a list of components matches.
 */
class BundleList<T: BundleBase> {
  /**
   * The list of bundles.
   */
  public final bundles: Array<T>;

  /**
   * The number of bundles in this list.
   */
  public var count(get, never): Int;

  /**
   * BundleList constructor.
   */
  public function new() {
    bundles = [];
  }

  /**
   * Add a bundle to the list. This is done automatically in a system.
   * @param bundle The bundle to add.
   */
  public function addBundle(bundle: T) {
    // Add a bundle to the start of the array.
    bundles.unshift(bundle);
  }

  /**
   * Remove a bundle from the list. This is done automatically in a system.
   * @param entity The entity the bundle belongs to.
   */
  public function removeBundle(entity: Entity) {
    for (bundle in bundles) {
      if (bundle.entity == entity) {
        bundles.remove(bundle);
        break;
      }
    }
  }

  /**
   * Check if a bundle for this entity already.
   * @param entity The entity to check.
   * @return True if a bundle already exists.
   */
  public function hasEntity(entity: Entity): Bool {
    for (bundle in bundles) {
      if (bundle.entity == entity) {
        return true;
      }
    }

    return false;
  }

  /**
   * Forward the list iterator so 'for in' can be used on the bundleList.
   * @return The bundles iterator.
   */
  public inline function iterator(): ArrayIterator<T> {
    return bundles.iterator();
  }

  /**
   * Get a bundle at a position in the list.
   * @param index The position in the list.
   * @return The bundle.
   */
  public inline function get(index: Int): T {
    return bundles[index];
  }

  /**
   * Return the number of bundles in this list.
   * @return The number of bundles.
   */
  inline function get_count(): Int {
    return bundles.length;
  }
}