package aeons.tilemap.ldtk;

/**
 * A tile from a LDtk tilemap.
 */
#if use_ldtk
@:structInit
class LdtkTile {
  /**
   * Is the tile flipped on the horizontally.
   */
  public var flipX(default, null): Bool;

  /**
   * Is the tile flipped vertically.
   */
  public var flipY(default, null): Bool;

  /**
   * The tile id in the tileset.
   */
  public var tileId(default, null): Int;

  /**
   * The tile size in pixels.
   */
  public var size(default, null): Int;

  /**
   * The render width is -size when flipped.
   */
  public var renderWidth(get, never): Float;

  /**
   * The render height is -size when flipped.
   */
  public var renderHeight(get, never): Float;

  /**
   * The offset when flipped.
   */
  public var xOffset(get, never): Float;

  /**
   * The offset when flipped.
   */
  public var yOffset(get, never): Float;

  /**
   * Check if a tile is empty.
   * @return True if the tile is empty.
   */
  public inline function isEmpty(): Bool {
    return tileId == -1;
  }

  /**
   * Set new values on a tile.
   * @param tileId The new tile id.
   * @param flipX The new flip x status.
   * @param flipY The new flip y status.
   * @param size The new tile size in pixels..
   */
  public function set(tileId: Int, ?flipX: Bool, ?flipY: Bool, ?size: Int) {
    this.tileId = tileId;
    if (flipX != null) {
      this.flipX = flipX;
    }

    if (flipY != null) {
      this.flipY = flipY;
    }

    if (size != null) {
      this.size = size;
    }
  }

  /**
   * Render width getter. Tile size or negative tile size if flipped.
   */
  inline function get_renderWidth(): Float {
    return flipX ? -size : size;
  }

  /**
   * Render height getter. Tile size or negative tile size if flipped.
   */
  inline function get_renderHeight(): Float {
    return flipY ? -size : size;
  }

  /**
   * xOffset getter. Tile size if the tile is flipped because it renders from top left.
   */
  inline function get_xOffset(): Float {
    return flipX ? size : 0;
  }

  /**
   * yOffset getter. Tile size if the tile is flipped because it renders from top left.
   */
  inline function get_yOffset(): Float {
    return flipY ? size : 0;
  }
}
#end
