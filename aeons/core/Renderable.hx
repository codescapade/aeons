package aeons.core;

import aeons.graphics.RenderTarget;
import aeons.math.Rect;

/**
 * Interface for components that need to be rendered every frame.
 */
interface Renderable {
  /**
   * Gets called every frame.
   * @param target The target image to render to.
   */
  function render(target: RenderTarget): Void;

  /**
   * Check if the component is inside the camera bounds and should be rendered.
   * @param cameraBounds Used to render only what the camera can see.
   * The bounds are in the local space of the component.
   * @return True if in bounds. Out of bounds will not render using the RenderSystem.
   */
  function inCameraBounds(cameraBounds: Rect): Bool;
}
