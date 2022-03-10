package aeons.components;

import aeons.Aeons;
import aeons.core.Component;
import aeons.graphics.Color;
import aeons.graphics.RenderTarget;
import aeons.math.AeMath;
import aeons.math.FastMatrix4;
import aeons.math.Rect;
import aeons.math.Vector2;

/**
 * `CCamera` is a component that renders a view in the render system.
 */
class CCamera extends Component {
  /**
   * The main camera in the scene.
   */
  public static var main(default, null): CCamera;

  /**
   * The camera zoom.
   */
  public var zoom = 1.0;

  /**
   * The x position in the window.
   */
  public var viewX = 0;

  /**
   * The y position in the window.
   */
  public var viewY = 0;

  /**
   * The width of the camera view in pixels.
   */
  public var viewWidth(default, set): Int;

  /**
   * The height of the camera view in pixels.
   */
  public var viewHeight(default, set): Int;

  /**
   * The transform matrix.
   */
  public var matrix(default, null): FastMatrix4;

  /**
   * The render texture for this camera.
   */
  // TODO: Don't use a render target for each camera.
  public var renderTarget(default, null): RenderTarget;

  /**
   * The camera background color. Defaults to black.
   */
  public var backgroundColor = Color.Black;

  /**
   * The camera bounds.
   */
  public var bounds(default, null): Rect;

  /**
   * Transform component reference.
   */
  var transform: CTransform;

  /**
   * World position caching.
   */
  var worldPosition = new Vector2();

  /**
   * Temp matrix to help with multiplying translation, rotation, scale in updat3 matrix.
   */
  var tempMatrix: FastMatrix4;

  /**
   * Initialize the camera.
   * @param options Initialization options.
   * @return A reference to the camera.
   */
  public function init(?options: CameraOptions): CCamera {
    if (options == null) {
      viewWidth = Aeons.display.viewWidth;
      viewHeight = Aeons.display.viewHeight;
    } else {
      viewWidth = options.viewWidth == null ? Aeons.display.viewWidth : options.viewWidth;
      viewHeight = options.viewHeight == null ? Aeons.display.viewHeight : options.viewHeight;
      if (options.zoom != null) zoom = options.zoom;
      if (options.viewX != null) viewX = options.viewX;
      if (options.viewY != null) viewY = options.viewY;
      if (options.backgroundColor != null) backgroundColor = options.backgroundColor;
      if (options.isMain) main = this;
    }

    transform = getComponent(CTransform);
    matrix = FastMatrix4.identity();
    bounds = new Rect();
    updateBuffer();
    transform.x = viewWidth * 0.5;
    transform.y = viewHeight * 0.5;
    transform.isCameraTransform = true;
    updateBounds();

    // This is the first camera. Set as main.
    if (main == null) {
      main = this;
    }

    tempMatrix = FastMatrix4.identity();

    return this;
  }

  /**
   * Set this camera component as the main camera.
   */
  public function setAsMain() {
    main = this;
  }

  /**
   * Add a transform as a child so it moves with the camera.
   * @param transform The transform to add.
   */
  public function addChild(transform: CTransform) {
    transform.parent = this.transform;
  }

  /**
   * Remove a transform so it no longer moves with the camera.
   * @param transform The transform to remove.
   */
  public function removeChild(transform: CTransform) {
    transform.parent = null;
  }

  /**
   * Update the matrix. This shouldn't be called multiple times in a frame if possible. It is bad for performance.
   * Used in the `RenderSystem`.
   */
  public function updateMatrix() {
    updateBounds();
    // World position + half width and height to move the center of the camera.
    matrix.setFrom(FastMatrix4.translation(-worldPosition.x + viewWidth, -worldPosition.y + viewHeight, 0)
      // Rotate around the camera center.
      .multmat(FastMatrix4.rotationZ(AeMath.degToRad(transform.getWorldAngle())))
      // Scale from the camera center.
      .multmat(FastMatrix4.scale(zoom, zoom, 1))
      // Move back to top left of camera to get the correct position.
      .multmat(FastMatrix4.translation(-viewWidth * 0.5, -viewHeight * 0.5, 0)));
  }

  /**
   * Convert screen positon to world position.
   * @param x The screen x position in pixels.
   * @param y The sreen y position in pixels.
   * @param out Optional vector to store the result in.
   * @return The world position.
   */
  public function screenToWorld(x: Float, y: Float, ?out: Vector2): Vector2 {
    // TODO: Make this use invert matrix function. At the moment this doesn't work when you rotate the camera.
    final worldX = (worldPosition.x - viewWidth * 0.5 / zoom) + (x / Aeons.display.windowWidth * (viewWidth / zoom));
    final worldY = (worldPosition.y - viewHeight * 0.5 / zoom) + (y / Aeons.display.windowHeight * (viewHeight / zoom));
    if (out == null) {
      out = Vector2.get();
    }

    return out.set(worldX, worldY);
  }

  /**
   * Convert screen position to view position. View position is the game size on screen.
   * @param x The screen x position in pixels.
   * @param y The screen y position in pixels.
   * @param out Optional vector to store the result in.
   * @return The view position.
   */
  public function screenToView(x: Float, y: Float, ?out: Vector2): Vector2 {
    final vX = x / Aeons.display.windowWidth * Aeons.display.viewWidth;
    final vY = y / Aeons.display.windowHeight * Aeons.display.viewHeight;

    if (out == null) {
      out = Vector2.get();
    }

    return out.set(vX, vY);
  }

  /**
   * Clear the current main camera.
   */
  @:allow(aeons.core.Game)
  static function clearMain() {
    main = null;
  }

  /**
   * Update the renderTexture. Used when the window size changes.
   */
  function updateBuffer() {
    if (viewWidth != 0 && viewHeight != 0) {
      renderTarget = new RenderTarget(viewWidth, viewHeight);
    }
  }

  /**
   * Update the camera bounds.
   */
  function updateBounds() {
    transform.getWorldPosition(worldPosition);
    bounds.x = worldPosition.x - viewWidth * 0.5 / zoom;
    bounds.y = worldPosition.y - viewHeight * 0.5 / zoom;
    bounds.width = viewWidth / zoom;
    bounds.height = viewHeight / zoom;
  }

  /**
   * ViewWidth setter.
   * @param value The new view width.
   */
  inline function set_viewWidth(value: Int): Int {
    viewWidth = value;

    return value;
  }

  /**
   * ViewHeight setter.
   * @param value The new view height.
   */
  inline function set_viewHeight(value: Int): Int {
    viewHeight = value;

    return value;
  }
}

/**
 * The camera options you set set in the `Camera` init function.
 */
typedef CameraOptions = {
  /**
   * The camera zoom.
   */
  var ?zoom: Float;

  /**
   * The x position of the view in view space.
   */
  var ?viewX: Int;

  /**
   * The y position of the view in view space.
   */
  var ?viewY: Int;

  /**
   * The camera view width.
   */
  var ?viewWidth: Int;

  /**
   * The camera view height. 
   */
  var ?viewHeight: Int;

  /**
   * The camera background color.
   */
  var ?backgroundColor: Color;

  /**
   * Set as the main camera in the scene.
   */
  var ?isMain: Bool;
}
