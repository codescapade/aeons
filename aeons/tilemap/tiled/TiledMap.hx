package aeons.tilemap.tiled;

import haxe.Json;

/**
 * `TiledMap` class is for loading tiled json tilemaps.
 */
class TiledMap {
  /**
   * The tileset used in the tilemap.
   */
  public var tileset(default, null): Tileset;

  /**
   * The width of the map in tiles.
   */
  public var width(default, null): Int;

  /**
   * The height of the map in tiles.
   */
  public var height(default, null): Int;

  /**
   * The tiled tile layers.
   */
  public var tileLayers(default, null): Map<String, Array<Array<Int>>>;

  /**
   * The tiled object layers.
   */
  public var objectLayers(default, null): Map<String, Array<TiledObject>>;

  public var tilesetFirstGid(default, null): Map<String, Int>;

  /**
   * Constructor.
   * @param tileset The tileset to use.
   * @param data The json tiled data.
   */
  public function new(tileset: Tileset, data: String) {
    this.tileset = tileset;
    final mapData = Json.parse(data);
    width = mapData.width;
    height = mapData.height;

    tileLayers = new Map<String, Array<Array<Int>>>();
    objectLayers = new Map<String, Array<TiledObject>>();
    tilesetFirstGid = new Map<String, Int>();

    var layers: Array<Dynamic> = mapData.layers;
    for (layer in layers) {
      if (layer.type == 'tilelayer') {
        // Create a 2d array of indexes from the tiled layer.
        var arr = layerDataTo2dArray(layer.data, layer.width, layer.height);
        tileLayers[layer.name] = arr;
      } else if (layer.type == 'objectgroup') {
        var objects: Array<TiledObject> = [];
        var objectList: Array<Dynamic> = layer.objects;
        for (obj in objectList) {
          var tiledProps: Array<TiledObjectProp> = [];
          var properties: Array<Dynamic> = obj.properties;
          if (properties != null) {
            for (prop in properties) {
              var objectProp = new TiledObjectProp(prop.name, prop.type, prop.value);
              tiledProps.push(objectProp);
            }

          }
          var object = new TiledObject(obj.id, obj.x, obj.y, obj.width, obj.height, obj.name, obj.type, obj.rotation,
              obj.visible, tiledProps, obj.polygon);
          objects.push(object);
        }
        objectLayers[layer.name] = objects;
      }
    }
    var tilesets: Array<Dynamic> = mapData.tilesets;
    for (tileset in tilesets) {
      tilesetFirstGid[tileset.name] = tileset.firstgid;
    }

  }

  /**
   * Tiled tile layer to 2d array.
   * @param data The tiled layer.
   * @param width The layer width in tiles.
   * @param height The layer height in tiles.
   */
  function layerDataTo2dArray(data: Array<Int>, width: Int, height: Int): Array<Array<Int>> {
    var y = 0;
    var pos = 0;
    var map: Array<Array<Int>> = [];

    while (y < height) {
      var row: Array<Int> = [];
      for (x in 0...width) {
        row.push(data[pos] - 1);
        pos++;
      }
      map.push(row);
      y++;
    }

    return map;
  }
}
