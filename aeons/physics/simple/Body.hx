package aeons.physics.simple;

import aeons.components.CSimpleBody;
import aeons.math.Rect;
import aeons.math.Vector2;

/**
 * Body class for the simple physics system.
 */
class Body {
  /**
   * The type of body. (dynamic, kinematic, static).
   */
  public var type: BodyType = DYNAMIC;

  /**
   * The world x position of the center of the body in pixels.
   */
  public var x(get, never): Float;

  /**
   * The world y position of the center of the body in pixels.
   */
  public var y(get, never): Float;

  /**
   * The bounds of the body.
   */
  public var bounds(default, null) = new Rect();

  /**
   * the drag on the body.
   */
  public var drag(default, null) = new Vector2();

  /**
   * Tags for collision callbacks.
   */
  public var tags(default, null): Array<String> = [];

  /**
   * The body velocity.
   */
  public var velocity(default, null) = new Vector2();

  /**
   * The maximum velocity. Set both positive and negative maximum.
   */
  public var maxVelocity(default, null) = new Vector2();

  /**
   * The body acceleration. How fast it speeds up or slows down.
   */
  public var acceleration(default, null) = new Vector2();

  /**
   * The body offset from the transform position in pixels.
   */
  public var offset(default, null) = new Vector2();

  /**
   * The component this body belongs to.
   */
  public var component(default, null): CSimpleBody;

  /**
   * Collision group for this body.
   */
  public var group: CollisionFilter = GROUP_01;

  /**
   * The collision mask this body collides with.
   */
  public var mask: CollisionFilter = GROUP_01;

  /**
   * Is this a trigger that doesn't collide with anything.
   */
  public var isTrigger = false;

  /**
   * Bounce for the body. (This can give some weird results with height values)
   */
  public var bounce = 0.0;

  /**
   * Is the body affected by gravity;
   */
  public var useGravity = true;

  /**
   * The sides that are touching another body.
   */
  public var touching = Touching.NONE;

  /**
   * The sides the body can collide with another body. Usefull for one-way platforms.
   */
  public var canCollide = Collide.ALL;

  /**
   * The sides that were touching another body prefious update.
   */
  public var touchingPrevious = Touching.NONE;

  /**
   * Userdata can store any data you want for easy access in collision callbacks.
   */
  public var userData: Dynamic;

  /**
   * The x position in pixels of the body last update.
   */
  public var lastX: Float;

  /**
   * The y position in pixel of the body last update.
   */
  public var lastY: Float;

  /**
   * Bodies that this body is colliding with this update.
   */
  @:allow(aeons.systems.SSimplePhysics)
  var collidingWith: Array<Body> = [];

  /**
   * Bodies that this body was colliding with last update.
   */
  @:allow(aeons.systems.SSimplePhysics)
  var wasCollidingwith: Array<Body> = [];

  /**
   * Bodies that this body is triggered by this update.
   */
  @:allow(aeons.systems.SSimplePhysics)
  var triggeredBy: Array<Body> = [];

  /**
   * Bodies that this body was triggered by last update.
   */
  @:allow(aeons.systems.SSimplePhysics)
  var wasTriggeredBy: Array<Body> = [];

  /**
   * Constructor.
   */
  public function new(?component: CSimpleBody) {
    this.component = component;
  }

  /**
   * The x getter.
   */
  inline function get_x(): Float {
    return bounds.x + bounds.width * 0.5;
  }

  /**
   * The y getter.
   */
  inline function get_y(): Float {
    return bounds.y + bounds.height * 0.5;
  }
}
