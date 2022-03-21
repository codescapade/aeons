package aeons.tilemap.ldtk;

#if use_ldtk
import aeons.graphics.Color;
import aeons.graphics.RenderTarget;
import aeons.tilemap.Tileset;

import ldtk.Layer_AutoLayer;
import ldtk.Layer_IntGrid_AutoLayer;
import ldtk.Layer_Tiles;

/**
 * A layer in a LDtk tilemap level.
 */
class LdtkLayer {
  /**
   * The tint color of the layer.
   */
  public var tint = Color.White;

  /**
   * The identifier set in the editor.
   */
  public var id(default, null): String;

  /**
   * The tileset used for this layer.
   */
  public var tileset(default, null): Tileset;

  /**
   * The width of the layer in tiles.
   */
  public var width(get, never): Int;

  /**
   * The height of the layer in tiles.
   */
  public var height(get, never): Int;

  /**
   * The 2d array of tiles.
   */
  var tiles: Array<Array<LdtkTile>>;

  /**
   * Create a layer from a Tile layer.
   * @param layer The LDtk tile layer.
   * @param tileset The tileset used in the layer.
   * @return The created layer.
   */
  public static function fromTilesLayer(layer: Layer_Tiles, tileset: Tileset): LdtkLayer {
    var layerTiles: Array<Array<LdtkTile>> = [];
    for (y in 0...layer.cHei) {
      final row: Array<LdtkTile> = [];
      for (x in 0...layer.cWid) {
        if (layer.hasAnyTileAt(x, y)) {
          final tile = layer.getTileStackAt(x, y)[0];
          final flipX = tile.flipBits & 1 != 0;
          final flipY = tile.flipBits & 2 != 0;
          row.push({ flipX: flipX, flipY: flipY, tileId: tile.tileId, size: tileset.tileWidth });
        } else {
          row.push({ flipX: false, flipY: false, tileId: -1, size: 0 });
        }
      }
      layerTiles.push(row);
    }

    return new LdtkLayer(tileset, layerTiles, layer.identifier);
  }

  /**
   * Create a layer from a Int Auto layer.
   * @param layer The LDtk Int Auto layer.
   * @param tileset The tileset used in the layer.
   * @return The created layer.
   */
  public static function fromIntAutoLayer(layer: Layer_IntGrid_AutoLayer, tileset: Tileset): LdtkLayer {
    final tileSize = tileset.tileWidth;
    final layerTiles = createEmptyTileList(layer.cWid, layer.cHei, tileSize);
    insertAutoTiles(layerTiles, layer.autoTiles, tileSize);

    return new LdtkLayer(tileset, layerTiles, layer.identifier);
  }

  /**
   * Create a layer from a Auto layer.
   * @param layer The LDtk Auto layer.
   * @param tileset The tileset used in the layer.
   * @return The created layer.
   */
  public static function fromAutoLayer(layer: Layer_AutoLayer, tileset: Tileset): LdtkLayer {
    final tileSize = tileset.tileWidth;
    final layerTiles = createEmptyTileList(layer.cWid, layer.cHei, tileSize);
    insertAutoTiles(layerTiles, layer.autoTiles, tileSize);

    return new LdtkLayer(tileset, layerTiles, layer.identifier);
  }

  /**
   * Constructor.
   * @param tileset The tileset used. 
   * @param tiles The list of tiles in the layer.
   * @param id The layer identifier.
   */
  public function new(tileset: Tileset, tiles: Array<Array<LdtkTile>>, id: String) {
    this.tileset = tileset;
    this.tiles = tiles;
    this.id = id;
  }

  /**
   * Get a tile in the layer.
   * @param x The x position in tiles.
   * @param y The y position in tiles.
   * @return The tile or null if out of bounds.
   */
  public function getTile(x: Int, y: Int): LdtkTile {
    if (x < 0 || x >= tiles[0].length || y < 0 || y >= tiles.length) {
      return null;
    }

    return tiles[y][x];
  }

  /**
   * Set new tile values.
   * @param x The x position in tiles.
   * @param y The y position in tiles.
   * @param tileId The new tile id.
   * @param flipX Flipped horizontally.
   * @param flipY Flipped vertically.
   */
  public function setTile(x: Int, y: Int, tileId: Int, ?flipX: Bool, ?flipY: Bool) {
    if (x < 0 || x >= tiles[0].length || y < 0 || y >= tiles.length) {
      return;
    }

    tiles[y][x].set(tileId, flipX, flipY);
  }

  /**
   * Render the layer.
   * @param target The target to render to.
   */
  public function render(target: RenderTarget) {
    for (y in 0...tiles.length) {
      for (x in 0...tiles[0].length) {
        final tile = tiles[y][x];
        if (!tile.isEmpty()) {
          final frame = tileset.getRect(tile.tileId);
          final xPos = x * tile.size + tile.xOffset;
          final yPos = y * tile.size + tile.yOffset;
          target.drawImageSectionWithSize(xPos, yPos, tile.renderWidth, tile.renderHeight, frame.x, frame.y,
              frame.width, frame.height, tileset.tileImage, tint);
        }
      }
    }
  }

  /**
   * Create a 2d array of empty tiles.
   * @param width The width of the array in tiles.
   * @param height The height of the array in tiles.
   * @param tileSize The tile size in pixels.
   * @return The created array.
   */
  static function createEmptyTileList(width: Int, height: Int, tileSize: Int): Array<Array<LdtkTile>> {
    var layerTiles: Array<Array<LdtkTile>> = [];
    for (y in 0...height) {
      final row: Array<LdtkTile> = [];
      for (x in 0...width) {
        row.push({ flipX: false, flipY: false, tileId: -1, size: tileSize });
      }
      layerTiles.push(row);
    }

    return layerTiles;
  }

  /**
   * Insert auto tiles a tile list.
   * @param list The list to edit.
   * @param tiles The list of auto tiles to insert.
   * @param tileSize The tile size in pixels.
   */
  static function insertAutoTiles(list: Array<Array<LdtkTile>>, tiles: Array<AutoTile>, tileSize: Int) {
    for (tile in tiles) {
      final x = Math.floor(tile.renderX / tileSize);
      final y = Math.floor(tile.renderY / tileSize);
      final flipX = tile.flips & 1 != 0;
      final flipY = tile.flips & 2 != 0;
      list[y][x].set(tile.tileId, flipX, flipY);
    }
  }

  /**
   * Layer width getter.
   */
  inline function get_width(): Int {
    return tiles[0].length;
  }

  /**
   * Layer height gettter.
   */
  inline function get_height(): Int {
    return tiles.length;
  }
}
#end