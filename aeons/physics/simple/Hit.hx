package aeons.physics.simple;

import aeons.math.Vector2;

class Hit {
  public var position(default, null): Vector2;

  public var body(default, null): Body;

  public function new(position: Vector2, body: Body) {
    this.position = position;
    this.body = body;
  }
}