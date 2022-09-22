package aeons.events;

/**
 * ApplicationEvent for sending application state changes.
 */
class ApplicationEvent extends Event {
  /**
   * The game is going to pause.
   */
  public static inline final PAUSE: EventType<ApplicationEvent> = 'aeons_application_pause';

  /**
   * The game resumes from pause.
   */
  public static inline final RESUME: EventType<ApplicationEvent> = 'aeons_application_resume';

  /**
   * The game is moving to the background.
   */
  public static inline final BACKGROUND: EventType<ApplicationEvent> = 'aeons_application_background';

  /**
   * The game is moving back to the foreground.
   */
  public static inline final FOREGROUND: EventType<ApplicationEvent> = 'aeons_application_foreground';

  /**
   * The game window is getting resized.
   */
  public static inline final RESIZE: EventType<ApplicationEvent> = 'aeons_application_resize';

  /**
   * Used in the resize event for the new width in pixels.
   */
  var newWidth = 0;

  /**
   * Used in the resize event for the new height in pixels.
   */
  var newHeight = 0;
}
