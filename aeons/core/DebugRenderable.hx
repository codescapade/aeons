package aeons.core;

import aeons.graphics.RenderTarget;
import aeons.math.Rect;

/**
 * Interface to use debug drawing in components or systems.
 */
interface DebugRenderable {
  /**
   * Is debug drawing enabled for this component. Usefull to only show certain component types or indiviual components.
   */
  var debugDrawEnabled: Bool;

  /**
   * Render the debug view.
   * @param target The target to render to.
   * @param cameraBounds The camera bounds if you don't want to render items outside of the camera.
   */
  function debugRender(target: RenderTarget, cameraBounds: Rect): Void;
}