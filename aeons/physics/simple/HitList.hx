package aeons.physics.simple;

class HitList {
  public var count(get, never): Int;

  var hits = new List<Hit>();

  public function new() {}

  public function insert(x: Float, y: Float, originX: Float, originY: Float, body: Body) {
    final hit = Hit.get(x, y, originX, originY, body);

    // Insert sorted by distance.
    if (hits.length > 0) {
      if (hits.length == 1) {
        final h = hits.first();
        if (hit.distance < h.distance) {
          hits.push(hit);
        } else {
          hits.add(hit);
        }
      } else {
        final temp = new List<Hit>();
        var inserted = false;
        while (hits.length > 0) {
          temp.add(hits.pop());
          if (!inserted && (hits.length == 0 || hits.first().distance > hit.distance)) {
            inserted = true;
            temp.add(hit);
          }
        }
        hits = temp;
      }
    } else {
      hits.add(hit);
    }
  }

  public inline function first(): Hit {
    return hits.first();
  }

  public inline function last(): Hit {
    return hits.last();
  }

  public inline function filterOnTags(tags: Array<String>) {
    hits = hits.filter((hit: Hit) -> {
      for (tag in tags) {
        if (hit.body.tags.contains(tag)) {
          return true;
        }
      }

      return false;
    });
  }

  public function remove(hit: Hit) {
    if (hits.remove(hit)) {
      hit.put();
    }
  }

  public function clear() {
    var hit: Hit = hits.pop();
    while (hit != null) {
      hit.put();
      hit = hits.pop();
    }
  }

  public inline function iterator() {
    return hits.iterator();
  }



  inline function get_count(): Int {
    return hits.length;
  }
}