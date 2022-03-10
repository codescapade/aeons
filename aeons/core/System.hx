package aeons.core;

/**
 * The system base class for ECS.
 */
@:autoBuild(aeons.core.Macros.buildSystem())
class System {

  /**
   * Clean up variables after the scene gets removed.
   */
  public function cleanup() {}

  function new() {
    // TODO: Make it possible to add systems after entities have been added.
  }
}