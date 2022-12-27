package aeons.core;

import aeons.components.CRender;
import aeons.core.services.InternalEntities;
import aeons.events.services.InternalEvents;

import buddy.BuddySuite;

using buddy.Should;

class EntityTest extends BuddySuite {
  var entity: Entity;

  public function new() {
    describe('aeons.core.Entity Tests', {
      beforeEach({
        Aeons.provideEntities(new InternalEntities());
        Aeons.provideEvents(new InternalEvents());
        Aeons.events.pushSceneList();

        entity = Aeons.entities.addEntity(Entity);
      });

      it('Should add a component.', {
        var comp = entity.addComponent(TestComponent).create(2);

        comp.entityId.should.be(entity.id);
        comp.test.should.be(2);
        comp.test2.should.be(5);
      });

      it('Should get a component.', {
        var comp = entity.addComponent(TestComponent).create(2);

        var getComp = entity.getComponent(TestComponent);
        getComp.should.be(comp);

        entity.getComponent.bind(TestComponent2)
          .should.throwValue('Component aeons.core._EntityTest.TestComponent2 does not exist on entity with id 0.');
      });

      it('Should check if an entity has a component.', {
        entity.addComponent(TestComponent).create(2);

        entity.hasComponent(TestComponent).should.be(true);
        entity.hasComponent(TestComponent2).should.be(false);
      });

      it('Should check if an entity has a list of components.', {
        entity.addComponent(TestComponent).create(2);
        entity.addComponent(TestComponent2).create();

        entity.hasComponents([TestComponent, TestComponent2]).should.be(true);
        entity.hasComponents([TestComponent, TestComponent2, CRender]).should.be(false);
      });

      it('Should remove a component.', {
        entity.addComponent(TestComponent).create(2);

        entity.hasComponent(TestComponent).should.be(true);

        entity.removeComponent(TestComponent);
        Aeons.entities.updateRemoved();

        entity.hasComponent(TestComponent).should.be(false);
      });

      it('Should check if an entity has a list of bundle components.', {
        entity.addComponent(TestComponent).create(2);
        entity.addComponent(TestComponent2).create();

        entity.hasBundleComponents(['aeons.core._EntityTest.TestComponent', 'aeons.core._EntityTest.TestComponent2'])
          .should.be(true);

        entity.hasBundleComponents([
          'aeons.core._EntityTest.TestComponent',
          'aeons.core._EntityTest.TestComponent2',
          'aeons.components.CRender'
        ]).should.be(false);
      });

      it('Should clean up an entity.', {
        entity.cleanup();
        entity.id.should.be(-1);
      });

      it('Should change active on all components.', {
        var comp = entity.addComponent(TestComponent).create(2);
        comp.active.should.be(true);

        entity.active = false;
        comp.active.should.be(false);

        entity.active = true;
        comp.active.should.be(true);
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

private class TestComponent2 extends Component {
  public function create(): TestComponent2 {
    return this;
  }
}
