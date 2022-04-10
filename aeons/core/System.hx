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

  /**
   * Add a system to the scene. Throws an error if the system type has already been added.
   * @param systemType The type of system to add.
   * @return The newly created system
   */
  public inline function addSystem<T: System>(system: T): T {
    return Aeons.systems.add(system);
  }

  /**
   * Remove a system from the scene.
   * @param systemType The type of system to remove.
   */
  public inline function removeSystem(systemType: Class<System>) {
    Aeons.systems.remove(systemType);
  }

  /**
   * Get a system using its type.
   * @param systemType The type of system you want to get a reference from.
   * @return The system if it exists. Otherwise null.
   */
  public inline function getSystem<T: System>(systemType: Class<T>): T {
    return Aeons.systems.get(systemType);
  }

  /**
   * Check if a system has been added.
   * @param systemType The type of system you want to check for.
   * @return True is the system was found.
   */
  public inline function hasSystem(systemType: Class<System>): Bool {
    return Aeons.systems.has(systemType);
  }
}
