package aeons.components;

import nape.callbacks.CbType;
import nape.geom.GeomPoly;
import nape.geom.Vec2;
import nape.phys.Body;
import nape.phys.BodyType;
import nape.phys.Material;
import nape.shape.Polygon;
import nape.space.Space;

import aeons.core.Component;
import aeons.physics.utils.TilemapCollision;
import aeons.tilemap.TiledObject;

/**
 * Tilemap collider component for Nape physics.
 */
class CNapeTilemapCollider extends Component {
  /**
   * The transform component reference.
   */
  var transform: CTransform;

  /**
   * The tilemap component reference.
   */
  var tilemap: CTilemap;

  /**
   * The nape bodies created for the tilemap.
   */
  var bodies: Array<Body>;

  /**
   * The nape physics space reference.
   */
  @:allow(aeons.systems.NapePhysicsSystem)
  var space: Space;

  /**
   * Get the other components
   */
  public function init(): CNapeTilemapCollider {
    transform = getComponent(CTransform);
    tilemap = getComponent(CTilemap);
    bodies = [];

    return this;
  }

  /**
   * Component cleanup.
   */
  public override function cleanup() {
    super.cleanup();

    // Remove all bodies from the space.
    for (body in bodies) {
      body.space = null;
    }
  }

  /**
   * Generate colliders from certain tiles.
   * @param indexes An array of indexes you want colliders on.
   */
  public function setCollisions(indexes: Array<Int>) {
    // Generate colliders.
    final rects = TilemapCollision.generateColliders(tilemap, transform, indexes);
    bodies = [];

    for (rect in rects) {
      final body = new Body(BodyType.STATIC);
      final shape = new Polygon(Polygon.rect(rect.x, rect.y, rect.width, rect.height));
      body.shapes.add(shape);
      if (space == null) {
        throw 'Nape space not set';
      }
      body.space = space;
      bodies.push(body);
    }
  }

  /**
   * Create colliders from tiled objects.
   * @param objects Array of tiled object to use for collision.
   */
  public function fromTiledObjects(objects: Array<TiledObject>) {
    bodies = [];
    var worldPos = transform.getWorldPosition();
    for (obj in objects) {
      var body = new Body(BodyType.STATIC);

      // Object is a polygon, not a rectangle.
      if (obj.polygon.length > 0) {
        var chain: Array<Vec2> = [];
        for (p in obj.polygon) {
          chain.push(Vec2.get(worldPos.x + obj.x + p.x, worldPos.y + obj.y + p.y));
        }
        var shapes = new GeomPoly(chain).convexDecomposition();
        shapes.foreach((shape: GeomPoly) -> {
          var points: Array<Vec2> = [];
          for (vec in shape.forwardIterator()) {
            points.push(vec);
          }
          var poly = new Polygon(points);
          body.shapes.push(poly);
        });
      } else {
        var shape = new Polygon(Polygon.rect(worldPos.x + obj.x, worldPos.y + obj.y, obj.width, obj.height));
        body.shapes.push(shape);
      }
      if (space == null) {
        throw 'Nape space not set';
      }
      body.space = space;
      bodies.push(body);
    }
  }

  /**
   * Create a nape material and set it to the body.
   * @param elasticity 
   * @param dynamicFriction 
   * @param staticFriction 
   * @param density 
   * @param rollingFriction 
   */
  public function createMaterial(elasticity: Float, dynamicFriction: Float, staticFriction: Float, density: Float,
      rollingFriction: Float): Material {
    final material = new Material(elasticity, dynamicFriction, staticFriction, density, rollingFriction);
    setMaterial(material);

    return material;
  }

  /**
   * Set a new nape material.
   * @param material The material to set.
   */
  public inline function setMaterial(material: Material) {
    for (body in bodies) {
      body.setShapeMaterials(material);
    }
  }

  /**
   * Add a nape cbType to the tilemap colliders.
   * @param type The type you want t9 add.
   */
  public inline function addCBType(type: CbType) {
    for (body in bodies) {
      body.cbTypes.add(type);
    }
  }

  /**
   * Remove a nape cbType from the tilemap colliders.
   * @param type The type you want to remove.
   */
  public inline function removeCBType(type: CbType) {
    for (body in bodies) {
      body.cbTypes.remove(type);
    }
  }

  /**
   * This component depends on a tilemap and transform component.
   */
  override function get_requiredComponents():Array<Class<Component>> {
    return [CTilemap, CTransform];
  }
}