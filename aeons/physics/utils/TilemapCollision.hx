package aeons.physics.utils;

#if use_ldtk
import aeons.tilemap.ldtk.LdtkLayer;
#end
import aeons.components.CTilemap;
import aeons.math.Rect;
import aeons.math.Vector2;

/**
 * Type for collider generation.
 */
@:structInit
private class Tile {
  public var id(default, null): Int;
  public var checked: Bool;
}

/**
 * `TilemapCollision` is a helper class to generate colliders for tiles in a tilemap.
 * This is used in both Simple and Nape physics systems.
 */
class TilemapCollision {

  /**
   * Generate colliders for certain tile indexes. Tries to make big colliders so there are less of them in the map.
   * @param tilemap The tilemap the colliders are for.
   * @param worldX The x position of the tilemap in world pixels.
   * @param worldY The y position of the tilemap in world pixels.
   * @param collisionTileIds The list of ids that should have a collider.
   * @return A list of rectangles that represent colliders.
   */
  public static function generateCollidersFromCTilemap(tilemap: CTilemap, worldX: Float, worldY: Float,
      collisionTileIds: Array<Int>): Array<Rect> {
    final tiles: Array<Array<Tile>> = [];
    final tileSize = tilemap.tileset.tileWidth;

    // Get a 2d array of tile indexes with the ability to see which ones have been checked.
    for (y in 0...tilemap.heightInTiles) {
      final row: Array<Tile> = [];
      for (x in 0...tilemap.widthInTiles) {
        final id = tilemap.getTile(x, y);
        row.push({ id: id, checked: false });
      }
      tiles.push(row);
    }

    return generateColliders(tiles, worldX, worldY, tileSize, collisionTileIds);
  }

  #if use_ldtk
  /**
   * Generate colliders for certain tile indexes. Tries to make big colliders so there are less of them in the map.
   * @param layer The LDtk tilemap layer to use for the collider generation. 
   * @param worldX The x position of the tilemap in world pixels.
   * @param worldY The y position of the tilemap in world pixels.
   * @param collisionTileIds The list of ids that should have a collider.
   * @return A list of rectangles that represent colliders.
   */
  public static function generateCollidersFromLDtkLayer(layer: LdtkLayer, worldX: Float, worldY: Float,
      collisionTileIds: Array<Int>): Array<Rect> {
    final tiles: Array<Array<Tile>> = [];
    final tileSize = layer.tileset.tileWidth;

    for (y in 0...layer.height) {
      final row: Array<Tile> = [];
      for (x in 0...layer.width) {
        final id = layer.getTile(x, y).tileId;
        row.push({ id: id, checked: false });
      }
      tiles.push(row);
    }

    return generateColliders(tiles, worldX, worldY, tileSize, collisionTileIds);
  }
  #end

  static function generateColliders(tiles: Array<Array<Tile>>, worldX: Float, worldY: Float, tileSize: Int,
      collisionTileIds: Array<Int>): Array<Rect> {

    final colliders: Array<Rect> = [];
    final start = Vector2.get();
    final current = Vector2.get();
    var checking = false;
    var foundLastY = false;

    // Starting at the top left go over all tiles and create colliders.
    for (x in 0...tiles[0].length) {
      for (y in 0...tiles.length) {
        var tile = tiles[y][x];

        // Check if the tile should be part of a collider.
        if (!tile.checked && collisionTileIds.indexOf(tile.id) != -1) {
          tile.checked = true;
          start.set(x, y);
          current.set(x, y);
          checking = true;
          foundLastY = false;
          // Move down until there is no collider found or the end of the map is reached.
          while (checking) {
            // If it found the bottom most connected collision tile move right from the start to see how big
            // the collider can be horizontally.
            if (foundLastY) {
              current.x++;
              if (current.x >= tiles[0].length) {
                checking = false;
                current.x--;
                break;
              }
              for (i in start.yi...current.yi + 1) {
                tile = tiles[i][current.xi];
                if (tile.checked || collisionTileIds.indexOf(tile.id) == -1) {
                  current.x--;
                  checking = false;
                } else {
                  tile.checked = true;
                }

                if (!checking) {
                  break;
                }
              }
              if (!checking) {
                for (i in start.yi...current.yi + 1) {
                  tiles[i][current.xi + 1].checked = false;
                }
              }
            } else {
              current.y++;
              if (current.y >= tiles.length) {
                foundLastY = true;
                current.y--;
              } else {
                tile = tiles[current.yi][current.xi];
                if (tile.checked || collisionTileIds.indexOf(tile.id) == -1) {
                  current.y--;
                  foundLastY = true;
                } else {
                  tile.checked = true;
                }
              }
            }
          }
          var distX = current.x - start.x;
          var distY = current.y - start.y;
          distX++;
          distY++;
          final xPos = worldX + start.x * tileSize;
          final yPos = worldY + start.y * tileSize;
          colliders.push(new Rect(xPos, yPos, tileSize * distX, tileSize * distY));
        }
      }
    }
    start.put();
    current.put();

    return colliders;
  }
}