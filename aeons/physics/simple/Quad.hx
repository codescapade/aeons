package aeons.physics.simple;

import aeons.math.Rect;
import aeons.math.Vector2;

/**
 * Quad class for the quadtree.
 */
class Quad {
  /**
   * The depth of the quad. Deeper is smaller.
   */
  var depth: Int;

  /**
   * The bodies that are in this quad.
   */
  var bodies: Array<Body> = [];

  /**
   * The bounds of this quad.
   */
  var bounds: Rect;

  /**
   * The quad child nodes.
   */
  var nodes: Array<Quad> = [];

  /**
   * Quadtree reference.
   */
  var tree: Quadtree;

  /**
   * Index array for getting multiple indexes.
   */
  var indexList: Array<Int> = [];

  /**
   * Constructor.
   * @param tree The quadtree reference.
   * @param depth The depth of this quad.
   * @param x The x position of the quad.
   * @param y The y position of the quad.
   * @param width The width of the quad.
   * @param height The height of the quad.
   */
  public function new(tree: Quadtree, depth: Int, x: Float, y: Float, width: Float, height: Float) {
    this.tree = tree;
    this.depth = depth;
    this.bounds = new Rect(x, y, width, height);
  }

  /**
   * Insert a body into the quad.
   * @param body The body to add.
   */
  public function insert(body: Body) {
    if (nodes.length > 0) {
      final index = getIndex(body.bounds);
      if (index == -1) {
        getIndexes(body.bounds, indexList);
        for (i in indexList) {
          nodes[i].insert(body);
        }
      } else {
        nodes[index].insert(body);
      }

      return;
    }

    bodies.push(body);

    if (bodies.length > tree.maxBodies && depth < tree.maxDepth) {
      split();

      while (bodies.length > 0) {
        final b = bodies.pop();
        final index = getIndex(b.bounds);
        if (index == -1) {
          getIndexes(b.bounds, indexList);
          for (i in indexList) {
            nodes[i].insert(b);
          }
        } else {
          nodes[index].insert(b);
        }
      }
    }
  }

  /**
   * Get all bodies that are near a body.
   * @param body The body to check.
   * @param list The list to store the bodies in.
   */
  public function getBodyList(body: Body, list: Array<Body>) {
    final index = getIndex(body.bounds);
    if (nodes.length > 0) {
      if (index == -1) {
        getIndexes(body.bounds, indexList);
        for (i in indexList) {
          nodes[i].getBodyList(body, list);
        }
      } else {
        nodes[index].getBodyList(body, list);
      }
    } else {
      for (b in bodies) {
        if (b != body && !list.contains(b)) {
          list.push(b);
        }
      }
    }
  }

  /**
   * Get a list of bodies that intersect a line.
   * @param p1 The start of the line.
   * @param p2 The end o} the line.
   * @param results The found hits.
   */
  public function getLineHitList(p1: Vector2, p2: Vector2, results: HitList) {
    if (nodes.length > 0) {
      getLineIndexes(p1, p2, indexList);
      for (i in indexList) {
        nodes[i].getLineHitList(p1, p2, results);
      }
    } else {
      for (b in bodies) {
        var hitPos = Vector2.get();
        if (b.bounds.intersectsLine(p1, p2, hitPos)) {
          results.insert(hitPos.x, hitPos.y, p1.x, p1.y, b);
        }
      }
    }
  }

  /**
   * Get the bounds of this quad and its children.
   * @param list The list to store the bounds in.
   */
  public function getQuadBounds(list: Array<Rect>) {
    for (node in nodes) {
      node.getQuadBounds(list);
    }
    list.push(bounds);
  }

  /**
   * Clear this quad.
   */
  public function clear() {
    while (bodies.length > 0) {
      bodies.pop();
    }

    while (nodes.length > 0) {
      final node = nodes.pop();
      node.clear();
      tree.putQuad(node);
    }
  }

  /**
   * Reset the quad with new values.
   * @param depth The depth of this quad.
   * @param x The x position of the quad.
   * @param y The y position of the quad.
   * @param width The width of the quad.
   * @param height The height of the quad.
   */
  public function reset(depth: Int, x: Float, y: Float, width: Float, height: Float) {
    this.depth = depth;
    bounds.x = x;
    bounds.y = y;
    bounds.width = width;
    bounds.height = height;
  }

  /**
   * Split this quad into 4 smaller quads.
   */
  function split() {
    final subWidth = bounds.width * 0.5;
    final subHeight = bounds.height * 0.5;
    final x = bounds.x;
    final y = bounds.y;
    final nextDepth = depth + 1;

    nodes.push(tree.getQuad(nextDepth, x, y, subWidth, subHeight));
    nodes.push(tree.getQuad(nextDepth, x + subWidth, y, subWidth, subHeight));
    nodes.push(tree.getQuad(nextDepth, x, y + subHeight, subWidth, subHeight));
    nodes.push(tree.getQuad(nextDepth, x + subWidth, y + subHeight, subWidth, subHeight));
  }

  /**
   * Get the quad index a rectangle falls in.
   * @param colliderBounds The rectangle bounds to check.
   */
  function getIndex(colliderBounds: Rect): Int {
    var index = -1;

    final middleX = bounds.x + bounds.width * 0.5;
    final middleY = bounds.y + bounds.height * 0.5;

    final top = colliderBounds.y + colliderBounds.height < middleY;
    final bottom = colliderBounds.y > middleY;
    final left = colliderBounds.x + colliderBounds.width < middleX;
    final right = colliderBounds.x > middleX;

    if (left) {
      if (top) {
        index = 0;
      } else if (bottom) {
        index = 2;
      }
    } else if (right) {
      if (top) {
        index = 1;
      } else if (bottom) {
        index = 3;
      }
    }

    return index;
  }

  /**
   * Find all quads a rectangle overlaps with.
   * @param colliderBounds The bounds to check.
   * @param list The list to store the quad indexes in.
   */
  function getIndexes(colliderBounds: Rect, list: Array<Int>) {
    while (list.length > 0) {
      list.pop();
    }

    for (i in 0...nodes.length) {
      final bounds = nodes[i].bounds;

      if (bounds.intersects(colliderBounds)) {
        list.push(i);
      }
    }
  }

  /**
   * Get all node indexes that contain a line.
   * @param p1 The start of the line.
   * @param p2 The end of the line.
   * @param list Result list node numbers.
   */
  function getLineIndexes(p1: Vector2, p2: Vector2, list: Array<Int>) {
    while (list.length > 0) {
      list.pop();
    }

    for (i in 0...nodes.length) {
      final bounds = nodes[i].bounds;

      if (bounds.intersectsLine(p1, p2) || (bounds.hasPoint(p1.x, p1.y) && bounds.hasPoint(p2.x, p2.y))) {
        list.push(i);
      }
    }
  }
}
