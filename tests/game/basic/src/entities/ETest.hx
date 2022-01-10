package entities;

import aeons.core.Entity;

class ETest extends Entity {

  public var test: String;

  public function init(): ETest {
    test = 'testing';

    return this;
  }
}