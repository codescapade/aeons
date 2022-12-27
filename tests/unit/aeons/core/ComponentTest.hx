package aeons.core;

import aeons.components.CRender;
import aeons.core.services.InternalEntities;
import aeons.events.services.InternalEvents;

import buddy.BuddySuite;

using buddy.Should;

class ComponentTest extends BuddySuite {
  var entity: Entity;

  var component: Component;

  public function new() {
    describe('aeons.core.Component Tests.', {
      beforeEach({
        Aeons.provideEntities(new InternalEntities());
        Aeons.provideEvents(new InternalEvents());
        Aeons.events.pushSceneList();

        entity = Aeons.entities.addEntity(Entity);
      });

      it('Should check for required components.', {
        entity.addComponent.bind(TestComponent2)
          .should.throwValue('Entity 0 is missing a required aeons.core._ComponentTest.TestComponent component.');

        entity.addComponent(TestComponent).create();
        entity.addComponent.bind(TestComponent2).should.not.throwAnything();
      });

      it('Should cleanup the entity id', {
        var comp = entity.addComponent(TestComponent).create();
        comp.entityId.should.be(0);

        comp.cleanup();
        comp.entityId.should.be(-1);
      });
      it('Should get a component.', {
        var comp1 = entity.addComponent(TestComponent).create();
        var comp2 = entity.addComponent(TestComponent2).create();

        comp2.getComponent(TestComponent).should.be(comp1);
      });

      it('Should check if the parent entity has a component.', {
        var comp = entity.addComponent(TestComponent).create();

        comp.hasComponent(TestComponent).should.be(true);
        comp.hasComponent(TestComponent2).should.be(false);
      });

      it('Should check if the parent entity has a list of components.', {
        var comp = entity.addComponent(TestComponent).create();
        entity.addComponent(TestComponent2).create();

        comp.hasComponents([TestComponent, TestComponent2]).should.be(true);
        comp.hasComponents([TestComponent, TestComponent2, CRender]).should.be(false);
      });
    });
  }
}

private class TestComponent extends Component {
  public function create(): TestComponent {
    return this;
  }
}

private class TestComponent2 extends Component {
  public function create(): TestComponent2 {
    return this;
  }

  override function get_requiredComponents(): Array<Class<Component>> {
    return [TestComponent];
  }
}
