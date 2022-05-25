package aeons.components;

#if use_ldtk
import aeons.core.Component;
import aeons.core.Renderable;
import aeons.graphics.RenderTarget;
import aeons.math.Rect;
import aeons.tilemap.ldtk.LdtkLayer;
import aeons.tilemap.ldtk.LdtkTile;

/**
 * Tilemap component for LDtk tilemaps.
 */
class CLdtkTilemap extends Component implements Renderable {
  /**
   * Not used in this component. 
   */
  @:dox(hide)
  public var anchorX = 0.0;

  /**
   * Not used in this component.
   */
  @:dox(hide)
  public var anchorY = 0.0;

  /**
   * The level layers.
   */
  var layers: Array<LdtkLayer> = [];

  /**
   * Map of all layers to make getting and setting tiles easier.
   */
  var layerMap: Map<String, LdtkLayer> = new Map<String, LdtkLayer>();

  /**
   * Render the tilemap.
   * @param target The render target.
   */
  public function render(target: RenderTarget) {
    for (layer in layers) {
      layer.render(target);
    }
  }

  /**
   * This updates which tiles to render based on the camera bounds.
   * @param cameraBounds The local camera bounds.
   * @return Always true for tilemaps
   */
  public function inCameraBounds(cameraBounds: Rect): Bool {
    for (layer in layers) {
      layer.updateVisibleTiles(cameraBounds);
    }
    return true;
  }

  /**
   * Add a tilemap layer. This goes on top of the existing layer list.
   * @param layer The new layer.
   */
  public function addLayer(layer: LdtkLayer) {
    layers.unshift(layer);
  }

  /**
   * Add a list of layers to the tilemap. The order is bottom to top.
   * @param layers The list of layer to add.
   */
  public function addLayers(layers: Array<LdtkLayer>) {
    for (layer in layers) {
      this.layers.push(layer);
    }
  }

  /**
   * Get a tile in a layer.
   * @param layerId The layer identifier.
   * @param x The x position of the tile in tiles.
   * @param y The y position of the tile in tiles.
   * @return The tile. If the tileId = -1 the tile is empty.
   */
  public function getTile(layerId: String, x: Int, y: Int): LdtkTile {
    return layerMap[layerId].getTile(x, y);
  }

  /**
   * Set a new tile id for a tile in a layer.
   * @param layerId The layer identifier.
   * @param x The x position of the tile in tiles.
   * @param y The y position of the tile in tiles.
   * @param tileId The new tile id.
   * @param flipX Is the tile flipped horizontally.
   * @param flipY Is the tile flipped vertically.
   */
  public function setTile(layerId: String, x: Int, y: Int, tileId: Int, ?flipX: Bool, ?flipY: Bool) {
    layerMap[layerId].setTile(x, y, tileId, flipX, flipY);
  }
}
#end
