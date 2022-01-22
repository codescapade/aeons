package aeons.physics.simple;

import aeons.utils.Pool;

/**
 * `Interaction` is used in collision and trigger callbacks.
 */
class Interaction {
  /**
   * The type of interactionn. Collision or trigger.
   */
  public var type(default, null): InteractionType;

  /**
   * The first body in the interaction.
   */
  public var body1(default, null): Body;

  /**
   * The second body in the interaction.
   */
  public var body2(default, null): Body;

  /**
   * The interaction object pool.
   */
  @:noCompletion
  static var pool: Pool<Interaction> = new Pool<Interaction>(Interaction);

  /**
   * Get an interaction from the object pool.
   * @param type The type of interaction.
   * @param body1 The first body in the interaction.
   * @param body2 The second body in the interaction.
   */
  public static function get(type: InteractionType, body1: Body, body2: Body): Interaction {
    final interaction = pool.get();
    interaction.set(type, body1, body2);

    return interaction;
  }

  /**
   * Put the interaction back in the object pool
   */
  public function put() {
    type = null;
    body1 = null;
    body2 = null;
    pool.put(this);
  }

  /**
   * Set the properties on the interaction.
   * @param type The type of interaction.
   * @param body1 The first body in the interaction.
   * @param body2 The second body in the interaction.
   */
  function set(type: InteractionType, body1: Body, body2: Body) {
    this.type = type;
    this.body1 = body1;
    this.body2 = body2;
  }
}
