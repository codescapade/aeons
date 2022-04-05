package aeons.core;

/**
 * This is the base class for the `Bundle` class.
 */
@:dox(hide)
class BundleBase {
  /**
   * The entity the components in the bundle belong to.
   */
  public var entity(default, null): Entity;
}