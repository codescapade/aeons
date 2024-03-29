package aeons.components;

import aeons.core.Component;
import aeons.core.Renderable;
import aeons.graphics.Color;
import aeons.graphics.RenderTarget;
import aeons.math.Rect;
import aeons.math.Vector2;
import aeons.tilemap.Tileset;

using aeons.math.AeMath;

/**
 * CTilemap component.
 */
class CTilemap extends Component implements Renderable {
  /**
   * The tileset to use for the tilemap.
   */
  public var tileset: Tileset;

  /**
   * The width of the tilemap in pixels.
   */
  public var widthInPixels(get, null): Int;

  /**
   * The height of the tilemap in pixels.
   */
  public var heightInPixels(get, null): Int;

  /**
   * The width of the tilemap in tiles.
   */
  public var widthInTiles(get, null): Int;

  /**
   * The height of the tilemap in tiles.
   */
  public var heightInTiles(get, null): Int;

  /**
   * The tilemap color.
   */
  public var color = Color.White;

  /**
   * The tile indexes 2d array.
   */
  var tiles: Array<Array<Int>>;

  /**
   * The transform component of this entity.
   */
  var transform: CTransform;

  /**
   * The tile bounds that are visible to the camera.
   */
  var visibleBounds = new Rect();

  /**
   * The x axis anchor. Not used in this component.
   */
  @:dox(hide)
  public var anchorX = 0.0;

  /**
   * The y axis anchor. Not used in this component.
   */
  @:dox(hide)
  public var anchorY = 0.0;

  /**
   * Initialize the component.
   * @return This component.
   */
  public function create(): CTilemap {
    transform = getComponent(CTransform);

    return this;
  }

  /**
   * Render the tilemap.
   * @param target The graphics buffer to use.
   */
  public function render(target: RenderTarget) {
    if (tiles == null) {
      return;
    }

    for (y in visibleBounds.yi...visibleBounds.heighti) {
      for (x in visibleBounds.xi...visibleBounds.widthi) {
        final index = tiles[y][x];
        if (index < 0) {
          continue;
        }
        final rect = tileset.getRect(index);
        target.drawImageSection(x * tileset.tileWidth, y * tileset.tileHeight, rect.x, rect.y, rect.width,
          rect.height, tileset.tileImage, color);
      }
    }
  }

  /**
   * This updates which tiles to render based on the camera bounds.
   * @param cameraBounds The local camera bounds.
   * @return Always true for tilemaps
   */
  public function inCameraBounds(cameraBounds: Rect): Bool {
    updateVisibleTiles(cameraBounds);
    return true;
  }

  /**
   * Create a tilemap from a 2d array of indexes.
   * @param map The 2d array.
   * @param tileset The tileset to use.
   */
  public function createFrom2dArray(map: Array<Array<Int>>, tileset: Tileset) {
    this.tileset = tileset;
    tiles = [];
    for (y in 0...map.length) {
      final row: Array<Int> = [];
      for (x in 0...map[y].length) {
        row.push(map[y][x]);
      }
      tiles.push(row);
    }
  }

  /**
   * Get a tile index from a tile position.
   * @param x The tile x coordinate.
   * @param y The tile y coordinate.
   */
  public function getTile(x: Int, y: Int): Int {
    if (tiles == null) {
      throw 'Map not found';
    }

    if (x < 0 || x >= widthInTiles || y < 0 || y >= heightInTiles) {
      throw 'Position x: ${x}, y: ${y} is out of range';
    }

    return tiles[y][x];
  }

  /**
   * Set a new tile index.
   * @param x The tile x coordinate.
   * @param y The tile y coordinate.
   * @param tile The new index.
   */
  public function setTile(x: Int, y: Int, tile: Int) {
    if (tiles == null) {
      throw 'Map not found';
    }

    if (x < 0 || x >= widthInTiles || y < 0 || y >= heightInTiles) {
      throw 'Position x: ${x}, y: ${y} is out of range';
    }

    tiles[y][x] = tile;
  }

  /**
   * Convert a local pixel position to tile position.
   * @param xPos The world x position in game pixels.
   * @param yPos The world y position in game pixels.
   */
  public function pixelToTilePosition(xPos: Float, yPos: Float): Vector2 {
    final x = Math.floor(xPos / tileset.tileWidth);
    final y = Math.floor(yPos / tileset.tileHeight);

    return Vector2.get(x, y);
  }

  /**
   * Update the visible tile range.
   * @param bounds The camera bounds.
   */
  function updateVisibleTiles(bounds: Rect) {
    if (tiles == null) {
      return;
    }

    var topLeft = pixelToTilePosition(bounds.x, bounds.y);
    topLeft.x -= 1;
    topLeft.y -= 1;
    topLeft.x = Math.clampInt(topLeft.xi, 0, widthInTiles);
    topLeft.y = Math.clampInt(topLeft.yi, 0, heightInTiles);

    var bottomRight = pixelToTilePosition(bounds.x + bounds.width, bounds.y + bounds.height);
    bottomRight.x += 2;
    bottomRight.y += 2;
    bottomRight.x = Math.clampInt(bottomRight.xi, 0, widthInTiles);
    bottomRight.y = Math.clampInt(bottomRight.yi, 0, heightInTiles);

    visibleBounds.set(topLeft.xi, topLeft.yi, bottomRight.xi, bottomRight.yi);

    topLeft.put();
    bottomRight.put();
  }

  /**
   * This component requires a transform component.
   */
  override function get_requiredComponents(): Array<Class<Component>> {
    return [CTransform];
  }

  inline function get_widthInPixels(): Int {
    return tiles == null || tileset == null ? 0 : widthInTiles * tileset.tileWidth;
  }

  inline function get_heightInPixels(): Int {
    return tiles == null || tileset == null ? 0 : heightInTiles * tileset.tileHeight;
  }

  inline function get_widthInTiles(): Int {
    return tiles == null ? 0 : tiles[0].length;
  }

  inline function get_heightInTiles(): Int {
    return tiles == null ? 0 : tiles.length;
  }
}
