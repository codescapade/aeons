package aeons.core;

import kha.System;

/**
 * The `Display` class has view and window size properties.
 */
class Display {
  /**
   * The game view width in pixels.
   */
  public var viewWidth(default, null): Int;

  /**
   * The game view height in pixels.
   */
  public var viewHeight(default, null): Int;

  /**
   * The window width in pixels.
   */
  public var windowWidth(get, never): Int;

  /**
   * The window height in pixels.
   */
  public var windowHeight(get, never): Int;

  /**
   * The view center on the x axis.
   */
  public var viewCenterX(get, never): Int;

  /**
   * The view center on the y axis.
   */
  public var viewCenterY(get, never): Int;

  /**
   * The window center on the x axis.
   */
  public var windowCenterX(get, never): Int;

  /**
   * The window center on the x axis.
   */
  public var windowCenterY(get, never): Int;

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
   * @param designWidth The resolution width the game is designed for in pixels.
   * @param designHeight The resolution height the game is designed for in pixels.
   */
  public function new(designWidth: Int, designHeight: Int) {
    this.designWidth = designWidth;
    this.designHeight = designHeight;
  }

  /**
   * Scale the view size to fit the window size.
   * Need to add more scale modes.
   */
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

  /**
   * Window width getter.
   */
  inline function get_windowWidth(): Int {
    return System.windowWidth();
  }

  /**
   * Window height getter.
   */
  inline function get_windowHeight(): Int {
    return System.windowHeight();
  }

  /**
   * View center x getter.
   */
  inline function get_viewCenterX(): Int {
    return Std.int(viewWidth * 0.5);
  }

  /**
   * View center y getter.
   */
  inline function get_viewCenterY(): Int {
    return Std.int(viewHeight * 0.5);
  }

  /**
   * Window center x getter.
   */
  inline function get_windowCenterX(): Int {
    return Std.int(windowWidth * 0.5);
  }

  /**
   * Window center y getter.
   */
  inline function get_windowCenterY(): Int {
    return Std.int(windowHeight * 0.5);
  }
}