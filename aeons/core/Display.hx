package aeons.core;

/**
 * The Display manager has view and window size properties.
 */
interface Display {
  /**
   * The width the game is designed for in pixels.
   */
  var designWidth(default, null): Int;

  /**
   * The height the game is designed for in pixels.
   */
  var designHeight(default, null): Int;

  /**
   * The game view width in pixels.
   */
  var viewWidth(default, null): Int;

  /**
   * The game view height in pixels.
   */
  var viewHeight(default, null): Int;

  /**
   * The window width in pixels.
   */
  var windowWidth(get, never): Int;

  /**
   * The window height in pixels.
   */
  var windowHeight(get, never): Int;

  /**
   * The view center on the x axis.
   */
  var viewCenterX(get, never): Int;

  /**
   * The view center on the y axis.
   */
  var viewCenterY(get, never): Int;

  /**
   * The window center on the x axis.
   */
  var windowCenterX(get, never): Int;

  /**
   * The window center on the x axis.
   */
  var windowCenterY(get, never): Int;

  /**
   * When enabled everything will be rendered using nearest neighbour filtering.
   */
  var pixelArt: Bool;

  /**
   * Initialize the display.
   * @param designWidth The resolution width the game is designed for in pixels.
   * @param designHeight The resolution height the game is designed for in pixels.
   * @param pixelArt Enable optimized rendering for pixel art.
   */
  function init(designWidth: Int, designHeight: Int, pixelArt: Bool): Void;

  /**
   * Scale the view size to fit the window size.
   * Need to add more scale modes.
   */
  function scaleToWindow(): Void;
}
