package aeons.tween;

import aeons.graphics.Color;
import aeons.graphics.ColorEx;
import aeons.tween.easing.Ease;
import aeons.tween.easing.Easing;
import aeons.utils.Pool;

/**
 * The Tween class is used to tween values over time.
 */
@:allow(aeons.tween.services.InternalTweens)
class Tween {
  /**
  * Is the tween complete.
  */
  public var complete(default, null): Bool;

  /**
  * The target to tween.
  */
  public var target(default, null): Dynamic;

  /**
  * True if the tween is currently active.
  */
  public var active: Bool;

  /**
  * Object pool for tween reuse.
  */
  static final pool: Pool<Tween> = new Pool(Tween);

  /**
  * The time since the tween started in seconds.
  */
  var time: Float;

  /**
  * How long the tween takes to complete in seconds.
  */
  var duration: Float;

  /**
  * List of properties to tween each frame.
  */
  var dataList: Array<TweenData>;

  /**
  * Type of easing to use.
  */
  var ease: Ease;

  /**
  * Function to call when the tween is complete.
  */
  var onComplete: ()->Void;

  /**
  * The delay before the tween starts.
  */
  var delay: Float;

  /**
  * Time passed while the tween is delayed.
  */
  var delayTime: Float;

  /**
  * True if the tween is paused.
  */
  var paused: Bool;

  /**
   * True if this is tweening a color.
   */
  var isColor: Bool;

  /**
  * Get an instance from the pool.
  * @param target The target to tween.
  * @param duration How long the tween takes to complete in seconds.
  * @param properties The properties on the target to tween.
  * @param isColor Is the property a color. They are different from normal values.
  * @return The initialized tween.
  */
  static function get(target: Dynamic, duration: Float, properties: Dynamic, isColor: Bool): Tween {
    final tween = pool.get();
    tween.reset(target, duration, properties, isColor);

    return tween;
  }

  /**
  * Remove all pooled tweens.
  */
  public static function clearPool() {
    pool.clear();
  }

  /**
  * private constructor. Should only be used by the pool.
  */
  function new() {}

  /**
  * Reset a tween. Used for pooling.
  * @param target The target to tween.
  * @param duration How long the tween takes to complete in seconds.
  * @param properties The properties on the target to tween.
  * @param isColor Is the property a color. They are different from normal values.
  */
  public function reset(target: Dynamic, duration: Float, properties: Dynamic, isColor: Bool) {
    this.target = target;
    this.duration = duration;
    this.isColor = isColor;
    createDataList(target, properties);
    ease = Easing.linear;
    onComplete = null;
    time = 0;
    complete = false;
    delayTime = 0;
    delay = 0;
    paused = false;
    active = true;
  }

  /**
  * Put this instance back into the pool.
  */
  public function put() {
    active = false;
    pool.put(this);
  }

  /**
  * Set the ease function to use.
  * @param ease The ease function.
  */
  public function setEase(ease: Ease): Tween {
    this.ease = ease;

    return this;
  }

  /**
  * Add a function to be called when the tween is complete.
  * @param callback The callback function.
  */
  public function setOnComplete(callback: ()->Void): Tween {
    this.onComplete = callback;

    return this;
  }

  /**
  * Set a tween start delay.
  * @param delay Delay in seconds.
  */
  public function setDelay(delay: Float): Tween {
    this.delay = delay;
    delayTime = 0;

    return this;
  }

  /**
  * Pause this tween.
  */
  public function pause() {
    paused = true;
  }

  /**
  * Resume this tween.
  */
  public function resume() {
    paused = false;
  }

  /**
  * Run the complete function.
  */
  function runComplete() {
    if (onComplete != null) {
      onComplete();
    }
  }

  /**
  * Update called every frame.
  * @param dt Time passed since the last frame in seconds.
  */
  function update(dt: Float) {
    if (!active || complete || paused) {
      return;
    }
    if (delayTime < delay) {
      delayTime += dt;
    } else {
      time += dt;
      if (time >= duration) {
        complete = true;
      }
      for (data in dataList) {
        setField(data);
      }
    }
  }

  /**
  * Create the data properties list it iterate over every frame.
  * @param target The object to tween.
  * @param properties The properties to tween on the object.
  */
  function createDataList(target: Dynamic, properties: Dynamic) {
    dataList = [];

    final fields = Type.getInstanceFields(Type.getClass(target));
    for (prop in Reflect.fields(properties)) {
      // Make sure the property exists on the target.
      if (fields.indexOf(prop) != -1) {
        final startValue = Reflect.field(target, prop);
        final endValue = Reflect.field(properties, prop);

        final data = new TweenData(startValue, endValue, prop);
        dataList.push(data);
      } else {
        throw('property $prop does not exist on the target.');
      }
    }
  }

  /**
  * Use reflection to set a target property to a new value.
  * @param data The tween info.
  */
  function setField(data: TweenData) {
    if (isColor) {
      final factor = ease(time, 0, 1, duration);
      final start: Color = cast data.start;
      final end: Color = cast data.end;
      var color = ColorEx.interpolate(start, end, factor);
      if (complete) {
        color = end;
      }
      Reflect.setProperty(target, data.propertyName, color);
    } else {
      var value = ease(time, data.start, data.change, duration);
      if (complete) {
        value = data.end;
      }
      Reflect.setProperty(target, data.propertyName, value);
    }
  }
}
