package aeons.components;

import aeons.graphics.RenderTarget;
import aeons.math.Rect;
import aeons.core.Renderable;
import aeons.core.Component;

class CLdtkTilemap extends Component implements Renderable {
  public var bounds = new Rect();

  public var anchorX = 0.0;

  public var anchorY = 0.0;

  public function new() {
    super();
  }

  public function render(target: RenderTarget, cameraBounds: Rect) {

  }
}