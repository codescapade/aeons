package aeons.core.services;

/**
 * `NullDisplay` is an empty implementation of Display to keep
 * the engine from crashing when no display manager is set.
 */
class NullDisplay implements Display {

  public var viewWidth(default, null): Int;

  public var viewHeight(default, null): Int;

  public var windowWidth(get, never): Int;

  public var windowHeight(get, never): Int;

  public var viewCenterX(get, never): Int;

  public var viewCenterY(get, never): Int;

  public var windowCenterX(get, never): Int;

  public var windowCenterY(get, never): Int;

  /**
   * Constructor.
   */
  public function new() {}

	public function init(designWidth: Int, designHeight: Int) {
    trace('init is not implemented');
  }

  public function scaleToWindow() {
    trace('scaleToWindow is not implemented');
  }

  inline function get_windowWidth(): Int {
    trace('windowWidth is not implemented');

    return 0;
  }

  inline function get_windowHeight(): Int {
    trace('windowHeight is not implemented');

    return 0;
  }

  inline function get_viewCenterX(): Int {
    trace('viewCenterX is not implemented');

    return 0;
  }

  inline function get_viewCenterY(): Int {
    trace('viewCenterY is not implemented');

    return 0;
  }

  inline function get_windowCenterX(): Int {
    trace('windowCenterX is not implemented');

    return 0;
  }

  inline function get_windowCenterY(): Int {
    trace('windowCenterY is not implemented');

    return 0;
  }
}