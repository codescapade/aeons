package aeons.physics.nape;

#if use_nape
import nape.constraint.PivotJoint;
import nape.phys.BodyList;
import nape.phys.BodyType;
import nape.shape.ShapeType;
import nape.space.Space;

import aeons.math.FastMatrix4;
import aeons.graphics.Color;
import aeons.graphics.RenderTarget;

using aeons.math.FastMatrix4Ex;
/**
 * Nape debug draw class.
 */
class DebugDraw {
  /**
   * Show the contacts when a collision happens.
   */
  public var showCollisionContacts = false;

  /**
   * Show the collisions edges collisions happen on.
   */
  public var showCollisionEdges = false;

  /**
   * Show the bounds of the nape body.
   */
  public var showBodyBounds = false;

  /**
   * Show contraints anchors on the bodies.
   */
  public var showConstraintAnchors = false;

  /**
   * The naps world space.
   */
  final space: Space;

  /**
   * All bodies that are in the world.
   */
  final bodyList: BodyList;

  /**
   * The color for the shapes that are awake.
   */
  final shapeAwakeColor = Color.fromBytes(88, 150, 155, 255);

  /**
   * The color for the shapes that are sleeping.
   */
  final shapeSleepingColor = Color.fromBytes(48, 110, 115, 255);

  /**
   * The nape body bounds color.
   */
  final boundsColor = Color.fromBytes(89, 82, 65, 255);

  /**
   * The color for the body center point.
   */
  final centerColor = Color.fromBytes(185, 18, 27, 255);

  /**
   * The color for showing contstraints.
   */
  final constraintColor = Color.fromBytes(4, 191, 191, 255);

  /**
   * The color for edge collisions.
   */
  final edgeColor = Color.fromBytes(245, 79, 41, 255);

  /**
   * The color to show collision contacts.
   */
  final contactColor = Color.fromBytes(169, 207, 84, 255);

  /**
   * The color for static bodies.
   */
  final staticColor = Color.fromBytes(48, 115, 48, 255);

  /**
   * The color for kinematic bodies.
   */
  final kinematicColor = Color.fromBytes(48, 48, 115, 255);

  /**
   * Constructor.
   * @param space The nape world space.
   */
  public function new(space: Space) {
    this.space = space;
    bodyList = space.bodies;
  }

  /**
   * Render all the nape bodies.
   * @param target The graphics buffer to render to.
   */
  public function render(target: RenderTarget) {
    for (i in 0...bodyList.length) {
      final body = bodyList.at(i);

      // Render the nape body bounds.
      if (showBodyBounds) {
        target.drawRect(body.bounds.x, body.bounds.y, body.bounds.width, body.bounds.height, boundsColor, 2);
      }
      // Render all body shapes.
      for (j in 0...body.shapes.length) {
        final shape = body.shapes.at(j);
        var clr: Color;
        if (body.type == BodyType.STATIC) {
          clr = staticColor;
        } else if (body.type == BodyType.KINEMATIC) {
          clr = kinematicColor;
        } else if (body.isSleeping) {
          clr = shapeSleepingColor;
        } else {
          clr = shapeAwakeColor;
        }

        if (shape.type == ShapeType.POLYGON) {
          final edges = shape.castPolygon.edges;
          for (e in 0...edges.length) {
            final edge = edges.at(e);
            target.drawLine(edge.worldVertex1.x, edge.worldVertex1.y, edge.worldVertex2.x, edge.worldVertex2.y, clr, 2);
          }
        } else {
          target.drawCircle(body.worldCOM.x, body.worldCOM.y, shape.castCircle.radius, clr, 2, 16);
        }

        target.drawCircle(body.worldCOM.x, body.worldCOM.y, 2, centerColor, 2, 8);
      }

      // Render the contstraints.
      if (showConstraintAnchors) {
        for (c in 0...body.constraints.length) {
          if (Std.is(body.constraints.at(c), PivotJoint)) {
            final joint: PivotJoint = cast body.constraints.at(c);
            if (joint.active) {
              target.drawCircle(joint.anchor1.x, joint.anchor1.y, 2, constraintColor, 16);
              target.transform.setFrom(FastMatrix4.identity());
              target.transform.multmat(FastMatrix4.translation(body.position.x, body.position.y, 0))
                .multmat(FastMatrix4.rotationZ(body.rotation))
                .multmat(FastMatrix4.translation(-body.position.x, -body.position.y, 0));
            }
          }
        }
      }
    }

    // Render the collisions.
    for (i in 0...space.arbiters.length) {
      final arbiter = space.arbiters.at(i).collisionArbiter;
      if (arbiter != null) {
        if (showCollisionEdges) {
          final edge1 = arbiter.referenceEdge1;
          final edge2 = arbiter.referenceEdge2;
          if (edge1 != null && edge2 != null) {
            target.drawLine(edge1.worldVertex1.x, edge1.worldVertex1.y, edge1.worldVertex2.x, edge1.worldVertex2.y,
                edgeColor, 2);
            target.drawLine(edge2.worldVertex1.x, edge2.worldVertex1.y, edge2.worldVertex2.x, edge2.worldVertex2.y,
                edgeColor, 2);
          }
        }

        if (showCollisionContacts) {
          for (c in 0...arbiter.contacts.length) {
            final contact = arbiter.contacts.at(c);
            target.drawCircle(contact.position.x, contact.position.y, 2, contactColor, 16);
          }
        }
      }
    }
  }
}
#end