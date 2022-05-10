package aeons.core;

import aeons.core.services.InternalEntities;

import buddy.BuddySuite;

using buddy.Should;

class EntitiesTest extends BuddySuite {
  public function new() {
    describe('aeons.core.Entities Tests', {
      beforeEach({
        Aeons.provideEntities(new InternalEntities());
      });

      it('Should add an entity.', {
        final entity = Aeons.entities.addEntity(new Entity());
        entity.id.should.be(0);
      });

      it('Should get an entity.', {
        final entity = Aeons.entities.addEntity(new Entity());

        final e: Entity = Aeons.entities.getEntityById(entity.id);
        e.should.be(entity);
      });

      it('Shound get an entity by id.', {
        Aeons.entities.addEntity(new Entity());
        final entity = Aeons.entities.addEntity(new Entity());
        entity.id.should.be(1);
        final e: Entity = Aeons.entities.getEntityById(1);
        e.should.be(entity);
      });

      it('Should remove an entity.', {
        final entity = Aeons.entities.addEntity(new Entity());
        final id = entity.id;

        var e: Entity = Aeons.entities.getEntityById(id);
        entity.should.be(e);

        Aeons.entities.removeEntity(entity);
        Aeons.entities.updateAddRemove();
        e = Aeons.entities.getEntityById(id);
        e.should.be(null);
        entity.id.should.be(-1);
      });

      it('Should add a component to an entity.', {
        var entity = Aeons.entities.addEntity(new Entity());
        var comp = Aeons.entities.addComponent(entity, new TestComponent(2));
        Aeons.entities.updateAddRemove();

        comp.entityId.should.be(entity.id);
        comp.test.should.be(2);
        comp.test2.should.be(5);
      });

      it('Should get a component.');
      it('Should remove a component from an entity.');
      it('Should reuse a component.');
      it('Should automatically add an update component.');
      it('Should automatically add a render component.');
      it('Should be all updatable components.');
      it('Should get all renderable components.');
      it('Should check if an entity has a components.');
      it('Should check if an entity has a list of components.');
      it('Should check if an entity has a list of bundle components.');
      it('Should get all components for an entity');
    });
  }
}

class TestComponent extends Component {
  public var test: Int;

  public var test2: Int;

  public var cleaned = false;

  public function new(test: Int) {
    super();
    this.test = test;
  }

  public override function init(entityId: Int) {
    super.init(entityId);
    test2 = 5;
  }

  public override function cleanup() {
    super.cleanup();
    cleaned = true;
  }
}
