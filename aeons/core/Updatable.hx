package aeons.core;

/**
 * Interface for components and systems that need to be updated when the scene updates.
 */
interface Updatable {
  /**
   * Called every update.
   * @param dt The time passed since the last update in seconds.
   */
  function update(dt: Float): Void;
}