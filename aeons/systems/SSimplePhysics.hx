package aeons.systems;

import aeons.bundles.Bundle;
import aeons.components.CSimpleBody;
import aeons.components.CSimpleTilemapCollider;
import aeons.components.CTransform;
import aeons.core.DebugRenderable;
import aeons.core.System;
import aeons.core.Updatable;
import aeons.graphics.Color;
import aeons.graphics.RenderTarget;
import aeons.math.Rect;
import aeons.math.Vector2;
import aeons.physics.simple.Body;
import aeons.physics.simple.HitList;
import aeons.physics.simple.Interaction;
import aeons.physics.simple.InteractionType;
import aeons.physics.simple.Physics;
import aeons.physics.simple.Quadtree;
import aeons.physics.simple.Touching;

using aeons.math.AeMath;

/**
 * Simple aabb physics system.
 */
class SSimplePhysics extends System implements Updatable implements DebugRenderable {
  /**
   * Should this system be show in debug draw.
   */
  public var debugDrawEnabled = true;

  /**
   * Show the quad tree in the debug draw.
   */
  public var showQuadTreeDebug = false;

  /**
   * The world gravity.
   */
  public var gravity(default, null) = new Vector2();

  /**
   * The x position in pixels where the physics world starts.
   */
  public var worldX(get, set): Float;

  /**
   * The y position in pixels where the physics world starts.
   */
  public var worldY(get, set): Float;

  /**
   * The width of the physics world in pixels.
   */
  public var worldWidth(get, set): Float;

  /**
   * The height of the physics world in pixels.
   */
  public var worldHeight(get, set): Float;

  /**
   * The bundles that are currently used by the system.
   */
  @:bundle
  var bundles: Bundle<CSimpleBody, CTransform>;

  /**
   * Tilemap collider list.
   */
  @:bundle
  var tilemapBundles: Bundle<CSimpleTilemapCollider>;

  /**
   * The entity ids currently used by the system.
   */
  final ids: Array<Int> = [];

  /**
   * List to put bodies in that are close. Te reuse.
   */
  final treeList: Array<Body> = [];

  /**
   * Collision trigger event listeners.
   */
  final triggerStartListeners = new Map<String, Map<String, Array<Body->Body->Void>>>();

  final triggerStayListeners = new Map<String, Map<String, Array<Body->Body->Void>>>();
  final triggerEndListeners = new Map<String, Map<String, Array<Body->Body->Void>>>();

  /**
   * Collision event listeners.
   */
  final collisionStartListeners = new Map<String, Map<String, Array<Body->Body->Void>>>();

  final collisionStayListeners = new Map<String, Map<String, Array<Body->Body->Void>>>();
  final collisionEndListeners = new Map<String, Map<String, Array<Body->Body->Void>>>();

  /**
   * Debug bounds color.
   */
  final boundsColor = Color.fromBytes(100, 100, 100, 255);

  /**
   * Debug body color.
   */
  final bodyColor = Color.fromBytes(0, 120, 200, 255);

  /**
   * Static body debug color.
   */
  final staticBodyColor = Color.fromBytes(0, 200, 0, 255);

  /**
   * Raycast color when it doesn't hit anything.
   */
  final rayColor = Color.fromBytes(255, 127, 0, 255);

  /**
   * Raycast color when it hits something.
   */
  final rayHitColor = Color.fromBytes(255, 255, 0, 255);

  /**
   * Interactions that happened this update.
   */
  final interactions: Array<Interaction> = [];

  /**
   * Collision tree.
   */
  var tree: Quadtree;

  /**
   * World bounds.
   */
  var bounds: Rect;

  /**
   * The number of physics iterations per step.
   */
  var iterations = 8;

  #if debug
  var debugRays: Array<RayDraw> = [];
  #end

  /**
   * Initialize the component.
   * @param options Initial setup options.
   * @return This component.
   */
  public function create(options: SimplePhysicsSystemOptions): SSimplePhysics {
    final x = options.worldX == null ? 0 : options.worldX;
    final y = options.worldY == null ? 0 : options.worldY;

    bounds = new Rect(x, y, options.worldWidth, options.worldHeight);
    tree = new Quadtree(x, y, options.worldWidth, options.worldHeight);

    if (options.gravity != null) {
      gravity.set(options.gravity.x, options.gravity.y);
    }

    if (options.iterations != null) {
      iterations = options.iterations;
    }

    return this;
  }

  /**
   * Update called 60 times per second.
   * @param dt The time passed since the last update in seconds.
   */
  public function update(dt: Float) {
    #if debug
    debugRays = [];
    #end

    tree.clear();
    for (tilemap in tilemapBundles) {
      final collider = tilemap.cSimpleTilemapCollider;
      if (!collider.active) {
        continue;
      }
      for (body in collider.bodies) {
        updatePastInteractions(body);
        tree.insert(body);
      }
    }

    for (bundle in bundles) {
      if (!bundle.entity.active || !bundle.cSimpleBody.active || !bundle.cTransform.active) {
        continue;
      }

      final body = bundle.cSimpleBody.body;
      updatePastInteractions(body);
      body.touchingPrevious = body.touching;
      body.touching = Touching.NONE;
      updateBodyBounds(bundle);

      // Body is outside of the physics bounds. Don't do anything with it.
      if (!bounds.intersects(body.bounds)) {
        continue;
      }

      // Update velocity.
      if (body.type != STATIC) {
        if (body.type == DYNAMIC) {
          if (body.useGravity) {
            body.velocity.x += body.acceleration.x + gravity.x * dt;
            body.velocity.y += body.acceleration.y + gravity.y * dt;
          }

          if (body.velocity.x > 0) {
            body.velocity.x -= body.drag.x;
          } else if (body.velocity.x < 0) {
            body.velocity.x += body.drag.x;
          }

          if (body.velocity.y > 0) {
            body.velocity.y -= body.drag.y;
          } else if (body.velocity.y < 0) {
            body.velocity.y -= body.drag.y;
          }

          if (body.maxVelocity.x != 0) {
            body.velocity.x = Math.clamp(body.velocity.x, -body.maxVelocity.x, body.maxVelocity.x);
          }

          if (body.maxVelocity.y != 0) {
            body.velocity.y = Math.clamp(body.velocity.y, -body.maxVelocity.y, body.maxVelocity.y);
          }
        }
        body.bounds.x += body.velocity.x * dt;
        body.bounds.y += body.velocity.y * dt;
      }
      tree.insert(body);
    }

    // Check for collisions.
    for (i in 0...iterations) {
      for (bundle in bundles) {
        if (!bundle.entity.active || !bundle.cSimpleBody.active || !bundle.cTransform.active) {
          continue;
        }
        final body = bundle.cSimpleBody.body;
        while (treeList.length > 0) {
          treeList.pop();
        }
        tree.getBodyList(body, treeList);
        for (body2 in treeList) {
          checkCollision(body, body2);
        }
        updateBodyTransform(bundle);
      }
    }

    // Check if any collisions ended this update.
    for (bundle in bundles) {
      if (!bundle.entity.active || !bundle.cSimpleBody.active || !bundle.cTransform.active) {
        continue;
      }
      final body = bundle.cSimpleBody.body;
      for (b in body.wasCollidingwith) {
        if (body.collidingWith.indexOf(b) == -1) {
          interactions.push(Interaction.get(COLLISION_END, body, b));
        }
      }
      for (b in body.wasTriggeredBy) {
        if (body.triggeredBy.indexOf(b) == -1) {
          interactions.push(Interaction.get(TRIGGER_END, body, b));
        }
      }
    }

    // Send all interaction events for this update.
    while (interactions.length > 0) {
      final interaction = interactions.pop();
      dispatchInteraction(interaction);
      interaction.put();
    }
  }

  public function debugRender(target: RenderTarget) {
    if (showQuadTreeDebug) {
      target.drawRect(bounds.x, bounds.y, bounds.width, bounds.height, bodyColor, 2);

      final quads = tree.getTreeBounds();
      for (quad in quads) {
        target.drawRect(quad.x, quad.y, quad.width, quad.height, boundsColor, 2);
      }
    }

    for (tilemap in tilemapBundles) {
      for (body in tilemap.cSimpleTilemapCollider.bodies) {
        if (!tilemap.cSimpleTilemapCollider.active) {
          continue;
        }

        final bounds = body.bounds;
        target.drawRect(bounds.x, bounds.y, bounds.width, bounds.height, staticBodyColor, 2);
      }
    }

    for (bundle in bundles) {
      if (!bundle.cSimpleBody.active) {
        continue;
      }

      final body = bundle.cSimpleBody.body;
      final bounds = body.bounds;
      if (body.type == STATIC) {
        target.drawRect(bounds.x, bounds.y, bounds.width, bounds.height, staticBodyColor, 2);
      } else {
        target.drawRect(bounds.x, bounds.y, bounds.width, bounds.height, bodyColor, 2);
      }
    }

    #if debug
    for (ray in debugRays) {
      if (ray.hit) {
        target.drawLine(ray.x1, ray.y1, ray.x2, ray.y2, rayHitColor);
      } else {
        target.drawLine(ray.x1, ray.y1, ray.x2, ray.y2, rayColor);
      }
    }
    #end
  }

  /**
   * Update the world bounds.
   * @param x The new x position in pixels.
   * @param y The new y position in pixels.
   * @param width The new width in pixels.
   * @param height The new height in pixels.
   */
  public function updateBounds(x: Float, y: Float, width: Float, height: Float) {
    bounds.set(x, y, width, height);
    tree.updateBounds(x, y, width, height);
  }

  /**
   * Update the world position.
   * @param x The new x position in pixels.
   * @param y The new y position in pixels.
   */
  public function updateWorldPosition(x: Float, y: Float) {
    bounds.x = x;
    bounds.y = y;
    tree.updatePosition(x, y);
  }

  /**
   * Add an interaction listener.
   * @param type The type of interaction.
   * @param tag1 The tag that has to be on the first physics body.
   * @param tag2 The tag that has to be on the second physics body.
   * @param callback The function to call when an interaction happens.
   */
  public function addInteractionListener(type: InteractionType, tag1: String, tag2: String,
      callback: Body->Body->Void) {
    var list = null;

    switch (type) {
      case TRIGGER_START:
        list = triggerStartListeners;

      case TRIGGER_STAY:
        list = triggerStayListeners;

      case TRIGGER_END:
        list = triggerEndListeners;

      case COLLISION_START:
        list = collisionStartListeners;

      case COLLISION_STAY:
        list = collisionStayListeners;

      case COLLISION_END:
        list = collisionEndListeners;
    }

    if (list != null) {
      if (list[tag1] == null) {
        list[tag1] = new Map<String, Array<Body->Body->Void>>();
        list[tag1][tag2] = [callback];
      } else if (list[tag1][tag2] == null) {
        list[tag1][tag2] = [callback];
      } else if (list[tag1][tag2].indexOf(callback) == -1) {
        list[tag1][tag2].push(callback);
      }
    }
  }

  /**
   * Remove an interaction listener.
   * @param type The type of interaction.
   * @param tag1 The tag that has to be on the first physics body.
   * @param tag2 The tag that has to be on the second physics body.
   * @param callback The function to call when an interaction happens.
   */
  public function removeInteractionListener(type: InteractionType, tag1: String, tag2: String,
      callback: Body->Body->Void) {
    var listeners = null;

    switch (type) {
      case TRIGGER_START:
        listeners = triggerStartListeners;

      case TRIGGER_STAY:
        listeners = triggerStayListeners;

      case TRIGGER_END:
        listeners = triggerEndListeners;

      case COLLISION_START:
        listeners = collisionStartListeners;

      case COLLISION_STAY:
        listeners = collisionStayListeners;

      case COLLISION_END:
        listeners = collisionEndListeners;
    }

    if (listeners != null) {
      if (listeners[tag1] != null && listeners[tag2] != null) {
        listeners[tag1][tag2].remove(callback);
      }
    }
  }

  /**
   * Raycast to find intersecting bodies.
   * @param p1 The start of the line.
   * @param p2 The end of the line.
   * @param tags The list of tags to search for. If null it returns all hits.
   * @param out Optional list to store the result.
   * @return The list of hits.
   */
  public function raycast(p1: Vector2, p2: Vector2, ?tags: Array<String>, ?out: HitList): HitList {
    out = tree.getLineHitList(p1, p2, out);

    #if debug
    var debugRay: RayDraw = {
      x1: p1.x,
      y1: p1.y,
      x2: p2.x,
      y2: p2.y,
      hit: false
    };
    #end

    if (out.count > 0 && tags != null) {
      out.filterOnTags(tags);
    }

    #if debug
    if (out.count > 0) {
      debugRay.hit = true;
    }
    debugRays.push(debugRay);
    #end

    return out;
  }

  /**
   * Check if a collision happened between 2 bodies.
   * @param body1 The first physics body.
   * @param body2 The second physics body.
   */
  function checkCollision(body1: Body, body2: Body) {
    if (body1.mask.contains(body2.group) && body2.mask.contains(body1.group) && Physics.intersects(body1, body2)) {
      if ((body1.type == DYNAMIC || (body1.type == DYNEMATIC && body2.type == STATIC)) && !body1.isTrigger
        && !body2.isTrigger) {
        Physics.separate(body1, body2);
        if (body1.wasCollidingwith.indexOf(body2) == -1) {
          if (!hasInteraction(COLLISION_START, body1, body2)) {
            interactions.push(Interaction.get(COLLISION_START, body1, body2));
          }
        } else {
          if (!hasInteraction(COLLISION_STAY, body1, body2)) {
            interactions.push(Interaction.get(COLLISION_STAY, body1, body2));
          }
        }
        body1.collidingWith.push(body2);
      } else if (body1.isTrigger && !body2.isTrigger) {
        if (body1.wasTriggeredBy.indexOf(body2) == -1) {
          if (!hasInteraction(TRIGGER_START, body1, body2)) {
            interactions.push(Interaction.get(TRIGGER_START, body1, body2));
          }
        } else {
          if (!hasInteraction(TRIGGER_STAY, body1, body2)) {
            interactions.push(Interaction.get(TRIGGER_STAY, body1, body2));
          }
        }
        body1.triggeredBy.push(body2);
      } else if (body2.isTrigger && !body1.isTrigger) {
        if (body2.wasTriggeredBy.indexOf(body1) == -1) {
          if (!hasInteraction(TRIGGER_START, body1, body2)) {
            interactions.push(Interaction.get(TRIGGER_START, body1, body2));
          }
        } else {
          if (!hasInteraction(TRIGGER_STAY, body1, body2)) {
            interactions.push(Interaction.get(TRIGGER_STAY, body1, body2));
          }
        }
        body2.triggeredBy.push(body1);
      }
    }
  }

  /**
   * Dispatch an interaction event to the listeners.
   * @param interaction The interaction to dispatch.
   */
  function dispatchInteraction(interaction: Interaction) {
    for (tag1 in interaction.body1.tags) {
      for (tag2 in interaction.body2.tags) {
        var listeners = null;
        switch (interaction.type) {
          case TRIGGER_START:
            listeners = triggerStartListeners;

          case TRIGGER_STAY:
            listeners = triggerStayListeners;

          case TRIGGER_END:
            listeners = triggerEndListeners;

          case COLLISION_START:
            listeners = collisionStartListeners;

          case COLLISION_STAY:
            listeners = collisionStayListeners;

          case COLLISION_END:
            listeners = collisionEndListeners;
        }

        if (listeners[tag1] != null && listeners[tag1][tag2] != null) {
          var list = listeners[tag1][tag2];
          for (callback in list) {
            callback(interaction.body1, interaction.body2);
          }
        }
      }
    }
  }

  /**
   * Update the physics bounds to the transform world position.
   * @param bundle The bundle to update.
   */
  function updateBodyBounds(bundle: aeons.bundles.BundleCSimpleBodyCTransform) {
    final worldPos = bundle.cTransform.getWorldPosition();
    final body = bundle.cSimpleBody.body;
    body.bounds.x = worldPos.x - body.bounds.width * 0.5 + body.offset.x;
    body.bounds.y = worldPos.y - body.bounds.height * 0.5 + body.offset.y;

    //  Update last body position.
    body.lastX = body.bounds.x;
    body.lastY = body.bounds.y;
    worldPos.put();
  }

  /**
   * After the physics update update the transform position from the bounds.
   * @param bundle 
   */
  function updateBodyTransform(bundle: aeons.bundles.BundleCSimpleBodyCTransform) {
    final body = bundle.cSimpleBody.body;
    if (body.type == STATIC) {
      return;
    }
    final worldPos = Vector2.get(body.bounds.x + body.bounds.width * 0.5 - body.offset.x,
      body.bounds.y + body.bounds.height * 0.5 - body.offset.y);
    bundle.cTransform.setWorldPosition(worldPos);
    worldPos.put();
  }

  /**
   * Move the interactions from last update to the was colliding with and was triggered by lists.
   * @param body 
   */
  function updatePastInteractions(body: Body) {
    // Remove old colliding with.
    while (body.wasCollidingwith.length > 0) {
      body.wasCollidingwith.pop();
    }

    // Remove old triggered by.
    while (body.wasTriggeredBy.length > 0) {
      body.wasTriggeredBy.pop();
    }

    // Move last update colliding with to wasCollidingWith.
    while (body.collidingWith.length > 0) {
      body.wasCollidingwith.push(body.collidingWith.pop());
    }

    // Move lst update triggered by to wasTriggeredBy.
    while (body.triggeredBy.length > 0) {
      body.wasTriggeredBy.push(body.triggeredBy.pop());
    }
  }

  /**
   * Check if an interaction is already in the list.
   * @param type The interaction type.
   * @param body1 The first body.
   * @param body2 The second body.
   * @return True if an interaction like this is in the list.
   */
  function hasInteraction(type: InteractionType, body1: Body, body2: Body): Bool {
    for (interaction in interactions) {
      if (interaction.type == type && interaction.body1 == body1 && interaction.body2 == body2) {
        return true;
      }
    }

    return false;
  }

  inline function get_worldX(): Float {
    return bounds.x;
  }

  inline function set_worldX(value: Float): Float {
    bounds.x = value;
    tree.updatePosition(bounds.x, bounds.y);

    return value;
  }

  inline function get_worldY(): Float {
    return bounds.y;
  }

  inline function set_worldY(value: Float): Float {
    bounds.y = value;
    tree.updatePosition(bounds.x, bounds.y);

    return value;
  }

  inline function get_worldWidth(): Float {
    return bounds.width;
  }

  inline function set_worldWidth(value: Float): Float {
    bounds.width = value;
    tree.updateBounds(bounds.x, bounds.y, bounds.width, bounds.height);

    return value;
  }

  inline function get_worldHeight(): Float {
    return bounds.height;
  }

  inline function set_worldHeight(value: Float): Float {
    bounds.height = value;
    tree.updateBounds(bounds.x, bounds.y, bounds.width, bounds.height);

    return value;
  }
}

/**
 * Options when initializing the system.
 */
typedef SimplePhysicsSystemOptions = {
  /**
   * The x position of the top left of the physics world.
   */
  var ?worldX: Float;

  /**
   * The y position of the top left of the physics world.
   */
  var ?worldY: Float;

  /**
   * The width of the physics world in pixels.
   */
  var worldWidth: Float;

  /**
   * The height of the physics world in pixels.
   */
  var worldHeight: Float;

  /**
   * The number of physics iterations per step. Default is 8.
   */
  var ?iterations: Int;

  /**
   * The world gravity;
   */
  var ?gravity: {
    x: Float,
    y: Float
  };
}

#if debug
@:structInit
class RayDraw {
  public var x1: Float;

  public var y1: Float;

  public var x2: Float;

  public var y2: Float;

  public var hit: Bool;
}
#end
