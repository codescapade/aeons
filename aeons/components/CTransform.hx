package aeons.components;

import aeons.core.Component;
import aeons.events.SortEvent;
import aeons.math.FastMatrix4;
import aeons.math.Quaternion;
import aeons.math.Vector2;

using aeons.math.AeMath;
using aeons.math.FastMatrix4Ex;
using aeons.math.QuaternionEx;

/**
 * CTransform component to handle position, rotation and scale of an entity.
 */
class CTransform extends Component {
  /**
   * The matrix made up of the position, rotation and scale.
   */
  public var matrix(default, null): FastMatrix4;

  /**
   * The position on the x axis.
   */
  public var x(default, set): Float;

  /**
   * The position on the y axis.
   */
  public var y(default, set): Float;

  /**
   * The z index for render ordering. Higher is more in front.
   */
  public var zIndex(default, set): Float;

  /**
   * The rotation angle in degrees.
   */
  public var angle(default, set): Float;

  /**
   * The scale on the x axis.
   */
  public var scaleX(default, set): Float;

  /**
   * The scale on the y axis.
   */
  public var scaleY(default, set): Float;

  /**
   * The parent transform component.
   */
  public var parent: CTransform;

  /**
   * Internal rotation quaternion.
   */
  var rotation: Quaternion;

  /**
   * Keeps track if the matrix needs to be updated.
   * Matrix updating is expensive so only do it if something changes.
   */
  var changed = true;

  /**
   * Internal world position.
   */
  var worldPosition: Vector2;

  /**
   * Internal world scale.
   */
  var worldScale: Vector2;

  /**
   * Internal world angle.
   */
  var worldAngle: Float;

  @:allow(aeons.components.CCamera)
  var isCameraTransform = false;

  /**
   * Initialize the component.
   * @param options The initialization options.
   * @return This component.
   */
  public function create(?options: CTransformOptions): CTransform {
    matrix = FastMatrix4.identity();
    rotation = new Quaternion();
    worldPosition = new Vector2();
    worldScale = new Vector2();
    worldAngle = 0;
    isCameraTransform = false;

    if (options != null) {
      x = (options.x == null) ? 0.0 : options.x;
      y = (options.y == null) ? 0.0 : options.y;
      angle = (options.angle == null) ? 0.0 : options.angle;
      scaleX = (options.scaleX == null) ? 1.0 : options.scaleX;
      scaleY = (options.scaleY == null) ? 1.0 : options.scaleY;
      parent = (options.parent == null) ? null : options.parent;
      zIndex = options.zIndex == null ? 0.0 : options.zIndex;
    } else {
      x = 0.0;
      y = 0.0;
      angle = 0.0;
      scaleX = 1.0;
      scaleY = 1.0;
      zIndex = 0.0;
      parent = null;
    }

    changed = true;

    return this;
  }

  /**
   * Update the matrix using the position, rtoation and scale.
   */
  public function updateMatrix() {
    if (!hasChanged()) {
      return;
    }

    getWorldPosition(worldPosition);
    getWorldScale(worldScale);
    worldAngle = getWorldAngle();

    rotation = Quaternion.fromAxisAngleVal(0, 0, 1, Math.degToRad(worldAngle));

    matrix = FastMatrix4.from2dRotationTranslationScale(rotation, worldPosition, worldScale);
  }

  /**
   * Reset internal changed flag.
   */
  public function resetChanged() {
    changed = false;
  }

  /**
   * Convert a parent space position to local space position.
   * @param position The parent space position.
   * @return The local space position.
   */
  public function parentToLocalPosition(position: Vector2): Vector2 {
    if (angle == 0) {
      if (scaleX == 1 && scaleY == 1) {
        position.x -= x;
        position.y -= y;
      } else {
        position.x = (position.x - x) / scaleX;
        position.y = (position.y - y) / scaleY;
      }
    } else {
      final cos = Math.cos(Math.degToRad(angle));
      final sin = Math.sin(Math.degToRad(angle));
      final toX = position.x - x;
      final toY = position.y - y;
      position.x = (toX * cos + toY * sin) / scaleX;
      position.y = (toX * -sin + toY * cos) / scaleY;
    }

    return position;
  }

  /**
   * Convert a local space position to parent space position.
   * @param position The local space position.
   * @return The parent space position.
   */
  public function localToParentPosition(position: Vector2): Vector2 {
    if (angle == 0) {
      if (scaleX == 1 && scaleY == 1) {
        position.x += x;
        position.y += y;
      } else {
        position.x = position.x * scaleX + x;
        position.y = position.y * scaleY + y;
      }
    } else {
      final cos = Math.cos(Math.degToRad(-angle));
      final sin = Math.sin(Math.degToRad(-angle));
      final toX = position.x * scaleX;
      final toY = position.y * scaleY;
      position.x = (toX * cos + toY * sin) + x;
      position.y = (toX * -sin + toY * cos) + y;
    }

    return position;
  }

  /**
   * Convert a local position to world position.
   * @param position The local position.
   * @return The world position.
   */
  public function localToWorldPosition(position: Vector2): Vector2 {
    var p = parent;
    while (p != null) {
      p.localToParentPosition(position);
      p = p.parent;
    }

    return position;
  }

  /**
   * Convert a world space position to local space position.
   * @param position The world space position.
   * @return The local space position.
   */
  public function worldToLocalPosition(position: Vector2): Vector2 {
    if (parent != null) {
      parent.parentToLocalPosition(position);
    }

    return position;
  }

  /**
   * Get the world position for the transform.
   * @param out Vector to store the position in.
   * @return The world position.
   */
  public function getWorldPosition(?out: Vector2): Vector2 {
    if (out == null) {
      out = Vector2.get();
    }

    if (!hasChanged()) {
      return out.set(worldPosition.x, worldPosition.y);
    }

    out.set(x, y);

    return localToWorldPosition(out);
  }

  /**
   * Set the world position of the transform. Converts the world to local position.
   * @param position The new world position.
   */
  public function setWorldPosition(position: Vector2) {
    worldToLocalPosition(position);

    x = position.x;
    y = position.y;
  }

  /**
   * Get the world angle.
   * @return The world angle.
   */
  public function getWorldAngle(): Float {
    if (!hasChanged()) {
      return worldAngle;
    }

    if (parent != null) {
      return parent.getWorldAngle() + angle;
    }

    return angle;
  }

  /**
   * Set the world angle. Converts the world angle to local.
   * @param angle The new world angle.
   */
  public function setWorldAngle(angle: Float) {
    if (parent != null) {
      this.angle = angle - parent.getWorldAngle();
    } else {
      this.angle = angle;
    }
  }

  /**
   * Get the world scale of the transform.
   * @param out The vector to store the world scale in.
   * @return The world scale.
   */
  public function getWorldScale(?out: Vector2): Vector2 {
    if (out == null) {
      out = Vector2.get();
    }

    if (!hasChanged()) {
      return out.set(worldScale.x, worldScale.y);
    }

    out.set(scaleX, scaleY);

    if (parent != null) {
      var parentScale = parent.getWorldScale();
      out.mul(parentScale);
      parentScale.put();
    }

    return out;
  }

  /**
   * Check if a transform is a parent in the tree.
   * @param transformParent The transform to check.
   * @return True if the transform is a parent or higher.
   */
  public function containsParent(transformParent: CTransform): Bool {
    if (parent != null) {
      return parent.containsParent(transformParent);
    }

    return this == transformParent;
  }

  /**
   * Set the world scale. Converts world to loca scale.
   * @param scale The new world scale.
   */
  public function setWorldScale(scale: Vector2) {
    if (parent != null) {
      var parentScale = parent.getWorldScale();
      scale.div(parentScale);
      parentScale.put();
    }

    scaleX = scale.x;
    scaleY = scale.y;
  }

  /**
   * Set the transform position.
   * @param x The x position.
   * @param y The y position.
   */
  public inline function setPosition(x: Float, y: Float) {
    this.x = x;
    this.y = y;
  }

  /**
   * Set the transform scale.
   * @param x The x axis scale.
   * @param y The y axis scale.
   */
  public inline function setScale(x: Float, y: Float) {
    scaleX = x;
    scaleY = y;
  }

  /**
   * Check if any position, rotation or scale values have changed. This also checks the parent.
   * @return Bool
   */
  public inline function hasChanged(): Bool {
    if (parent != null) {
      return parent.hasChanged() || changed;
    }

    return changed;
  }

  function set_x(value: Float): Float {
    changed = true;
    x = value;

    return value;
  }

  function set_y(value: Float): Float {
    changed = true;
    y = value;

    return value;
  }

  function set_angle(value: Float): Float {
    changed = true;
    angle = value;

    return value;
  }

  function set_scaleX(value: Float): Float {
    changed = true;
    scaleX = value;

    return value;
  }

  function set_scaleY(value: Float): Float {
    changed = true;
    scaleY = value;

    return value;
  }

  function set_zIndex(value: Float): Float {
    zIndex = value;
    SortEvent.emit(SortEvent.SORT_Z);

    return value;
  }
}

/**
 * Transform initialization options.
 */
typedef CTransformOptions = {
  /**
   * The x position.
   */
  var ?x: Float;

  /**
   * The y position.
   */
  var ?y: Float;

  /**
   * The rotation angle in degrees.
   */
  var ?angle: Float;

  /**
   * The x scale.
   */
  var ?scaleX: Float;

  /**
   * The y scale.
   */
  var ?scaleY: Float;

  /**
   * The zIndex. Higher draws more in front.
   */
  var ?zIndex: Float;

  /**
   * The parent transform.
   */
  var ?parent: CTransform;
}
