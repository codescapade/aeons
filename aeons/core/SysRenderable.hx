package aeons.core;

import aeons.graphics.RenderTarget;
import aeons.math.Rect;

/**
 * Interface for systems that need to be rendered every frame.
 */
interface SysRenderable {
  /**
   * Gets called every frame.
   * @param target The target to render to.
   * @param cameraBounds Used the render only what the camera can see.
   */
  function render(target: RenderTarget, ?cameraBounds: Rect): Void;
}