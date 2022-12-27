package aeons.core;

import aeons.components.CDebugRender;
import aeons.components.CRender;
import aeons.components.CUpdate;
import aeons.core.Renderable;
import aeons.core.Updatable;
import aeons.core.services.InternalEntities;
import aeons.events.services.InternalEvents;
import aeons.graphics.RenderTarget;
import aeons.math.Rect;

import buddy.BuddySuite;

using buddy.Should;

class EntitiesTest extends BuddySuite {
  public function new() {
    describe('aeons.core.Entities Tests', {
      beforeEach({
        Aeons.provideEntities(new InternalEntities());
        Aeons.provideEvents(new InternalEvents());
        Aeons.events.pushSceneList();
      });

      it('Should add an entity.', {
        final entity = Aeons.entities.addEntity(Entity);
        entity.should.not.be(null);
        entity.should.beType(Entity);
        entity.id.should.be(0);

        final entity2 = Aeons.entities.addEntity(Entity);
        entity2.id.should.be(1);
      });

      it('Should get an entity.', {
        final entity = Aeons.entities.addEntity(Entity);

        final e: Entity = Aeons.entities.getEntityById(entity.id);
        e.should.be(entity);
      });

      it('Should get an entity by id.', {
        Aeons.entities.addEntity(Entity);
        final entity = Aeons.entities.addEntity(Entity);
        entity.id.should.be(1);
        final e: Entity = Aeons.entities.getEntityById(1);
        e.should.be(entity);
      });

      it('Should remove an entity.', {
        var entity = Aeons.entities.addEntity(Entity);
        final id = entity.id;

        var e: Entity = Aeons.entities.getEntityById(id);
        entity.should.be(e);

        Aeons.entities.removeEntity(entity);
        Aeons.entities.updateRemoved();
        e = Aeons.entities.getEntityById(id);
        e.should.be(null);
        entity.id.should.be(-1);

        entity = Aeons.entities.addEntity(Entity);
        entity.id.should.be(0);
      });

      it('Should add a component to an entity.', {
        var entity = Aeons.entities.addEntity(Entity);
        var comp = Aeons.entities.addComponent(entity, TestComponent).create(2);

        comp.entityId.should.be(entity.id);
        comp.test.should.be(2);
        comp.test2.should.be(5);
      });

      it('Should get a component.', {
        var entity = Aeons.entities.addEntity(Entity);
        var comp = Aeons.entities.addComponent(entity, TestComponent).create(2);

        var getComp = Aeons.entities.getComponent(entity.id, TestComponent);
        getComp.should.be(comp);

        Aeons.entities.getComponent.bind(entity.id, TestUpdateComponent)
          .should.throwValue('Component aeons.core._EntitiesTest.TestUpdateComponent does not exist on entity with id 0.');
      });

      it('Should check if an entity has a components.', {
        var entity = Aeons.entities.addEntity(Entity);
        Aeons.entities.addComponent(entity, TestComponent).create(2);

        Aeons.entities.hasComponent(entity.id, TestComponent).should.be(true);
        Aeons.entities.hasComponent(entity.id, TestUpdateComponent).should.be(false);
      });

      it('Should check if an entity has a list of components.', {
        var entity = Aeons.entities.addEntity(Entity);
        Aeons.entities.addComponent(entity, TestComponent).create(2);
        Aeons.entities.addComponent(entity, TestUpdateComponent).create();

        Aeons.entities.hasComponents(entity.id, [TestComponent, TestUpdateComponent]).should.be(true);
        Aeons.entities.hasComponents(entity.id, [TestComponent, TestUpdateComponent, TestRenderComponent])
          .should.be(false);
      });

      it('Should remove a component from an entity.', {
        var entity = Aeons.entities.addEntity(Entity);
        Aeons.entities.addComponent(entity, TestComponent).create(2);

        Aeons.entities.hasComponent(entity.id, TestComponent).should.be(true);

        Aeons.entities.removeComponent(entity, TestComponent);
        Aeons.entities.updateRemoved();

        Aeons.entities.hasComponent(entity.id, TestComponent).should.be(false);
      });

      it('Should automatically add an update component.', {
        var entity = Aeons.entities.addEntity(Entity);
        Aeons.entities.addComponent(entity, TestUpdateComponent).create();

        Aeons.entities.hasComponent(entity.id, CUpdate).should.be(true);
      });

      it('Should automatically add a render component.', {
        var entity = Aeons.entities.addEntity(Entity);
        Aeons.entities.addComponent(entity, TestRenderComponent).create();

        Aeons.entities.hasComponent(entity.id, CRender).should.be(true);
      });

      it('Should automatically add a debug render component.', {
        var entity = Aeons.entities.addEntity(Entity);
        Aeons.entities.addComponent(entity, TestDebugRenderComponent).create();

        Aeons.entities.hasComponent(entity.id, CDebugRender).should.be(true);
      });

      it('Should get all updatable components.', {
        var entity = Aeons.entities.addEntity(Entity);
        Aeons.entities.addComponent(entity, TestComponent).create(2);
        Aeons.entities.addComponent(entity, TestUpdateComponent).create();
        Aeons.entities.addComponent(entity, TestUpdateComponent2).create();

        Aeons.entities.getUpdateComponents(entity.id).length.should.be(2);
      });

      it('Should get all renderable components.', {
        var entity = Aeons.entities.addEntity(Entity);
        Aeons.entities.addComponent(entity, TestComponent).create(2);
        Aeons.entities.addComponent(entity, TestRenderComponent).create();
        Aeons.entities.addComponent(entity, TestRenderComponent2).create();

        Aeons.entities.getRenderComponents(entity.id).length.should.be(2);
      });

      it('Should get all debug renderable components.', {
        var entity = Aeons.entities.addEntity(Entity);
        Aeons.entities.addComponent(entity, TestComponent).create(2);
        Aeons.entities.addComponent(entity, TestDebugRenderComponent).create();
        Aeons.entities.addComponent(entity, TestDebugRenderComponent2).create();

        Aeons.entities.getDebugRenderComponents(entity.id).length.should.be(2);
      });

      it('Should check if an entity has a list of bundle components.', {
        var entity = Aeons.entities.addEntity(Entity);
        Aeons.entities.addComponent(entity, TestComponent).create(2);
        Aeons.entities.addComponent(entity, TestRenderComponent).create();

        Aeons.entities.hasBundleComponents(entity.id, [
          'aeons.core._EntitiesTest.TestComponent',
          'aeons.core._EntitiesTest.TestRenderComponent'
        ]).should.be(true);

        Aeons.entities.hasBundleComponents(entity.id, [
          'aeons.core._EntitiesTest.TestComponent',
          'aeons.core._EntitiesTest.TestRenderComponent',
          'aeons.core._EntitiesTest.TestUpdateComponent'
        ]).should.be(false);
      });

      it('Should get all components for an entity', {
        var entity = Aeons.entities.addEntity(Entity);

        Aeons.entities.getAllComponentsForEntity(entity.id).length.should.be(0);

        Aeons.entities.addComponent(entity, TestComponent).create(2);
        Aeons.entities.addComponent(entity, TestRenderComponent).create();

        // 3 Because it also has a CRender component.
        Aeons.entities.getAllComponentsForEntity(entity.id).length.should.be(3);
      });
    });
  }
}

private class TestComponent extends Component {
  public var test: Int;

  public var test2: Int;

  public var cleaned = false;

  public function create(test: Int): TestComponent {
    this.test = test;
    test2 = 5;

    return this;
  }

  public override function cleanup() {
    super.cleanup();
    cleaned = true;
  }
}

private class TestUpdateComponent extends Component implements Updatable {
  public function create(): TestUpdateComponent {
    return this;
  }

  public function update(dt: Float) {}
}

private class TestUpdateComponent2 extends Component implements Updatable {
  public function create(): TestUpdateComponent2 {
    return this;
  }

  public function update(dt: Float) {}
}

private class TestRenderComponent extends Component implements Renderable {
  public function create(): TestRenderComponent {
    return this;
  }

  public function render(target: RenderTarget) {}

  public function inCameraBounds(bounds: Rect): Bool {
    return true;
  }
}

private class TestRenderComponent2 extends Component implements Renderable {
  public function create(): TestRenderComponent2 {
    return this;
  }

  public function render(target: RenderTarget) {}

  public function inCameraBounds(bounds: Rect): Bool {
    return true;
  }
}

private class TestDebugRenderComponent extends Component implements DebugRenderable {
  public var debugDrawEnabled = true;

  public function create(): TestDebugRenderComponent {
    return this;
  }

  public function debugRender(target: RenderTarget) {}
}

private class TestDebugRenderComponent2 extends Component implements DebugRenderable {
  public var debugDrawEnabled = true;

  public function create(): TestDebugRenderComponent2 {
    return this;
  }

  public function debugRender(target: RenderTarget) {}
}
