package aeons.core;

import aeons.core.services.InternalEntities;
import buddy.BuddySuite;

using buddy.Should;

class EntityTest extends BuddySuite {

  public function new() {
    describe('aeons.core.Entity Tests', {

      beforeEach({
        Aeons.provideEntities(new InternalEntities());
      });

      it('Should initialize an entity.');
      it('Should add a component.');
      it('Should remove a component.');
      it('Should get a component.');
      it('Should check if an entity has a component.');
      it('Should check if an entity has a list of components.');
      it('Should check if an entity has a list of bundle components.');
      it('Should clean up an entity.');
      it('Should change active on all components.');
    });
  }
}