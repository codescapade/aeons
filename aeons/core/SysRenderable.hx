package aeons.core;

import aeons.graphics.RenderTarget;

/**
 * Interface for systems that need to be rendered every frame.
 */
interface SysRenderable {
  /**
   * Gets called every frame.
   * @param target The target to render to.
   */
  function render(target: RenderTarget): Void;
}