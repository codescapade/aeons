package components;

import aeons.core.Component;

class CRotate extends Component {

  public var speed: Float;

  public function init(options: CRotateOptions): CRotate {
    speed = options.speed;

    return this;
  }
}

typedef CRotateOptions = {
  var speed: Float;
}