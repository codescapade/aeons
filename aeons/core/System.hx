package aeons.core;

/**
 * The system base class for ECS.
 */
@:autoBuild(aeons.core.Macros.buildSystem())
class System {
  public function new() {}

  public function init() {}

  /**
   * Clean up variables after the scene gets removed.
   */
  public function cleanup() {}

}