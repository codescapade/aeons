package aeons.physics.utils;

import aeons.components.CTilemap;
import aeons.components.CTransform;
import aeons.math.Rect;
import aeons.math.Vector2;

/**
 * Type for collider generation.
 */
private typedef Tile = {
  index: Int,
  checked: Bool
}

/**
 * `TilemapCollision` is a helper class to generate colliders for tiles in a tilemap.
 * This is used in both Simple and Nape physics systems.
 */
class TilemapCollision {

  /**
   * Generate colliders for certain tile indexes. Tries to make big colliders so there are less of them in the map.
   * @param tilemap The tilemap the colliders are for.
   * @param indexes The tile indexes that should have a collider.
   */
  public static function generateColliders(tilemap: CTilemap, transform: CTransform, indexes: Array<Int>): Array<Rect> {
    final tempMap: Array<Array<Tile>> = [];
    final tileWidth = tilemap.tileset.tileWidth;
    final tileHeight = tilemap.tileset.tileHeight;
    final worldPos = transform.getWorldPosition();

    // Get a 2d array of tile indexes with the ability to see which ones have been checked.
    for (y in 0...tilemap.heightInTiles) {
      final row: Array<Tile> = [];
      for (x in 0...tilemap.widthInTiles) {
        final index = tilemap.getTile(x, y);
        row.push({ index: index, checked: false });
      }
      tempMap.push(row);
    }

    final colliders: Array<Rect> = [];
    final start = Vector2.get();
    final current = Vector2.get();
    var checking = false;
    var foundLastY = false;

    // Starting at the top left go over all tiles and create colliders.
    for (x in 0...tilemap.widthInTiles) {
      for (y in 0...tilemap.heightInTiles) {
        var tile = tempMap[y][x];

        // Check if the tile should be part of a collider.
        if (!tile.checked && indexes.indexOf(tile.index) != -1) {
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
              if (current.x >= tilemap.widthInTiles) {
                checking = false;
                current.x--;
                break;
              }
              for (i in Std.int(start.y)...Std.int(current.y) + 1) {
                tile = tempMap[i][Std.int(current.x)];
                if (tile.checked || indexes.indexOf(tile.index) == -1) {
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
                for (i in Std.int(start.y)...Std.int(current.y) + 1) {
                  tempMap[i][Std.int(current.x) + 1].checked = false;
                }
              }
            } else {
              current.y++;
              if (current.y >= tilemap.heightInTiles) {
                foundLastY = true;
                current.y--;
              } else {
                tile = tempMap[Std.int(current.y)][Std.int(current.x)];
                if (tile.checked || indexes.indexOf(tile.index) == -1) {
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
          final xPos = worldPos.x + start.x * tileWidth;
          final yPos = worldPos.y + start.y * tileHeight;
          colliders.push(new Rect(xPos, yPos, tileWidth * distX, tileHeight * distY));
        }
      }
    }
    start.put();
    current.put();

    return colliders;
  }
}