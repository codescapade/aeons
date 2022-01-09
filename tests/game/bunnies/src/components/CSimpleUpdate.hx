package components;

import aeons.core.Updatable;
import aeons.core.Component;

class CSimpleUpdate extends Component implements Updatable {

  var sometext: String;

  public function init(): CSimpleUpdate {
    sometext = 'Let\'s show this';

    return this;
  }

  public function update(dt: Float) {
    trace(sometext);
  }
}