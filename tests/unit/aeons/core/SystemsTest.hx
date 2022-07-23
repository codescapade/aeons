package aeons.core;

import aeons.graphics.RenderTarget;
import aeons.core.services.InternalSystems;
import buddy.BuddySuite;

using buddy.Should;

class SystemsTest extends BuddySuite {
  public function new() {
    describe('aeons.core.Systems Tests', {
      beforeEach({
        Aeons.provideSystems(new InternalSystems());
      });

      it('Should add a System.', {
        final system = Aeons.systems.add(new TestSystem(8));
        system.should.not.be(null);
        system.testValue.should.be(8);
      });

      it('Should order update systems as added without priority', {
        var compareList = [1, 2];
        var list: Array<Int> = [];
        Aeons.systems.add(new TestSystemOne(list));
        Aeons.systems.add(new TestSystemTwo(list));
        Aeons.systems.update(0);
        compareArrays(list, compareList).should.be(true);
      });

      it('Should order update systems with priority', {
        var compareList = [2, 1];
        var list: Array<Int> = [];
        Aeons.systems.add(new TestSystemOne(list));
        Aeons.systems.add(new TestSystemTwo(list), 1);
        Aeons.systems.update(0);
        compareArrays(list, compareList).should.be(true);
      });

      it('Should order render systems as added without priority', {
        var compareList = [1, 2];
        var list: Array<Int> = [];
        Aeons.systems.add(new TestSystemOne(list));
        Aeons.systems.add(new TestSystemTwo(list));
        Aeons.systems.render(null);
        compareArrays(list, compareList).should.be(true);
      });

      it('Should order render systems with priority', {
        var compareList = [2, 1];
        var list: Array<Int> = [];
        Aeons.systems.add(new TestSystemOne(list));
        Aeons.systems.add(new TestSystemTwo(list), 1);
        Aeons.systems.render(null);
        compareArrays(list, compareList).should.be(true);
      });

      it('Should order debug render systems as added without priority', {
        var compareList = [1, 2];
        var list: Array<Int> = [];
        Aeons.systems.add(new TestSystemOne(list));
        Aeons.systems.add(new TestSystemTwo(list));

        var dbrSystems = Aeons.systems.getDebugRenderSystems();
        for (sys in dbrSystems) {
          sys.debugRender(null);
        }
        compareArrays(list, compareList).should.be(true);
      });

      it('Should order debug render systems with priority', {
        var compareList = [2, 1];
        var list: Array<Int> = [];
        Aeons.systems.add(new TestSystemOne(list));
        Aeons.systems.add(new TestSystemTwo(list), 1);

        var dbrSystems = Aeons.systems.getDebugRenderSystems();
        for (sys in dbrSystems) {
          sys.debugRender(null);
        }
        compareArrays(list, compareList).should.be(true);
      });
    });
  }

  function compareArrays(first: Array<Int>, second: Array<Int>): Bool {
    if (first.length != second.length) {
      return false;
    }

    for (i => item in first) {
      if (item != second[i]) {
        return false;
      }
    }

    return true;
  }
}


class TestSystem extends System {
  public var testValue: Int;

  public function new(value: Int) {
    super();
    testValue = value;
  }
}

class TestSystemOne extends System implements Updatable implements SysRenderable implements DebugRenderable {
  public var debugDrawEnabled = false;

  var updateList: Array<Int>;
  public function new(updateList: Array<Int>) {
    super();
    this.updateList = updateList;
  }

  public function update(dt: Float) {
    updateList.push(1);
  }

  public function render(target: RenderTarget) {
    updateList.push(1);
  }

  public function debugRender(target: RenderTarget) {
    updateList.push(1);
  }
}

class TestSystemTwo extends System implements Updatable implements SysRenderable implements DebugRenderable {
  public var debugDrawEnabled = false;

  var updateList: Array<Int>;
  public function new(updateList: Array<Int>) {
    super();
    this.updateList = updateList;
  }

  public function update(dt: Float) {
    updateList.push(2);
  }

  public function render(target: RenderTarget) {
    updateList.push(2);
  }

  public function debugRender(target: RenderTarget) {
    updateList.push(2);
  }
}