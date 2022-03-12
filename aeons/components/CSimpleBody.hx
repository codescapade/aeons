package aeons.components;

import aeons.physics.simple.BodyType;
import aeons.physics.simple.Touching;
import aeons.core.Component;
import aeons.math.Rect;
import aeons.math.Vector2;
import aeons.physics.simple.Body;
import aeons.physics.simple.Collide;
import aeons.physics.simple.CollisionFilter;

/**
 * `CSimpleBody` is the body component for the simple physics system.
 */
class CSimpleBody extends Component {
  /**
   * The type of body. Defaults to dynamic.
   */
  public var type(get, set): BodyType;

  /**
   * Is this a trigger body. Trigger bodies don't collide with other bodies but can have overlap callbacks.
   */
  public var isTrigger(get, set): Bool;

  /**
   * The collider bounds.
   */
  public var bounds(get, null): Rect;

  /**
   * The body drag.
   */
  public var drag(get, null): Vector2;

  /**
   * The body velocity.
   */
  public var velocity(get, null): Vector2;

  /**
   * The maximum velocity. Set both position and negative maximum.
   */
  public var maxVelocity(get, never): Vector2;

  /**
   * The body acceleration. How fast it speeds up or slows down.
   */
  public var acceleration(get, never): Vector2;

  /**
   * The body offset from the transform position in pixels.
   */
  public var offset(get, null): Vector2;

  /**
   * The body collision group. To filter out collisions.
   */
  public var group(get, set): CollisionFilter;

  /**
   * The body collision mask. To filter out collisions.
   */
  public var mask(get, set): CollisionFilter;

  /**
   * The body bounce.
   */
  public var bounce(get, set): Float;

  /**
   * Is the body affected by gravity.
   */
  public var useGravity(get, set): Bool;

  /**
   * The sides of the body that are touching another body.
   */
  public var touching(get, never): Touching;

  /**
   * The sides of the body that were touching another body the last update.
   */
  public var wasTouching(get, never): Touching;

  /**
   * The sides the body will collide. Useful for one way platforms. Defaults to all sides.
   */
  public var canCollide(get, set): Collide;

  /**
   * User data is a field where you can add your own data. This can be used to access other parts
   */
  public var userData(get, set): Dynamic;

  /**
   * The tags on this body. Tags are used for interaction listeners.
   */
  public var tags(get, never): Array<String>;

  /**
   * The actual physics body.
   */
  @:allow(aeons.systems.SimplePhysicsSystem)
  var body: Body;

  /**
   * CSimpleBody constructor.
   * @param options The values you want to set.
   */
  public function new (?options: SimpleBodyOptions) {
    super();

    body = new Body();
    if (options != null) {
      if (options.type != null) type = options.type;
      if (options.isTrigger != null) isTrigger = options.isTrigger;
      if (options.width != null) bounds.width = options.width;
      if (options.height != null) bounds.height = options.height;
      if (options.drag != null) drag.set(options.drag.x, options.drag.y);
      if (options.velocity != null) velocity.set(options.velocity.x, options.velocity.y);
      if (options.maxVelocity != null) maxVelocity.set(options.maxVelocity.x, options.maxVelocity.y);
      if (options.acceleration != null) acceleration.set(options.acceleration.x, options.acceleration.y);
      if (options.offset != null) offset.set(options.offset.x, options.offset.y);
      if (options.group != null) group = options.group;
      if (options.mask != null) mask = options.mask;
      if (options.bounce != null) bounce = options.bounce;
      if (options.useGravity != null) useGravity = options.useGravity;
      if (options.canCollide != null) canCollide = options.canCollide;
      if (options.tags != null) {
        for (tag in options.tags) {
          tags.push(tag);
        }
      }
      if (options.userData != null) userData = options.userData;

    } else {
      type = DYNAMIC;
    }
  }

  /**
   * Set the collider size.
   * @param width The width of the collider in pixels.
   * @param height The height of the collider in pixels.
   */
  public inline function setSize(width: Float, height: Float) {
    body.bounds.width = width;
    body.bounds.height = height;
  }

  /**
   * Type getter.
   */
  inline function get_type(): BodyType {
    return body.type;
  }

  /**
   * Type setter.
   * @param value The new value.
   */
  inline function set_type(value: BodyType): BodyType {
    body.type = value;

    return value;
  }

  /**
   * Is trigger getter.
   */
  inline function get_isTrigger(): Bool {
    return body.isTrigger;
  }

  /**
   * Is trigger setter.
   * @param value The new value.
   */
  inline function set_isTrigger(value: Bool): Bool {
    body.isTrigger = value;

    return value;
  }

  /**
   * Bounds getter.
   */
  inline function get_bounds(): Rect {
    return body.bounds;
  }

  /**
   * Drag getter.
   */
  inline function get_drag(): Vector2 {
    return body.drag;
  }

  /**
   * Tags getter.
   */
  inline function get_tags(): Array<String> {
    return body.tags;
  }

  /**
   * Velocity getter.
   */
  inline function get_velocity(): Vector2 {
    return body.velocity;
  }

  /**
   * Max velocity getter.
   */
  inline function get_maxVelocity(): Vector2 {
    return body.maxVelocity;
  }

  /**
   * Acceleration getter.
   */
  inline function get_acceleration(): Vector2 {
    return body.acceleration;
  }

  /**
   * Offset getter
   */
  inline function get_offset(): Vector2 {
    return body.offset;
  }

  /**
   * Group getter.
   */
  inline function get_group(): CollisionFilter {
    return body.group;
  }

  /**
   * Group setter.
   * @param value The new value.
   */
  inline function set_group(value: CollisionFilter): CollisionFilter {
    body.group = value;

    return value;
  }

  /**
   * Mask getter.
   */
  inline function get_mask(): CollisionFilter {
    return body.mask;
  }

  /**
   * Mask setter.
   * @param value The new value. 
   */
  inline function set_mask(value: CollisionFilter): CollisionFilter {
    body.mask = value;

    return value;
  }

  /**
   * Bounce getter.
   */
  inline function get_bounce(): Float {
    return body.bounce;
  }

  /**
   * Bounce setter.
   * @param value The new value.
   */
  inline function set_bounce(value: Float): Float {
    body.bounce = value;

    return value;
  }

  /**
   * Use gravity getter.
   */
  inline function get_useGravity(): Bool {
    return body.useGravity;
  }

  /**
   * Use gravity setter.
   * @param value The new value.
   */
  inline function set_useGravity(value: Bool): Bool {
    body.useGravity = value;

    return value;
  }

  /**
   * Touching getter.
   */
  inline function get_touching(): Touching {
    return body.touching;
  }

  /**
   * Touching setter.
   * @param value The new value.
   */
  inline function set_touching(value: Touching): Touching {
    body.touching = value;

    return value;
  }

  /**
   * Was touching getter.
   */
  inline function get_wasTouching(): Touching {
    return body.wasTouching;
  }

  /**
   * Was touching setter.
   * @param value The new value.
   */
  inline function set_wasTouching(value: Touching): Touching {
    body.wasTouching = value;

    return value;
  }

  /**
   * Can collide getter.
   */
  inline function get_canCollide(): Collide {
    return body.canCollide;
  }

  /**
   * Can collide setter.
   * @param value The new value.
   */
  inline function set_canCollide(value: Collide) {
    body.canCollide = value;

    return body.canCollide;
  }

  /**
   * User data getter.
   */
  inline function get_userData(): Dynamic {
    return body.userData;
  }

  /**
   * User data setter.
   * @param value The new value.
   */
  inline function set_userData(value: Dynamic): Dynamic {
    body.userData = value;

    return value;
  }
}

/**
 * The values you can set in the `SimpleBody` init function.
 */
typedef SimpleBodyOptions = {
  /**
   * The body type.
   */
  var ?type: BodyType;

  /**
   * Is this body a trigger.
   */
  var ?isTrigger: Bool;

  /**
   * The body width.
   */
  var ?width: Float;

  /**
   * The body height.
   */
  var ?height: Float;

  /**
   * The drag force.
   */
  var ?drag: { x: Float, y: Float };

  /**
   * The start velocity.
   */
  var ?velocity: { x: Float, y: Float };

  /**
   * The x and y max velocity.
   */
  var ?maxVelocity: { x: Float, y: Float };

  /**
   * The x and y acceleration.
   */
  var ?acceleration: { x: Float, y: Float };

  /**
   * The offset from the center.
   */
  var ?offset: { x: Float, y: Float };

  /**
   * The collision group.
   */
  var ?group: CollisionFilter;

  /**
   * The collision mask.
   */
  var ?mask: CollisionFilter;

  /**
   * The bounce value. (0 to 1).
   */
  var ?bounce: Float;

  /**
   * Should the body be affected by gravity.
   */
  var ?useGravity: Bool;

  /**
   * Which side can collide.
   */
  var ?canCollide: Collide;

  /**
   * Tags for collision callbacks.
   */
  var ?tags: Array<String>;

  /**
   * The user data that can be accessed from the body in collision / trigger events.
   */
  var ?userData: Dynamic;
}