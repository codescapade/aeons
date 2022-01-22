package aeons.tilemap;

import aeons.math.Vector2;

/**
 * `TiledObject` is a class that holds all object properties from a tiled object.
 */
class TiledObject {
  /**
   * The object id.
   */
  public var id(default, null): Int;

  /**
   * The x position in pixels.
   */
  public var x(default, null): Float;

  /**
   * The y position in pixels.
   */
  public var y(default, null): Float;

  /**
   * The width in pixels.
   */
  public var width(default, null): Float;

  /**
   * The height in pixels.
   */
  public var height(default, null): Float;

  /**
   * The object name.
   */
  public var name(default, null): String;

  /**
   * The object type.
   */
  public var type(default, null): String;

  /**
   * The object rotation in degrees.
   */
  public var rotation(default, null): Float;

  /**
   * Is this object visible on the map.
   */
  public var visible(default, null): Bool;

  /**
   * If the object is a polygon this has the vertices in pixel coordinates.
   */
  public var polygon(default, null): Array<Vector2>;

  /**
   * Custom properties for the object.
   */
  public var properties(default, null): Array<TiledObjectProp>;

  /**
   * Constructor.
   * @param id The object id.
   * @param x The x position in pixels.
   * @param y The y position in pixels.
   * @param width The width in pixels.
   * @param height The height in pixles.
   * @param name The object name.
   * @param type The object type.
   * @param rotation The object rotation in degrees.
   * @param visible Is the object visible on the map.
   * @param properties Custom object properties.
   * @param polygon Polygon vertices if the object is a polygon.
   */
  public function new(id: Int, x: Float, y: Float, width: Float, height: Float, name: String, type: String,
      rotation: Float, visible: Bool, properties: Array<TiledObjectProp>, ?polygon: Array<Dynamic>) {
    this.id = id;
    this.x = x;
    this.y = y;
    this.width = width;
    this.height = height;
    this.name = name;
    this.type = type;
    this.rotation = rotation;
    this.visible = visible;
    this.properties = properties;
    this.polygon = [];
    if (polygon != null) {
      for (p in polygon) {
        this.polygon.push(new Vector2(p.x, p.y));
      }
    }
  }
}