package aeons.core;

import aeons.core.services.InternalEntities;
import buddy.BuddySuite;

class ComponentTest extends BuddySuite {

  public function new() {
    describe('aeons.core.Component Tests.', {

      beforeEach({
        Aeons.provideEntities(new InternalEntities());
      });

      it('Should check for required components.');
      it('Should cleanup the entity id');
      it('Should get a component.');
      it('Should check if the parent entity has a component.');
      it('Should check if the parent entity has a list of components.');
    });
  }
}
