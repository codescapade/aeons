package aeons.tilemap;

/**
 * `TiledObjectProp` is for custom properties on a tiled object.
 */
class TiledObjectProp {
  /**
   * The property name.
   */
  public var name(default, null): String;

  /**
   * The property type.
   */
  public var type(default, null): String;

  /**
   * The property value.
   */
  public var value(default, null): Dynamic;

  /**
   * Constructor.
   * @param name The property name.
   * @param type The property type.
   * @param value The property value.
   */
  public function new(name: String, type: String, value: Dynamic) {
    this.name = name;
    this.type = type;
    this.value = value;
  }
}
