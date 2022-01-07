package aeons.core;

import haxe.iterators.ArrayIterator;

class BundleList<T: BundleBase> {

  var bundles: Array<T>;

  public function new() {
    bundles = [];
  }

  public function addBundle(bundle: T) {
    bundles.push(bundle);
  }

  public function removeBundle(entity: Entity) {
    for (bundle in bundles) {
      if (bundle.entity == entity) {
        bundles.remove(bundle);
        break;
      }
    }
  }

  public function hasEntity(entity: Entity): Bool {
    for (bundle in bundles) {
      if (bundle.entity == entity) {
        return true;
      }
    }

    return false;
  }

  public inline function iterator(): ArrayIterator<T> {
    return bundles.iterator();
  }

  public inline function count(): Int {
    return bundles.length;
  }
}