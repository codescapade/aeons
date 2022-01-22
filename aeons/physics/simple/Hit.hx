package aeons.physics.simple;

import aeons.math.Vector2;

// TODO: Rethink this implementation. Maybe use a pool.
class Hit {
  public var position(default, null): Vector2;

  public var body(default, null): Body;

  public function new(position: Vector2, body: Body) {
    this.position = position;
    this.body = body;
  }
}