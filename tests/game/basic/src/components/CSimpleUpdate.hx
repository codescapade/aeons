package components;

import aeons.core.Updatable;
import aeons.core.Component;

class CSimpleUpdate extends Component implements Updatable {

  var sometext: String;

  public function new() {
    super();
    sometext = 'Let\'s show this';
  }

  public function update(dt: Float) {
    trace(sometext);
  }
}