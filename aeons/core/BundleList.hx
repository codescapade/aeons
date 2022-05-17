package aeons.core;

import aeons.bundles.BundleBase;

import haxe.iterators.ArrayIterator;

/**
 * A BundleList holds an array of all bundles that a list of components matches.
 */
class BundleList<T:BundleBase> {
  /**
   * The list of bundles.
   */
  public final bundles: Array<T>;

  /**
   * The number of bundles in this list.
   */
  public var count(get, never): Int;

  /**
   *  Callback when a bundle gets added.
   */
  var bundleAdded: (T)->Void;

  /**
   *  Callback when a bundle gets removed.
   */
  var bundleRemoved: (T)->Void;

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
    bundles.push(bundle);

    if (bundleAdded != null) {
      bundleAdded(bundle);
    }
  }

  /**
   * Remove a bundle from the list. This is done automatically in a system.
   * @param entity The entity the bundle belongs to.
   */
  public function removeBundle(entity: Entity) {
    for (bundle in bundles) {
      if (bundle.entity == entity) {
        bundles.remove(bundle);

        if (bundleRemoved != null) {
          bundleRemoved(bundle);
        }
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
   * Add a callback function for when a bundle gets added.
   * @param callback The function to call.
   */
  public inline function onAdded(callback: (T)->Void) {
    bundleAdded = callback;
  }

  /**
   * Add a callback function for when a bundle gets removed.
   * @param callback The function to call.
   */
  public inline function onRemoved(callback: (T)->Void) {
    bundleRemoved = callback;
  }

  inline function get_count(): Int {
    return bundles.length;
  }
}
