package aeons.core;

import aeons.graphics.RenderTarget;

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
   */
  function debugRender(target: RenderTarget): Void;
}
