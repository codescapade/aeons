package components;

import aeons.core.Component;

class CRotate extends Component {

  public var speed: Float;

  public function new(options: CRotateOptions) {
    super();
    speed = options.speed;
  }
}

typedef CRotateOptions = {
  var speed: Float;
}
