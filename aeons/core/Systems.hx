package aeons.core;

import aeons.math.Rect;
import aeons.graphics.RenderTarget;

interface Systems {
  /**
   * Add a system to the scene. Throws an error if the system type has already been added.
   * @param systemType The type of system to add.
   * @return The newly created system
   */
  function add<T: System>(system: T): T;

  /**
   * Remove a system from the scene.
   * @param systemType The type of system to remove.
   */
  function remove(systemType: Class<System>): Void;

  /**
   * Get a system using its type.
   * @param systemType The type of system you want to get a reference from.
   * @return The system if it exists. Otherwise null.
   */
  function get<T: System>(systemType: Class<T>): T;

  /**
   * Check if a system has been added.
   * @param systemType The type of system you want to check for.
   * @return True is the system was found.
   */
  function has(systemType: Class<System>): Bool;

  /**
   * Update gets according to the update frequency. This updates all Updatable systems.
   * @param dt The time passing since the last update in seconds.
   */
  function update(dt: Float): Void;

  /**
   * Render gets called every frame. This renders all SysRenderable systems.
   * @param target The target to render to.
   * @param cameraBounds The camera bounds in local space.
   */
  function render(target: RenderTarget, ?cameraBounds: Rect): Void;

  /**
   * Return a list of systems that need to be debug rendered.
   * @return DebugRenderable systems.
   */
  function getDebugRenderSystems(): Array<DebugRenderable>;
}