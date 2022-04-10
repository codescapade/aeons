package aeons.events;

/**
 * The sort event is used by the transform component when the z index changes to let the render system know that the
 * bundles need to be sorted.
 */
class SortEvent extends Event {
  public static inline final SORT_Z: EventType<SortEvent> = 'aeons_sort_z';
}
