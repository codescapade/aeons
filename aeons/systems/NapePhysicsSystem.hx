package aeons.systems;

#if use_nape
import aeons.components.CNapeBody;
import aeons.components.CNapeTilemapCollider;
import aeons.components.CTransform;
import aeons.core.Bundle;
import aeons.core.System;
import aeons.core.Updatable;
import aeons.math.AeMath;
import aeons.math.Vector2;
import aeons.physics.nape.DebugDraw;
import aeons.physics.nape.NapeInteractionType;

import nape.callbacks.CbEvent;
import nape.callbacks.InteractionCallback;
import nape.callbacks.InteractionListener;
import nape.phys.BodyType;
import nape.space.Space;

/**
 * NapePhysicsSystem updates all Nape body components.
 */
class NapePhysicsSystem extends System implements Updatable {
  /**
   * The nape space.
   */
  var space: Space;

  /**
   * Used for debug drawing.
   */
  var napeDebug: DebugDraw;

  /**
   * The system bundles with the components needed to update the entities.
   */
  @:bundle
  var bodyBundles: Bundle<CNapeBody, CTransform>;

  /**
   * The tilemap collider list.
   */
  @:bundle
  var tilemaps: Bundle<CNapeTilemapCollider>;

  /**
   * The entity ids that are in use in this system.
   */
  var ids: Array<Int> = [];

  /**
   * Constructor.
   * @param options The setup options.
   */
  public function new(?options: NapePhysicsSystemOptions) {
    super();

    space = new Space();
    napeDebug = new DebugDraw(space);

    if (options != null) {
      if (options.gravity != null) {
        setGravity(options.gravity.x, options.gravity.y);
      }
    }
  }

  /**
   * Update the bodies and transforms.
   * @param dt 
   */
  public function update(dt: Float) {
    for (bundle in bodyBundles) {
      updateBody(bundle);
    }

    if (dt > 0) {
      space.step(dt);
    }

    for (bundle in bodyBundles) {
      updateTransform(bundle);
    }
  }

  /**
   * System clean up.
   */
  public override function cleanup() {
    super.cleanup();
    space.clear();
    space = null;
  }

  /**
   * get the Nape gravity vector.
   */
  public function getGravity(): Vector2 {
    return Vector2.get(space.gravity.x, space.gravity.y);
  }

  /**
   * set the Nape gravity vector.
   */
  public function setGravity(x: Float, y: Float) {
    space.gravity.setxy(x, y);
  }

  /**
   * Add an interaction listener.
   * @param event The interaction event.
   * @param type The interaction type.
   * @param options1 Options for the first body.
   * @param options2 Options for the second body.
   * @param callback The callback when the interaction happened.
   * @param precedence Order of interaction.
   */
  public function addInteractionListener(event: CbEvent, type: NapeInteractionType, options1: Null<Dynamic>,
      options2: Null<Dynamic>, callback: InteractionCallback->Void, precedence = 0): InteractionListener {
    final listener = new InteractionListener(event, type, options1, options2, callback, precedence);
    space.listeners.add(listener);

    return listener;
  }

  /**
   * Remove an interaction listener.
   * @param listener The listener to remove.
   */
  public function removeInteractionListener(listener: InteractionListener) {
    space.listeners.remove(listener);
  }

  /**
   * Update the dynamic and kinematic bodies that have changed positions.
   * @param bundle The bundle to update.
   */
  function updateBody(bundle: aeons.bundles.BundleCNapeBodyCTransform) {
    if (bundle.cNapeBody.body.type == BodyType.STATIC) {
      return;
    }

    final worldPos = bundle.cTransform.getWorldPosition();
    final worldAngle = bundle.cTransform.getWorldAngle();
    bundle.cNapeBody.body.position.setxy(worldPos.x, worldPos.y);
    bundle.cNapeBody.body.rotation = AeMath.degToRad(worldAngle);
    worldPos.put();
  }

  /**
   * Update the transform component after the nape physics update.
   * @param bundle The bundle to update.
   */
  function updateTransform(bundle: aeons.bundles.BundleCNapeBodyCTransform) {
    if (bundle.cNapeBody.body.type == BodyType.STATIC) {
      return;
    }

    final position = bundle.cNapeBody.body.position;
    final pos = Vector2.get(position.x, position.y);
    bundle.cTransform.setWorldPosition(pos);
    bundle.cTransform.setWorldAngle(AeMath.radToDeg(bundle.cNapeBody.body.rotation));
    pos.put();
  }
}

typedef NapePhysicsSystemOptions = {
  var ?gravity: { x: Float, y: Float };
}
#end
