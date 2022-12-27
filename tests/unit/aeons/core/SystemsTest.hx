package aeons.core;

import aeons.core.services.InternalSystems;
import aeons.graphics.RenderTarget;

import buddy.BuddySuite;

using buddy.Should;

class SystemsTest extends BuddySuite {
  public function new() {
    describe('aeons.core.Systems Tests', {
      beforeEach({
        Aeons.provideSystems(new InternalSystems());
      });

      it('Should add a System.', {
        final system = Aeons.systems.add(TestSystem).create(8);
        system.should.not.be(null);
        system.testValue.should.be(8);
      });

      it('Should order update systems as added without priority', {
        var compareList = [1, 2];
        var list: Array<Int> = [];
        Aeons.systems.add(TestSystemOne).create(list);
        Aeons.systems.add(TestSystemTwo).create(list);
        Aeons.systems.update(0);
        compareArrays(list, compareList).should.be(true);
      });

      it('Should order update systems with priority', {
        var compareList = [2, 1];
        var list: Array<Int> = [];
        Aeons.systems.add(TestSystemOne).create(list);
        Aeons.systems.add(TestSystemTwo, 1).create(list);
        Aeons.systems.update(0);
        compareArrays(list, compareList).should.be(true);
      });

      it('Should order render systems as added without priority', {
        var compareList = [1, 2];
        var list: Array<Int> = [];
        Aeons.systems.add(TestSystemOne).create(list);
        Aeons.systems.add(TestSystemTwo).create(list);
        Aeons.systems.render(null);
        compareArrays(list, compareList).should.be(true);
      });

      it('Should order render systems with priority', {
        var compareList = [2, 1];
        var list: Array<Int> = [];
        Aeons.systems.add(TestSystemOne).create(list);
        Aeons.systems.add(TestSystemTwo, 1).create(list);
        Aeons.systems.render(null);
        compareArrays(list, compareList).should.be(true);
      });

      it('Should order debug render systems as added without priority', {
        var compareList = [1, 2];
        var list: Array<Int> = [];
        Aeons.systems.add(TestSystemOne).create(list);
        Aeons.systems.add(TestSystemTwo).create(list);

        var dbrSystems = Aeons.systems.getDebugRenderSystems();
        for (sys in dbrSystems) {
          sys.debugRender(null);
        }
        compareArrays(list, compareList).should.be(true);
      });

      it('Should order debug render systems with priority', {
        var compareList = [2, 1];
        var list: Array<Int> = [];
        Aeons.systems.add(TestSystemOne).create(list);
        Aeons.systems.add(TestSystemTwo, 1).create(list);

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

private class TestSystem extends System {
  public var testValue: Int;

  public function create(value: Int): TestSystem {
    testValue = value;

    return this;
  }
}

private class TestSystemOne extends System implements Updatable implements SysRenderable implements DebugRenderable {
  public var debugDrawEnabled = false;

  var updateList: Array<Int>;

  public function create(updateList: Array<Int>): TestSystemOne {
    this.updateList = updateList;

    return this;
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

private class TestSystemTwo extends System implements Updatable implements SysRenderable implements DebugRenderable {
  public var debugDrawEnabled = false;

  var updateList: Array<Int>;

  public function create(updateList: Array<Int>): TestSystemTwo {
    this.updateList = updateList;

    return this;
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
