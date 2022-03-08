package aeons.core;

import aeons.math.Rect;
import aeons.graphics.RenderTarget;

/**
 * Interface for components that need to be rendered every frame.
 */
interface Renderable {
  /**
   * The visual bounds
   */
  var bounds: Rect;

  /**
   * The x anchor. Should be between 0 and 1.
   */
  var anchorX: Float;

  /**
   * The y anchor. Should between 0 and 1.
   */
  var anchorY: Float;

  /**
   * Gets called every frame.
   * @param target The target image to render to.
   * @param cameraBounds Used to render only what the camera can see.
   */
  function render(target: RenderTarget, cameraBounds: Rect): Void;
}