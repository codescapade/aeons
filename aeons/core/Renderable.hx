package aeons.core;

import aeons.math.Rect;
import aeons.graphics.RenderTarget;

interface Renderable {
  var bounds: Rect;

  function render(target: RenderTarget): Void;
}