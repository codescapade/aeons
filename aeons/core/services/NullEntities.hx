package aeons.core.services;

class NullEntities implements Entities {

  public function new() {}

  public function addEntity<T: Entity>(entityType: Class<T>): T {
    trace('addEntity is not implemented');

    return null;
  }

	public function removeEntity(entity: Entity): Void {
    trace('removeEntity is not implemented');
	}

	public function getEntityById<T: Entity>(id: Int): T {
    trace('getEntitybyId is not implemented');

    return null;
	}

	public function removeEntityById(id: Int): Void {
    trace('removeEntityById is not implemented');
  }

	public function addComponent<T: Component>(entity: Entity, componentType: Class<T>): T {
    trace('addComponent is not implemented');

    return null;
	}

	public function removeComponent(entity: Entity, componentType: Class<Component>): Void {
    trace('removeComponent is not implemented');
	}

	public function getComponent<T: Component>(entityId: Int, componentType: Class<T>): T {
    trace('getComponent is not implemented');

    return null;
	}

	public function getUpdateComponents(entityId: Int): Array<Updatable> {
    trace('getUpdateComponents is not implemented');

    return [];
	}

	public function getRenderComponents(entityId: Int): Array<Renderable> {
    trace('getRenderComponents is not implemented');

    return [];
	}

	public function hasComponent(entityId: Int, componentType: Class<Component>): Bool {
    trace('hasComponent is not implemented');

    return false;
	}

	public function hasComponents(entityId: Int, componentTypes: Array<Class<Component>>): Bool {
    trace('hasComponents is not implemented');

    return false;
	}

	public function hasBundleComponents(entityId: Int, componentNames: Array<String>): Bool {
    trace('hasBundleComponents is not implemented');

    return false;
	}

	public function getAllComponentsForEntity(entityId: Int): Array<Component> {
    trace('getAllComponentsForEntity is not implemented');

    return [];
	}

	public function cleanup(): Void {
    trace('cleanup is not implemented');
	}

  public function updateAddRemove(): Void {
    trace('updateAddRemove is not implemented');
  }
}