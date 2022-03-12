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

  function update(dt: Float): Void;

  function render(target: RenderTarget, ?cameraBounds: Rect): Void;
}