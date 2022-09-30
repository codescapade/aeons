package aeons.components;

import aeons.Aeons;
import aeons.core.Component;
import aeons.graphics.Color;
import aeons.graphics.Pipeline;
import aeons.graphics.RenderTarget;
import aeons.math.FastMatrix4;
import aeons.math.Rect;
import aeons.math.Vector2;

using aeons.math.AeMath;

/**
 * CCamera is a component that renders a view in the render system.
 */
class CCamera extends Component {
  /**
   * The main camera in the scene.
   */
  public static var main(default, null): CCamera;

  /**
   * The camera zoom.
   */
  public var zoom: Float;

  /**
   * The x position in the window.
   */
  public var viewX: Int;

  /**
   * The y position in the window.
   */
  public var viewY: Int;

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
  public var renderTarget(default, null): RenderTarget;

  /**
   * The camera background color. Defaults to black.
   */
  public var backgroundColor: Color;

  /**
   * The camera bounds.
   */
  public var bounds(default, null): Rect;

  /**
   * Shader pipeline to use for this camera.
   */
  public var pipeline: Pipeline;

  /**
   * Here you can set the pipeline uniforms if needed.
   */
  public var pipelineCallback: (target: RenderTarget)->Void;

  /**
   * The bounds that check what is inside the camera's view.
   */
  public var visibilityBounds(default, null): Rect;

  /**
   * Transform component reference.
   */
  var transform: CTransform;

  /**
   * World position caching.
   */
  var worldPosition = new Vector2();

  /**
   * Temp matrix to help with multiplying translation, rotation, scale in update matrix.
   */
  var tempMatrix: FastMatrix4;

  /**
   * Is the camera the size of the full game window.
   */
  var fullView: Bool;

  /**
   * Initialize the component.
   * @param options Initialization options.
   * @return This component.
   */
  public function create(?options: CCameraOptions): CCamera {
    if (options == null) {
      viewX = 0;
      viewY = 0;
      viewWidth = Aeons.display.viewWidth;
      viewHeight = Aeons.display.viewHeight;
      zoom = 1.0;
      backgroundColor = Color.Black;
      fullView = true;
    } else {
      viewWidth = options.viewWidth == null ? Aeons.display.viewWidth : options.viewWidth;
      viewHeight = options.viewHeight == null ? Aeons.display.viewHeight : options.viewHeight;
      zoom = options.zoom == null ? 1.0 : options.zoom;
      viewX = options.viewX == null ? 0 : options.viewX;
      viewY = options.viewY == null ? 0 : options.viewY;
      backgroundColor = options.backgroundColor == null ? Color.Black : options.backgroundColor;
      if (options.isMain) {
        main = this;
      }
      if (options.viewWidth == null && options.viewHeight == null) {
        fullView = true;
      }
    }

    transform = getComponent(CTransform);
    matrix = FastMatrix4.identity();
    bounds = new Rect();
    visibilityBounds = new Rect();
    updateBuffer();

    // Don't update the camera start position if the transform already has a different position.
    if (transform.x == 0 && transform.y == 0) {
      transform.x = viewWidth * 0.5;
      transform.y = viewHeight * 0.5;
    }

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
   * Cleanup when the component get removed.
   */
  public override function cleanup() {
    if (main == this) {
      main = null;
    }
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
    matrix.setFrom(FastMatrix4.translation(viewWidth * 0.5, viewHeight * 0.5, 0) // Move to center.
      .multmat(FastMatrix4.rotationZ(Math.degToRad(transform.getWorldAngle()))) // Rotate around the center
      .multmat(FastMatrix4.scale(zoom, zoom, 1)) // Scale around the center.
      .multmat(FastMatrix4.translation(-worldPosition.x, -worldPosition.y,
        0))); // Move the to correct position in the world.
  }

  /**
   * Convert screen positon to world position.
   * @param x The screen x position in pixels.
   * @param y The sreen y position in pixels.
   * @param out Optional vector to store the result in.
   * @return The world position.
   */
  public function screenToWorld(x: Float, y: Float, ?out: Vector2): Vector2 {
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
    if (fullView && (viewWidth != Aeons.display.viewWidth || viewHeight != Aeons.display.viewHeight)) {
      viewWidth = Aeons.display.viewWidth;
      viewHeight = Aeons.display.viewHeight;
      updateBuffer();
    }
    transform.getWorldPosition(worldPosition);
    bounds.x = worldPosition.x - viewWidth * 0.5 / zoom;
    bounds.y = worldPosition.y - viewHeight * 0.5 / zoom;
    bounds.width = viewWidth / zoom;
    bounds.height = viewHeight / zoom;

    final size = Math.max(viewWidth, viewHeight);
    visibilityBounds.x = worldPosition.x - size * 0.5 / zoom;
    visibilityBounds.y = worldPosition.y - size * 0.5 / zoom;
    visibilityBounds.width = size / zoom;
    visibilityBounds.height = size / zoom;
  }

  inline function set_viewWidth(value: Int): Int {
    viewWidth = value;

    return value;
  }

  inline function set_viewHeight(value: Int): Int {
    viewHeight = value;

    return value;
  }
}

/**
 * The camera options you set set in the CCamera init function.
 */
typedef CCameraOptions = {
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

  /**
   * Shader pipeline to use for this camera.
   */
  var ?pipeline: Pipeline;
}
