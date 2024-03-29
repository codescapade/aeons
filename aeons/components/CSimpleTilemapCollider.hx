package aeons.components;

import aeons.core.Component;
import aeons.math.Rect;
import aeons.physics.simple.Body;
import aeons.physics.simple.CollisionFilter;
import aeons.physics.utils.TilemapCollision;
#if use_ldtk
import aeons.tilemap.ldtk.LdtkLayer;
#end

/**
 * Tilemap collider component for simple physics.
 */
class CSimpleTilemapCollider extends Component {
  /**
   * The bodies collision group. To filter out collisions.
   */
  var group: CollisionFilter = GROUP_01;

  /**
   * The bodies collision mask. To filter out collisions
   */
  var mask: CollisionFilter = GROUP_01;

  /**
   * User data is a field where you can add your own data. This can be used to access other parts
   */
  var userData: Dynamic;

  /**
   * The created tilemap physics bodies.
   */
  @:allow(aeons.systems.SSimplePhysics)
  var bodies: Array<Body> = [];

  /**
   * The tags on this body. Tags are used for interaction listeners.
   */
  var tags: Array<String> = [];

  var tilemap: CTilemap;

  #if use_ldtk
  var layer: LdtkLayer;
  #end

  var collisionTileIds: Array<Int> = [];

  var worldX: Int;

  var worldY: Int;

  /**
   * Initialize the component.
   * @return This component.
   */
  public function create(): CSimpleTilemapCollider {
    return this;
  }

  /**
   * Generate colliders for a CTilemap component. 
   * @param tilemap The tilemap component to use.
   * @param worldX The x position of the tilemap in world pixels.
   * @param worldY The y position of the tilemap in world pixels.
   * @param collisionTileIds A list of tile ids that should get collision tiles. If the list is empty all tiles will
   * count as colliders.
   */
  public function setCollisionsFromCTilemap(tilemap: CTilemap, worldX: Int, worldY: Int,
      collisionTileIds: Array<Int>) {
    this.tilemap = tilemap;
    this.worldX = worldX;
    this.worldY = worldY;
    this.collisionTileIds = collisionTileIds;
    updateColliders();
  }

  #if use_ldtk
  /**
   * Generate colliders for a LDtk layer . 
   * @param layer The layer to use.
   * @param worldX The x position of the tilemap in world pixels.
   * @param worldY The y position of the tilemap in world pixels.
   * @param collisionTileIds A list of tile ids that should get collision tiles. If the list is empty all tiles will
   * count as colliders.
   */
  public function setCollisionsFromLdtkLayer(layer: LdtkLayer, worldX: Int, worldY: Int,
      collisionTileIds: Array<Int>) {
    this.layer = layer;
    this.worldX = worldX;
    this.worldY = worldY;
    this.collisionTileIds = collisionTileIds;
    updateColliders();
  }
  #end

  /**
   * Update the exisitng colliders. Can be used if you add / remove tiles from a tilemap.
   */
  public function updateColliders() {
    #if use_ldtk
    final colliders = TilemapCollision.generateCollidersFromLDtkLayer(layer, worldX, worldY, collisionTileIds);
    createBodiesFromColliders(colliders);
    #else
    final colliders = TilemapCollision.generateCollidersFromCTilemap(tilemap, worldX, worldY, collisionTileIds);
    createBodiesFromColliders(colliders);
    #end
  }

  /**
   * Add a collision tag for collision listeners.
   * @param tag The tag string to add.
   */
  public inline function addTag(tag: String) {
    tags.push(tag);
    for (body in bodies) {
      body.tags.push(tag);
    }
  }

  /**
   * Remove a collision tag.
   * @param tag The tag string to remove.
   */
  public inline function removeTag(tag: String) {
    tags.remove(tag);
    for (body in bodies) {
      body.tags.remove(tag);
    }
  }

  /**
   * Get a list of the current tags that are on the colliders.
   */
  public inline function getTags(): Array<String> {
    final tags: Array<String> = [];
    for (tag in tags) {
      tags.push(tag);
    }

    return tags;
  }

  /**
   * Get the current coLlision group.
   */
  public inline function getGroup(): CollisionFilter {
    return group;
  }

  /**
   * Set the collision group.
   * @param group The new value.
   */
  public inline function setGroup(group: CollisionFilter) {
    this.group = group;
    for (body in bodies) {
      body.group = group;
    }
  }

  /**
   * Get the current coLlision mask.
   */
  public inline function getMask(): CollisionFilter {
    return mask;
  }

  /**
   * Set the collision mask.
   * @param mask The new value.
   */
  public inline function setMask(mask: CollisionFilter) {
    this.mask = mask;
    for (body in bodies) {
      body.mask = mask;
    }
  }

  /**
   * Get the collider userData.
   */
  public inline function getUserData(): Dynamic {
    return userData;
  }

  /**
   * Set the collider userData.
   * @param data 
   */
  public inline function setUserdata(data: Dynamic) {
    userData = data;
    for (body in bodies) {
      body.userData = data;
    }
  }

  /**
   * Create collision bodies from a list of collider rectangles.
   * @param colliders The list of collider rectangles.
   */
  function createBodiesFromColliders(colliders: Array<Rect>) {
    bodies = [];
    for (collider in colliders) {
      var body = new Body();
      body.bounds.set(collider.x, collider.y, collider.width, collider.height);
      body.type = STATIC;
      body.group = group;
      body.mask = mask;
      body.userData = userData;
      for (tag in tags) {
        body.tags.push(tag);
      }
      bodies.push(body);
    }
  }
}
