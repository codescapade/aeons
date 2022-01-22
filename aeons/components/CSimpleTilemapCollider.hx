package aeons.components;

import aeons.core.Component;
import aeons.physics.simple.Body;
import aeons.physics.simple.CollisionFilter;
import aeons.physics.utils.TilemapCollision;

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
   * Transform component reference.
   */
  var transform: CTransform;

  /**
   * Tilemap component reference.
   */
  var tilemap: CTilemap;

  /**
   * The created tilemap physics bodies.
   */
  @:allow(aeons.systems.SimplePhysicsSystem)
  var bodies: Array<Body>;

  /**
   * The tags on this body. Tags are used for interaction listeners.
   */
  var tags: Array<String>;

  /**
   * Called when adding the component to an entity.
   */
  public function init(): CSimpleTilemapCollider{
    transform = getComponent(CTransform);
    tilemap = getComponent(CTilemap);
    bodies = [];
    tags = [];

    return this;
  }

  /**
   * Generate colliders from certain tiles.
   * @param indexes An array of indexes you want colliders on.
   */
  public function setCollisions(indexes: Array<Int>) {
    bodies = [];
    final rects = TilemapCollision.generateColliders(tilemap, transform, indexes);
    for (rect in rects) {
      var body = new Body();
      body.bounds.set(rect.x, rect.y, rect.width, rect.height);
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
   * This component requires ad transform and a tilemap component.
   */
  override function get_requiredComponents():Array<Class<Component>> {
    return [CTransform, CTilemap];
  }
}