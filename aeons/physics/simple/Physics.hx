package aeons.physics.simple;

/**
 * Physics calculations.
 */
// TODO: Resolve collision using previous frame position as well to minimize getting stuck
// on edges of colliders.
class Physics {
  static inline final OVERLAP_PADDING = 4;
  /**
   * Separate 2 bodies so they no longer overlap.
   * @param body1 The first body to separate.
   * @param body2 The second body to separate.
   */
  public static function separate(body1: Body, body2: Body): Bool {
    if (Math.abs(body1.velocity.x) > Math.abs(body1.velocity.y)) {
      return separateY(body1, body2) || separateX(body1, body2);
    } else {
      return separateX(body1, body2) || separateY(body1, body2);
    }
  }

  /**
   * Separate on the x axis.
   * @param body1 The first body to separate.
   * @param body2 The second body to separate.
   */
  static function separateX(body1: Body, body2: Body): Bool {
    final bounds1 = body1.bounds;
    final bounds2 = body2.bounds;

    var overlap = Math.min(bounds1.x + bounds1.width, bounds2.x + bounds2.width) - Math.max(bounds1.x, bounds2.x);

    var ov = bounds1.x > bounds2.x ? overlap : -overlap;
    if ((ov < 0 && bounds1.x + bounds1.width * 0.5 > bounds2.x + bounds2.width * 0.5) ||
      (ov > 0 && bounds1.x + bounds1.width * 0.5 < bounds2.x + bounds2.width * 0.5)) {
      return false;
    }
    var delta = Math.abs(bounds1.x - body1.lastX);

    // Ignore the overlap if it is way bigger than the amount moved.
    if (overlap > delta + OVERLAP_PADDING) {
      overlap = 0;
    }
    overlap = bounds1.x > bounds2.x ? overlap : -overlap;

    // If there is no overlap do nothing and return.
    if (overlap == 0) {
      return false;
    }

    if (overlap > 0) {
      // If the collision side should not collide do nothing and return.
      if (body1.velocity.x > 0 || !body1.canCollide.contains(Collide.LEFT) ||
          !body2.canCollide.contains(Collide.RIGHT)) {
        return false;
      }
      body1.touching.add(Touching.LEFT);
      body2.touching.add(Touching.RIGHT);
    } else if (overlap < 0) {
      // If the collision side should not collide do nothing and return.
      if (body1.velocity.x < 0 || !body1.canCollide.contains(Collide.RIGHT) ||
          !body2.canCollide.contains(Collide.LEFT)) {
        return false;
      }
      body1.touching.add(Touching.RIGHT);
      body2.touching.add(Touching.LEFT);
    }

    if (body2.type != DYNAMIC) {
      bounds1.x += overlap;
      body1.velocity.x = -body1.velocity.x * body1.bounce;
    } else {
      overlap *= 0.5;
      bounds1.x += overlap;
      bounds2.x -= overlap;

      var vel1 = body2.velocity.x * (body2.velocity.x > 0 ? 1 : -1);
      var vel2 = body1.velocity.x * (body1.velocity.x > 0 ? 1 : -1);
      final average = (vel1 + vel2) * 0.5;
      vel1 -= average;
      vel2 -= average;

      body1.velocity.x = average + vel1 * body1.bounce;
      body2.velocity.x = average + vel2 * body2.bounce;
    }

    return true;
  }

  /**
   * Separate on the y axis.
   * @param body1 The first body to separate.
   * @param body2 The second body to separate.
   */
  static function separateY(body1: Body, body2: Body): Bool {
    final bounds1 = body1.bounds;
    final bounds2 = body2.bounds;

    var overlap = Math.min(bounds1.y + bounds1.height, bounds2.y + bounds2.height) - Math.max(bounds1.y, bounds2.y);

    var ov = bounds1.y > bounds2.y ? overlap : -overlap;
    if ((ov < 0 && bounds1.y + bounds1.height * 0.5 > bounds2.y + bounds2.height * 0.5) ||
      (ov > 0 && bounds1.y + bounds1.height * 0.5 < bounds2.y + bounds2.height * 0.5)) {
      return false;
    }

    var delta = bounds1.y - body1.lastY;

    // Ignore the overlap if it is way bigger than the amount moved.
    if (overlap > Math.abs(delta) + OVERLAP_PADDING) {
      overlap = 0;
    }
    overlap = bounds1.y > bounds2.y ? overlap : -overlap;

    // If there is no overlap do nothing and return.
    if (overlap == 0) {
      return false;
    }

    if (overlap > 0) {
      // If the collision side should not collide do nothing and return.
      if (body1.velocity.y > 0 || !body1.canCollide.contains(Collide.TOP) ||
          !body2.canCollide.contains(Collide.BOTTOM)) {
        return false;
      }
      body1.touching.add(Touching.TOP);
      body2.touching.add(Touching.BOTTOM);
    } else {
      // If the collision side should not collide do nothing and return.
      if (body1.velocity.y < 0 || !body1.canCollide.contains(Collide.BOTTOM) ||
          !body2.canCollide.contains(Collide.TOP)) {
        return false;
      }
      body1.touching.add(Touching.BOTTOM);
      body2.touching.add(Touching.TOP);
    }

    if (body2.type != DYNAMIC) {
      bounds1.y += overlap;
      body1.velocity.y = -body1.velocity.y * body1.bounce;
    } else {
      overlap *= 0.5;
      bounds1.y += overlap;
      bounds2.y -= overlap;

      var vel1 = body2.velocity.y * (body2.velocity.y > 0 ? 1 : -1);
      var vel2 = body1.velocity.y * (body1.velocity.y > 0 ? 1 : -1);
      final average = (vel1 + vel2) * 0.5;
      vel1 -= average;
      vel2 -= average;

      body1.velocity.y = average + vel1 * body1.bounce;
      body2.velocity.y = average + vel2 * body2.bounce;
    }

    return true;
  }

  /** 
   * Check if 2 bodies intersect.
   * @param body1 The first body to check.
   * @param body2 The second body to check.
   */
  public static function intersects(body1: Body, body2: Body): Bool {
    return body1.bounds.intersects(body2.bounds);
  }
}