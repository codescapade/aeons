package aeons.tilemap;

import aeons.graphics.Image;
import aeons.math.Rect;

/**
 * Tileset is an image with indexed tile positions for the tilemap component.
 */
class Tileset {
  /**
   * Id is used for LDtk tilesets.
   */
  public var id(default, null): String;
  /**
   * The with of a tile in pixels.
   */
  public var tileWidth(default, null): Int;

  /**
   * The height of a tile in pixels.
   */
  public var tileHeight(default, null): Int;

  /**
   * The image used in the tileset.
   */
  public var tileImage(default, null): Image;

  /**
   * The tile bounds for graphics each tile.
   */
  final tiles: Array<Rect>;

  #if use_ldtk
  /**
   * Create a tileset from a LDtk tileset.
   * @param tileset The source tileset.
   * @param image Optional image if it is called differently in the tileset.
   * @return The created tileset.
   */
  public static function fromLdtkTileset(tileset: ldtk.Tileset, ?image: Image): Tileset {
    if (image == null) {
      image = Aeons.assets.getImage(tileset.identifier.toLowerCase());
    }

    return new Tileset(image, tileset.tileGridSize, tileset.tileGridSize, tileset.spacing, tileset.padding,
        tileset.identifier);
  }
  #end

  /**
   * Constructor.
   * @param image The image to use.
   * @param tileWidth The width of a tile in pixels.
   * @param tileHeight The height of a tile in pixels.
   * @param spacing The spacing between tiles in the image in pixels.
   * @param margin The margin between the edge of the image and the tiles in pixels.
   * @param id LDtk tileset id.
   */
  public function new(image: Image, tileWidth: Int, tileHeight: Int, spacing: Int = 0, margin: Int = 0, ?id: String) {
    tileImage = image;
    this.tileWidth = tileWidth;
    this.tileHeight = tileHeight;
    if (id != null) {
      this.id = id;
    }

    final width = image.width;
    final height = image.height;

    final horizontalTiles = Math.floor((width - margin * 2 + spacing) / (tileWidth + spacing));
    final verticalTiles = Math.floor((height - margin * 2 + spacing) / (tileHeight + spacing));

    tiles = [];

    for (y in 0...verticalTiles) {
      for (x in 0...horizontalTiles) {
        final xPos = margin + x * tileWidth + x * spacing;
        final yPos = margin + y * tileHeight + y * spacing;
        tiles.push(new Rect(xPos, yPos, tileWidth, tileHeight));
      }
    }
  }

  /**
   * Get a rectangle to render a sub image tile from.
   * @param index The tile index you want the tile from.
   */
  public function getRect(index: Int): Rect {
    if (index < 0 || index >= tiles.length) {
      throw 'Tile index ${index} is out of range.';
    }

    return tiles[index];
  }
}
