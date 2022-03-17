package aeons.systems;

import aeons.components.CTransform;
import aeons.core.Bundle;
import aeons.physics.simple.Hit;
import aeons.components.CSimpleBody;
import aeons.components.CSimpleTilemapCollider;
import aeons.core.Renderable;
import aeons.core.System;
import aeons.core.Updatable;
import aeons.graphics.Color;
import aeons.math.AeMath;
import aeons.math.Rect;
import aeons.math.Vector2;
import aeons.physics.simple.Body;
import aeons.physics.simple.Interaction;
import aeons.physics.simple.InteractionType;
import aeons.physics.simple.Physics;
import aeons.physics.simple.Quadtree;
import aeons.physics.simple.Touching;

/**
 * Simple aabb physics system.
 */
class SimplePhysicsSystem extends System implements Updatable {
  /**
   * The world gravity.
   */
  public var gravity(default, null) = new Vector2();

  /**
   * The bundles that are currently used by the system.
   */
  @:bundle
  var bundles: Bundle<CSimpleBody, CTransform>;

  /**
   * Tilemap collider list.
   */
  @:bundle
  var tilemaps: Bundle<CSimpleTilemapCollider>;

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
   * SimplePhysicsSystem Constructor.
   * @param options Initial setup options.
   */
  public function new(options: SimplePhysicsSystemOptions) {
    super();

    final x = options.worldX == null ? 0 : options.worldX;
    final y = options.worldY == null ? 0 : options.worldY;

    bounds = new Rect(x, y, options.worldWidth, options.worldHeight);
    tree = new Quadtree(x, y, options.worldWidth, options.worldHeight);

    if (options.gravity != null) {
      gravity.set(options.gravity.x, options.gravity.y);
    }
  }

  /**
   * Update called 60 times per second.
   * @param dt The time passed since the last update in seconds.
   */
  public function update(dt:Float) {
    tree.clear();
    for (tilemap in tilemaps) {
      final collider = tilemap.c_simple_tilemap_collider;
      if (!collider.active) {
        continue;
      }
      for (body in collider.bodies) {
        updatePastInteractions(body);
        tree.insert(body);
      }
    }

    for (bundle in bundles) {
      if (!bundle.entity.active || !bundle.c_simple_body.active || !bundle.c_transform.active) {
        continue;
      }

      final body = bundle.c_simple_body.body;
      updatePastInteractions(body);
      body.wasTouching = body.touching;
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
            body.velocity.x = AeMath.clamp(body.velocity.x, -body.maxVelocity.x, body.maxVelocity.x);
          }

          if (body.maxVelocity.y != 0) {
            body.velocity.y = AeMath.clamp(body.velocity.y, -body.maxVelocity.y, body.maxVelocity.y);
          }
        }
        body.bounds.x += body.velocity.x * dt;
        body.bounds.y += body.velocity.y * dt;
      }
      tree.insert(body);
    }

    // Check for collisions.
    for (bundle in bundles) {
      if (!bundle.entity.active || !bundle.c_simple_body.active || !bundle.c_transform.active) {
        continue;
      }
      final body = bundle.c_simple_body.body;
      while (treeList.length > 0) {
        treeList.pop();
      }
      tree.getBodyList(body, treeList);
      for (body2 in treeList) {
        checkCollision(body, body2);
      }
      updateBodyTransform(bundle);
    }

    // Check if any collisions ended this update.
    for (bundle in bundles) {
      if (!bundle.entity.active || !bundle.c_simple_body.active || !bundle.c_transform.active) {
        continue;
      }
      final body = bundle.c_simple_body.body;
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

  /**
   * Update the tree bounds.
   * @param x The new x position.
   * @param y The new y position.
   * @param width The new width.
   * @param height The new height.
   */
  public function updateBounds(x: Float, y: Float, width: Float, height: Float) {
    bounds.set(x, y, width, height);
    tree.updateBounds(x, y, width, height);
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
   * @param tag The tag to search for.
   * @param hits Optional list to store the result.
   * @return The result.
   */
  public function raycast(p1: Vector2, p2: Vector2, ?tags: Array<String>, ?hits: Array<Hit>): Array<Hit> {
    if (hits == null) {
      hits = [];
    }
    tree.getLineHitList(p1, p2, hits);

    if (hits.length > 0 && tags != null) {
      var total = hits.length - 1;
      var i = total;
      while (i >= 0) {
        var hit = hits[i];
        var found = false;
        for (tag in tags) {
          if (hit.body.tags.contains(tag)) {
            found = true;
            break;
          }
        }
        if (!found) {
          hits.remove(hit);
        }
        i--;
      }

      hits.sort((a: Hit, b: Hit) -> {
        var dist1 = Vector2.distance(p1, a.position);
        var dist2 = Vector2.distance(p1, b.position);

        return dist1 < dist2 ? -1 : 1;
      });
    }

    return hits;
  }

  /**
   * Check if a collision happened between 2 bodies.
   * @param body1 The first physics body.
   * @param body2 The second physics body.
   */
  function checkCollision(body1: Body, body2: Body) {
    if (body1.mask.contains(body2.group) && body2.mask.contains(body1.group) && Physics.intersects(body1, body2)) {
      if ((body1.type == DYNAMIC || (body1.type == DYNEMATIC && body2.type == STATIC)) && !body1.isTrigger &&
          !body2.isTrigger) {
        Physics.separate(body1, body2);
        if (body1.wasCollidingwith.indexOf(body2) == -1) {
          interactions.push(Interaction.get(COLLISION_START, body1, body2));
        } else {
          interactions.push(Interaction.get(COLLISION_STAY, body1, body2));
        }
        body1.collidingWith.push(body2);
      } else if (body1.isTrigger) {
        if (body1.wasTriggeredBy.indexOf(body2) == -1) {
          interactions.push(Interaction.get(TRIGGER_START, body1, body2));
        } else {
          interactions.push(Interaction.get(TRIGGER_STAY, body1, body2));
        }
        body1.triggeredBy.push(body2);
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
    final worldPos = bundle.c_transform.getWorldPosition();
    final body = bundle.c_simple_body.body;
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
    final body = bundle.c_simple_body.body;
    if (body.type == STATIC) return;
    final worldPos = Vector2.get(body.bounds.x + body.bounds.width * 0.5 - body.offset.x,
        body.bounds.y + body.bounds.height * 0.5 - body.offset.y);
    bundle.c_transform.setWorldPosition(worldPos);
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
   * The world gravity;
   */
  var ?gravity: {
    x: Float,
    y: Float
  };
}