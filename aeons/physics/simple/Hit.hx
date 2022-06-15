package aeons.physics.simple;

import aeons.math.Vector2;
import aeons.utils.Pool;

using aeons.math.AeMath;

class Hit {
  public var position(default, null) = new Vector2();

  public var body(default, null): Body;

  public var distance(default, null): Float;

  static var pool = new Pool(Hit);

  public static function get(x: Float, y: Float, originX: Float, originY: Float, body: Body): Hit {
    var hit = pool.get();
    hit.position.set(x, y);
    hit.body = body;
    hit.distance = Math.distance(originX, originY, x, y);

    return hit;
  }

  public function new() {}

  public function put() {
    body = null;
    pool.put(this);
  }
}
