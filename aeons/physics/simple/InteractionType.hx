package aeons.physics.simple;

/**
 * The types of interaction that can happen between two physics bodies.
 */
enum InteractionType {
  TRIGGER_START;
  TRIGGER_STAY;
  TRIGGER_END;
  COLLISION_START;
  COLLISION_STAY;
  COLLISION_END;
}
