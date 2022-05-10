package aeons.core.services;

import kha.System;

/**
 * InternalDisplay is the main Display implementation.
 */
@:dox(hide)
class InternalDisplay implements Display {
  public var viewWidth(default, null): Int;

  public var viewHeight(default, null): Int;

  public var windowWidth(get, never): Int;

  public var windowHeight(get, never): Int;

  public var viewCenterX(get, never): Int;

  public var viewCenterY(get, never): Int;

  public var windowCenterX(get, never): Int;

  public var windowCenterY(get, never): Int;

  public var pixelArt: Bool;

  /**
   * The width the art is designed for in pixels.
   */
  var designWidth: Int;

  /**
   * The height the art is designed for in pixels.
   */
  var designHeight: Int;

  /**
   * Constructor.
   */
  public function new() {}

  public function init(designWidth: Int, designHeight: Int, pixelArt: Bool) {
    this.designWidth = designWidth;
    this.designHeight = designHeight;
    this.pixelArt = pixelArt;
  }

  public function scaleToWindow() {
    final designRatio = designWidth / designHeight;
    final windowRatio = windowWidth / windowHeight;

    if (windowRatio < designRatio) {
      viewWidth = designWidth;
      viewHeight = Math.ceil(viewWidth / windowRatio);
    } else {
      viewHeight = designHeight;
      viewWidth = Math.ceil(viewHeight * windowRatio);
    }
  }

  inline function get_windowWidth(): Int {
    return System.windowWidth();
  }

  inline function get_windowHeight(): Int {
    return System.windowHeight();
  }

  inline function get_viewCenterX(): Int {
    return Std.int(viewWidth * 0.5);
  }

  inline function get_viewCenterY(): Int {
    return Std.int(viewHeight * 0.5);
  }

  inline function get_windowCenterX(): Int {
    return Std.int(windowWidth * 0.5);
  }

  inline function get_windowCenterY(): Int {
    return Std.int(windowHeight * 0.5);
  }
}
