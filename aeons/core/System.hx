package aeons.core;

/**
 * The system base class for ECS.
 */
@:autoBuild(aeons.core.Macros.buildSystem())
class System {
  public function new() {
    // TODO: Make it possible to add systems after entities have been added.
  }

  public function init() {}

  /**
   * Clean up variables after the scene gets removed.
   */
  public function cleanup() {}

}