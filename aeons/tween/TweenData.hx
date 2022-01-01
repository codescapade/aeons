package aeons.tween;

class TweenData {
  /**
   * The start value.
   */
  public var start: Float;

  /**
   * The end value.
   */
  public var end: Float;

  /**
   * The amount of change between start and end (end - start).
   */
  public var change: Float;

  /**
   * The property field that is tweened.
   */
  public var propertyName: String;

  /**
   * TweenData constructor.
   * @param start The start value.
   * @param end The end value.
   * @param propertyName The name of the field that is tweened.
   */
  public function new(start: Float, end: Float, propertyName: String) {
    this.start = start;
    this.end = end;
    this.propertyName = propertyName;
    change = end - start;
  }
}