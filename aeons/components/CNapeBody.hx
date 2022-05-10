package aeons.components;

#if use_nape
import aeons.core.Component;
import aeons.math.Vector2;

import nape.callbacks.CbType;
import nape.dynamics.InteractionFilter;
import nape.geom.Vec2;
import nape.phys.Body;
import nape.phys.BodyType;
import nape.phys.Material;
import nape.shape.Circle;
import nape.shape.Polygon;
import nape.space.Space;

/**
 * CNapeBody is the body component for the nape physics system.
 */
class CNapeBody extends Component {
  /**
   * The nape body.
   */
  public var body(default, null): Body;

  /**
   * UserData can be used to set any data. See Nape documentation for more info.
   */
  public var userData(get, never): Dynamic;

  /**
   * Is this body a sensor. Sensors don't collide with anything but can trigger overlap callbacks.
   */
  public var isSensor(default, set): Bool;

  /**
   * Can this body move with physics.
   */
  public var allowMovement(get, set): Bool;

  /**
   * Can this body rotate with physics.
   */
  public var allowRotation(get, set): Bool;

  /**
   * The nape body tyype.
   */
  public var type(get, set): BodyType;

  /**
   * Reference to the transform component.
   */
  var transform: CTransform;

  /**
   * The nape space reference.
   */
  @:allow(aeons.systems.NapePhysicsSystem)
  var space: Space;

  var tempPoint = new Vec2();

  var tempOptions: CNapeBodyOptions;

  /**
   * CNapeBody constructor.
   * @param options The values you want to set.
   */
  public function new(?options: CNapeBodyOptions) {
    super();

    tempOptions = options;
  }

  /**
   * Init gets called after the component has been added to the entity.
   * @param entityId The id of the entity the component got added to.
   */
  public override function init(entityId: Int) {
    super.init(entityId);

    transform = getComponent(CTransform);
    var type = tempOptions != null && tempOptions.type != null ? tempOptions.type : BodyType.DYNAMIC;
    body = new Body(type, Vec2.weak(transform.x, transform.y));
    isSensor = false;

    if (tempOptions != null) {
      if (tempOptions.isSensor != null) {
        isSensor = tempOptions.isSensor;
      }
      if (tempOptions.allowMovement != null) {
        allowMovement = tempOptions.allowMovement;
      }
      if (tempOptions.allowRotation != null) {
        allowRotation = tempOptions.allowRotation;
      }
      if (tempOptions.material != null) {
        setMaterial(tempOptions.material);
      }
      if (tempOptions.addToSpace != null && tempOptions.addToSpace) {
        body.space = space;
      }
    }
  }

  /**
   * Create a rectangular body shape.
   * @param width The width of the shape in game pixels.
   * @param height The height of the shape in game pixels.
   */
  public function createRectBody(width: Float, height: Float) {
    removeFromSpace();
    final shape = new Polygon(Polygon.box(width, height));
    body.shapes.clear();
    body.shapes.add(shape);
    for (shape in body.shapes) {
      shape.sensorEnabled = isSensor;
    }
    addToSpace();
  }

  /**
   * Create a circle body shape.
   * @param radius The circle radius in game pixels.
   */
  public function createCircleBody(radius: Float) {
    removeFromSpace();
    final shape = new Circle(radius);
    body.shapes.clear();
    body.shapes.add(shape);
    for (shape in body.shapes) {
      shape.sensorEnabled = isSensor;
    }
    addToSpace();
  }

  /**
   * Set an interaction filter to filter collisions.
   * @param filter The filter to set.
   */
  public inline function setInteractionFilter(filter: InteractionFilter) {
    body.setShapeFilters(filter);
  }

  /**
   * Add a cb type to the body. This is like a tag you can use in interaction callbacks.
   * @param type The type to add.
   */
  public inline function addCBType(type: CbType) {
    body.cbTypes.add(type);
  }

  /**
   * Remove a cb type from the body.
   * @param type The type to remove.
   */
  public inline function removeCBType(type: CbType) {
    body.cbTypes.remove(type);
  }

  /**
   * Create a nape material and set it to the body.
   * @param elasticity Between 0 and 1.
   * @param dynamicFriction Any number greater than 0.
   * @param staticFriction Any number greater than 0.
   * @param density Gram / pixel / pixel.
   * @param rollingFriction Any number greater than 0.
   */
  public inline function createMaterial(elasticity: Float, dynamicFriction: Float, staticFriction: Float,
      density: Float, rollingFriction: Float): Material {
    final material = new Material(elasticity, dynamicFriction, staticFriction, density, rollingFriction);
    setMaterial(material);

    return material;
  }

  /**
   * Set a new nape material.
   * @param material The material to set.
   */
  public inline function setMaterial(material: Material) {
    body.setShapeMaterials(material);
  }

  /**
   * Apply a linear impulse to the body.
   * @param impulse The impulse to apply.
   * @param position The position on the body to apply the linear impulse to.
   * @param canSleep Can the body sleep.
   */
  public function applyImpulse(impulse: Vector2, ?position: Vector2, canSleep = false) {
    var worldPos = transform.getWorldPosition();
    final pos = Vec2.weak(body.position.x, body.position.y);
    if (position != null) {
      pos.setxy(position.x, position.y);
    }
    body.applyImpulse(Vec2.weak(impulse.x, impulse.y), pos, canSleep);
    worldPos.put();
  }

  /**
   * Apply an angular impulse.
   * @param impulse The impulse to add.
   * @param canSleep Can the body sleep.
   */
  public inline function applyAngularImpulse(impulse: Float, canSleep = false) {
    body.applyAngularImpulse(impulse, canSleep);
  }

  /**
   * Remove the body from the nape space.
   */
  public inline function removeFromSpace() {
    body.space = null;
  }

  /**
   * Add the body to the nape space.
   */
  public inline function addToSpace() {
    body.space = space;
  }

  public function containsPoint(x: Float, y: Float): Bool {
    tempPoint.x = x;
    tempPoint.y = y;
    return body.contains(tempPoint);
  }

  /**
   * This component requires a transform component.
   */
  override function get_requiredComponents(): Array<Class<Component>> {
    return [CTransform];
  }

  inline function set_isSensor(value: Bool): Bool {
    isSensor = value;
    for (shape in body.shapes) {
      shape.sensorEnabled = isSensor;
    }

    return isSensor;
  }

  inline function get_allowMovement(): Bool {
    return body.allowMovement;
  }

  inline function set_allowMovement(value: Bool): Bool {
    body.allowMovement = value;

    return value;
  }

  inline function get_allowRotation(): Bool {
    return body.allowRotation;
  }

  inline function set_allowRotation(value: Bool): Bool {
    body.allowRotation = value;

    return value;
  }

  inline function get_userData(): Dynamic {
    return body.userData;
  }

  inline function get_type(): BodyType {
    return body.type;
  }

  inline function set_type(value: BodyType): BodyType {
    body.type = value;

    return value;
  }
}

/**
 * The values you can set in the CNapeBody init function.
 */
typedef CNapeBodyOptions = {
  /**
   * Is the nape body a sensor.
   */
  var ?isSensor: Bool;

  /**
   * Is the nape body allowed to move.
   */
  var ?allowMovement: Bool;

  /**
   * Is the nape body allowed to rotate.
   */
  var ?allowRotation: Bool;

  /**
   * The physics material.
   */
  var ?material: Material;

  /**
   * Should the body be added to the nape space on init.
   */
  var ?addToSpace: Bool;

  /**
   * The body type for the Nape body.
   */
  var ?type: BodyType;
}
#end
