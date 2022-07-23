package aeons.core;

/**
 * The system base class for ECS.
 */
@:autoBuild(aeons.core.Macros.buildSystem())
class System {
  /**
   * Call priority for render and update systems. Higher gets called first.
   */
  public var priority(default, set): Int;

  public function new() {}

  /**
   * Here you can initialize the system.
   */
  public function init() {}

  /**
   * Clean up variables when the system gets removed.
   */
  public function cleanup() {}

  /**
   * Add a system to the scene. Throws an error if the system type has already been added.
   * @param systemType The type of system to add.
   * @param priority The priority for render / update systems. Higher gets called first.
   * @return The newly created system
   */
  public inline function addSystem<T: System>(system: T, priority = 0): T {
    return Aeons.systems.add(system, priority);
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

  function set_priority(value: Int): Int {
    priority = value;
    Aeons.systems.sort();

    return value;
  }
}
