package aeons.graphics.renderers;

import aeons.math.FastMatrix4;
import aeons.utils.Float32Array;

import kha.graphics4.Graphics;
import kha.graphics4.IndexBuffer;
import kha.graphics4.VertexBuffer;

/**
 * The renderer base class. The shape, image and text renderer use this as the base.
 */
class BaseRenderer {
  /**
   * Kha graphics 4 reference.
   */
  final g4: Graphics;

  /**
   * The current shader pipeline.
   */
  var pipeline: Pipeline;

  /**
   * The default shader pipeline.
   */
  var defaultPipeline: Pipeline;

  /**
   * The vertex buffer.
   */
  var vertexBuffer: VertexBuffer;

  /**
   * The index buffer.
   */
  var indexBuffer: IndexBuffer;

  /**
   * The default projection is an orthographic projection.
   */
  var projection: FastMatrix4;

  /**
   * Vertices from the vertex buffer.
   */
  var vertices: Float32Array;

  /**
   * The current place in the buffer.
   */
  var bufferIndex = 0;

  /**
   * How many tris or quads in a buffer.
   */
  final bufferSize = 1500;

  /**
   * BaseRenderer constructor.
   * @param g4 The Kha graphics 4 renference.
   */
  public function new(g4: Graphics) {
    this.g4 = g4;
    defaultPipeline = createDefaultPipeline();
    setPipeline();
  }

  /**
   * Clean up the class before deleting.
   */
  public function cleanup() {}

  /**
   * Set a new shader pipeline. If set to `null` the default pipeline will be used.
   * @param pipeline 
   */
  public function setPipeline(?pipeline: Pipeline) {
    if (pipeline == null) {
      this.pipeline = defaultPipeline;
    } else {
      this.pipeline = pipeline;
    }
  }

  /**
   * Send the vertices to the buffer to draw.
   */
  public function present() {}

  /**
   * Update the projection matrix.
   * @param projection The new projection.
   */
  public function setProjection(projection: FastMatrix4) {
    this.projection = projection;
  }

  /**
   * Create the default shader pipeline. Should be overridden by the extending class.
   * @return The shader pipeline.
   */
  function createDefaultPipeline(): Pipeline {
    #if debug
    trace('Create default pipeline should be overridden in the extending class.');
    #end
    return null;
  }
}