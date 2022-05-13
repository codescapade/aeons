package aeons.input;

import aeons.events.input.GamepadEvent;
import aeons.events.input.KeyboardEvent;
import aeons.events.input.MouseEvent;
import aeons.events.input.TouchEvent;

import kha.input.Gamepad;
import kha.input.KeyCode;
import kha.input.Keyboard;
import kha.input.Mouse;
import kha.input.Surface;

/**
 * Input system for keyboard, mouse, touch and gamepad input.
 */
class Input {
  /**
   * Is keyboard input enabled.
   */
  public var keyboardEnabled(default, null): Bool;

  /**
   * Is mouse input enabled.
   */
  public var mouseEnabled(default, null): Bool;

  /**
   * Is touch input enabled.
   */
  public var touchEnabled(default, null): Bool;

  /**
   * Is gamepad input enabled.
   */
  public var gamepadEnabled(default, null): Bool;

  // Gamepad access callback for gamepad 1 to 4.
  var gpa0: (Int, Float)->Void;
  var gpa1: (Int, Float)->Void;
  var gpa2: (Int, Float)->Void;
  var gpa3: (Int, Float)->Void;

  // Gamepad button callback for gamepad 1 to 4.
  var gpb0: (Int, Float)->Void;
  var gpb1: (Int, Float)->Void;
  var gpb2: (Int, Float)->Void;
  var gpb3: (Int, Float)->Void;

  /**
   * Constructor.
   * @param events The event emitter reference. 
   */
  public function new() {
    #if !no_keyboard
    keyboardEnabled = true;
    Keyboard.get().notify(keyDown, keyUp);
    Keyboard.disableSystemInterventions(Full);
    #end

    #if !no_mouse
    mouseEnabled = true;
    Mouse.get().notify(mouseDown, mouseUp, mouseMove, mouseScroll, mouseLeave);
    #end

    #if !no_gampad
    gamepadEnabled = true;
    setupGamepads();
    #end

    #if !no_touch
    touchEnabled = true;
    Surface.get().notify(touchStart, touchEnd, touchMove);
    #end
  }

  /**
   * Cleanup.
   */
  public function cleanup() {
    // Remove the kha input listeners.
    if (keyboardEnabled) {
      Keyboard.get().remove(keyDown, keyUp, null);
    }

    if (mouseEnabled) {
      Mouse.get().remove(mouseDown, mouseUp, mouseMove, mouseScroll, mouseLeave);
    }

    if (touchEnabled) {
      Surface.get().remove(touchStart, touchEnd, touchMove);
    }

    if (gamepadEnabled) {
      cleanupGamepads();
    }
  }

  /**
   * Link the callbacks wiIth the ids of the controllers.
   */
  function setupGamepads() {
    gpa0 = (axis: Int, value: Float) -> {
      gamepadAxis(0, axis, value);
    };

    gpa1 = (axis: Int, value: Float) -> {
      gamepadAxis(1, axis, value);
    };

    gpa2 = (axis: Int, value: Float) -> {
      gamepadAxis(2, axis, value);
    };

    gpa3 = (axis: Int, value: Float) -> {
      gamepadAxis(3, axis, value);
    };

    gpb0 = (button: Int, value: Float) -> {
      gamepadButton(0, button, value);
    };

    gpb1 = (button: Int, value: Float) -> {
      gamepadButton(1, button, value);
    };

    gpb2 = (button: Int, value: Float) -> {
      gamepadButton(2, button, value);
    };

    gpb3 = (button: Int, value: Float) -> {
      gamepadButton(3, button, value);
    };

    // Setup the Kha callbacks.
    Gamepad.notifyOnConnect(gamepadConnected, gamepadDisconnected);

    Gamepad.get(0).notify(gpa0, gpb0);
    Gamepad.get(1).notify(gpa1, gpb1);
    Gamepad.get(2).notify(gpa2, gpb2);
    Gamepad.get(3).notify(gpa3, gpb3);
  }

  /**
   * Remove the Kha callbacks.
   */
  function cleanupGamepads() {
    Gamepad.get(0).remove(gpa0, gpb0);
    Gamepad.get(1).remove(gpa1, gpb1);
    Gamepad.get(2).remove(gpa2, gpb2);
    Gamepad.get(3).remove(gpa3, gpb3);

    Gamepad.removeConnect(gamepadConnected, gamepadDisconnected);
  }

  /**
   * Key down callback.
   * @param key Keycode pressed or released.
   */
  inline function keyDown(key: KeyCode) {
    KeyboardEvent.emit(KeyboardEvent.KEY_DOWN, key);
  }

  /**
   * Key up callback.
   * @param key Keycode pressed or released.
   */
  inline function keyUp(key: KeyCode) {
    KeyboardEvent.emit(KeyboardEvent.KEY_UP, key);
  }

  /**
   * Mouse down callback.
   * @param button Mouse button pressed.
   * @param x The x position in window pixels.
   * @param y The y position in  window pixels.
   */
  inline function mouseDown(button: Int, x: Int, y: Int) {
    MouseEvent.emit(MouseEvent.MOUSE_DOWN, button, x, y);
  }

  /**
   * Mouse up callback.
   * @param button Mouse button released
   * @param x The x position in window pixels.
   * @param y The y position in  window pixels.
   */
  inline function mouseUp(button: Int, x: Int, y: Int) {
    MouseEvent.emit(MouseEvent.MOUSE_UP, button, x, y);
  }

  /**
   * Mouse move callback.
   * @param x The x position in window pixels.
   * @param y The y position in  window pixels.
   * @param deltaX The amount moved on the x axis since last callback in window pixels.
   * @param deltaY The amount moved on the y axis since last callback in window pixels.
   */
  inline function mouseMove(x: Int, y: Int, deltaX: Int, deltaY: Int) {
    MouseEvent.emit(MouseEvent.MOUSE_MOVE, -1, x, y, deltaX, deltaY);
  }

  /**
   * Mouse scroll callback.
   * @param direction The direction scrolled. -1 is up. 1 is down.
   */
  inline function mouseScroll(direction: Int) {
    MouseEvent.emit(MouseEvent.MOUSE_SCROLL, -1, 0, 0, 0, 0, direction);
  }

  /**
   * Mouse left screen callback.
   */
  inline function mouseLeave() {
    MouseEvent.emit(MouseEvent.MOUSE_LEAVE, -1, 0, 0, 0, 0, 0, true);
  }

  /**
   * Touch start callback.
   * @param id Touch id. Each finger on the screen has a tracking id.
   * @param x The x position in window pixels.
   * @param y The y position in window pixels.
   */
  inline function touchStart(id: Int, x: Int, y: Int) {
    TouchEvent.emit(TouchEvent.TOUCH_START, id, x, y);
  }

  /**
   * Touch end callback.
   * @param id Touch id. Each finger on the screen has a tracking id.
   * @param x The x position in window pixels.
   * @param y The y position in window pixels.
   */
  inline function touchEnd(id: Int, x: Int, y: Int) {
    TouchEvent.emit(TouchEvent.TOUCH_END, id, x, y);
  }

  /**
   * Touch move callback.
   * @param id Touch id. Each finger on the screen has a tracking id.
   * @param x The x position in window pixels.
   * @param y The y position in window pixels.
   */
  inline function touchMove(id: Int, x: Int, y: Int) {
    TouchEvent.emit(TouchEvent.TOUCH_MOVE, id, x, y);
  }

  /**
   * Gamepad connected callback.
   * @param id The gamepad id.
   */
  inline function gamepadConnected(id: Int) {
    GamepadEvent.emit(GamepadEvent.GAMEPAD_CONNECTED, id);
  }

  /**
   * Gamepad disconnected callback.
   * @param id The gamepad id.
   */
  inline function gamepadDisconnected(id: Int) {
    GamepadEvent.emit(GamepadEvent.GAMEPAD_DISCONNECTED, id);
  }

  /**
   * Gamepad axis change callback.
   * @param id The gamepad id.
   * @param axis The gamepad axis.
   * @param value The gamepad value.
   */
  inline function gamepadAxis(id: Int, axis: Int, value: Float) {
    GamepadEvent.emit(GamepadEvent.GAMEPAD_AXIS, id, axis, -1, value);
  }

  /**
   * Gamepad button change callback.
   * @param id The gamepad id.
   * @param button The gamepad button.
   * @param value The gamepad value.
   */
  inline function gamepadButton(id: Int, button: Int, value: Float) {
    GamepadEvent.emit(GamepadEvent.GAMEPAD_BUTTON, id, -1, button, value);
  }
}
