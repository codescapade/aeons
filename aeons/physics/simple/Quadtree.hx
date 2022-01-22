package aeons.physics.simple;

import aeons.math.Rect;
import aeons.math.Vector2;

/**
 * The quadtree class for broad phase collision detection.
 */
class Quadtree {
  /**
   * The maximum bodies that can be in a quad before it splits.
   */
  public var maxBodies: Int;

  /**
   * The maximum amount of times a quad can subdivide.
   */
  public var maxDepth: Int;

  /**
   * The root quad that is the size of the physics world.
   */
  var root: Quad;

  /**
   * Quad pool to reuse quads instead of creating new instances every time.
   */
  var pool: Array<Quad> = [];

  /**
   * The bounds of the quadtree.
   */
  var bounds: Rect;

  /**
   * Constructor.
   * @param x The x position of the world.
   * @param y The y position of the world.
   * @param width The width of the world.
   * @param height The height of the world.
   * @param maxBodies The maximum bodies that can be in a quad before it splits.
   * @param maxDepth The maximum amount of times a quad can subdivide.
   */
  public function new(x: Float, y: Float, width: Float, height: Float, maxBodies = 4, maxDepth = 6) {
    bounds = new Rect(x, y, width, height);
    this.maxBodies = maxBodies;
    this.maxDepth = maxDepth;
    root = new Quad(this, 1, x, y, width, height);
  }

  /**
   * Insert a body into the tree.
   * @param body The body to insert.
   */
  public function insert(body: Body) {
    root.insert(body);
  }

  /**
   * Get a list of bodies that might collide.
   * @param body The body to check for.
   * @param out The list of close bodies.
   */
  public function getBodyList(body: Body, ?out: Array<Body>): Array<Body> {
    if (out == null) {
      final list: Array<Body> = [];
      root.getBodyList(body, list);

      return list;
    }

    root.getBodyList(body, out);

    return out;
  }

  /**
   * Get a list of bodies that intersect with a line.
   * @param p1 The start position of the line.
   * @param p2 The end position of the line.
   * @param out Optional list to store the result in.
   * @return The result.
   */
  public function getLineHitList(p1: Vector2, p2: Vector2, ?out: Array<Hit>): Array<Hit> {
    if (out == null) {
      final list: Array<Hit> = [];
      root.getLineHitList(p1, p2, list);

      return list;
    }

    root.getLineHitList(p1, p2, out);

    return out;
  }

  /**
   * Get all quad bounds.
   * @param out The list to put the bounds in.
   */
  public function getTreeBounds(?out: Array<Rect>): Array<Rect> {
    if (out == null) {
      final list: Array<Rect> = [];
      root.getQuadBounds(list);

      return list;
    }

    root.getQuadBounds(out);

    return out;
  }

  /**
   * Clear the tree.
   */
  public function clear() {
    root.clear();
    root.reset(1, bounds.x, bounds.y, bounds.width, bounds.height);
  }

  /**
   * Update the tree bounds.
   * @param x The new x position.
   * @param y The new y position.
   * @param width The new width.
   * @param height The new height.
   */
  public function updateBounds(x: Float, y: Float, width: Float, height: Float) {
    bounds.set(x, y, width, height);
  }

  /**
   * Get a quad from the object pool.
   * @param depth The depth of this quad.
   * @param x The x position of the quad.
   * @param y The y position of the quad.
   * @param width The width of the quad.
   * @param height The height of the quad.
   */
  @:allow(aeons.physics.simple.Quad)
  function getQuad(depth: Int, x: Float, y: Float, width: Float, height: Float): Quad {
    if (pool.length > 0) {
      final quad = pool.pop();
      quad.reset(depth, x, y, width, height);

      return quad;
    }

    return new Quad(this, depth, x, y, width, height);
  }

  /**
   * Put a quad back into the pool.
   * @param quad The quad to put back.
   */
  @:allow(aeons.physics.simple.Quad)
  function putQuad(quad: Quad) {
    pool.push(quad);
  }
}