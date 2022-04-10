package aeons.graphics.renderers;

import aeons.math.FastVector3;
import aeons.math.FastMatrix4;
import aeons.graphics.Shaders;

import kha.graphics4.Graphics;
import kha.graphics4.IndexBuffer;
import kha.graphics4.VertexBuffer;

using aeons.math.FastVector3Ex;

/**
 * Render shapes like triangles, rectangles and circles.
 */
class ShapeRenderer extends BaseRenderer {

  /**
   * The offset per triangle.
   * x, y, z positions.
   * r, g, b, a colors.
   * 3 vertices per triangle.
   */
  final offset = 7 * 3;

  /**
   * Temp vertex positions.
   */
  final p1: FastVector3;
  final p2: FastVector3;
  final p3: FastVector3;

  /**
   * The number of vertices per triangle.
   */
  final verticesPerTri = 3;

  /**
   * Constructor.
   * @param g4 The Kha g4 reference.
   */
  public function new(g4: Graphics) {
    super(g4);

    p1 = new FastVector3();
    p2 = new FastVector3();
    p3 = new FastVector3();

    vertexBuffer = new VertexBuffer(bufferSize * verticesPerTri, pipeline.structure, DynamicUsage);
    vertices = vertexBuffer.lock();

    indexBuffer = new IndexBuffer(bufferSize * verticesPerTri, StaticUsage);

    final indices = indexBuffer.lock();
    for (i in 0...bufferSize) {
      indices[i * verticesPerTri] = i * verticesPerTri;
      indices[i * verticesPerTri + 1] = i * verticesPerTri + 1;
      indices[i * verticesPerTri + 2] = i * verticesPerTri + 2;
    }
    indexBuffer.unlock();
  }

  /**
   * Renderer cleanup.
   */
  public override function cleanup() {
    vertices = null;
    vertexBuffer.delete();
    indexBuffer.delete();
  }

  /**
   * Send the vertices to the buffer to draw.
   */
  public override function present() {
    if (bufferIndex == 0) {
      return;
    }

    vertexBuffer.unlock(bufferIndex * verticesPerTri);
    g4.setPipeline(pipeline.state);
    g4.setVertexBuffer(vertexBuffer);
    g4.setIndexBuffer(indexBuffer);
    g4.setMatrix(pipeline.projectionLocation, projection);
    g4.drawIndexedVertices(0, bufferIndex * verticesPerTri);

    vertices = vertexBuffer.lock(0);
    bufferIndex = 0;
  }

  /**
   * Draw a triangle filled with a color.
   * @param x1 The x position of the first point in pixels.
   * @param y1 The y position of the first point in pixels.
   * @param x2 The x position of the second point in pixels.
   * @param y2 The y position of the second point in pixels.
   * @param x3 The x position of the thrid point in pixels.
   * @param y3 The y position of the third point in pixels.
   * @param transform The transformation matrix.
   * @param color The triangle color.
   */
  public function drawSolidTriangle(x1: Float, y1: Float, x2: Float, y2: Float, x3: Float, y3: Float,
      transform: FastMatrix4, color: Color) {
    if (bufferIndex >= bufferSize) {
      present();
    }

    p1.mulVec3Val(transform, x1, y1, 0);
    p2.mulVec3Val(transform, x2, y2, 0);
    p3.mulVec3Val(transform, x3, y3, 0);

    setVertices(p1.x, p1.y, p2.x, p2.y, p3.x, p3.y);
    setColor(color, color, color);
    bufferIndex++;
  }

  /**
   * Draw a rectangle filled with color.
   * @param x The x position of the top left of the rectangle in pixels.
   * @param y The y position of the top left of the rectangle in pixels.
   * @param width The width of the rectangle in pixels.
   * @param height The height of the rectangle in pixels.
   * @param transform The transformation matrix.
   * @param color The line color.
   */
  public function drawSolidRect(x: Float, y: Float, width: Float, height: Float, transform: FastMatrix4, color: Color) {
    if (bufferIndex >= bufferSize) {
      present();
    }

    drawSolidTriangle(x, y, x + width, y, x, y + height, transform, color);
    drawSolidTriangle(x, y + height, x + width, y, x + width, y + height, transform, color);
  }

  /**
   * Draw a line between two points.
   * @param x1 The x position of the first point in pixels.
   * @param y1 The y position of the first point in pixels.
   * @param x2 The x position of the second point in pixels.
   * @param y2 The y position of the second point in pixels.
   * @param lineWidth The width of the line in pixels.
   * @param align Should the line be on the outside, middle or inside of the points.
   * @param transform The transformation matrix.
   * @param color The line color.
   */
  public function drawLine(x1: Float, y1: Float, x2: Float, y2: Float, lineWidth: Float, align: LineAlign,
      transform: FastMatrix4, color: Color) {
    if (bufferIndex >= bufferSize) {
      present();
    }

    final dx = x2 - x1;
    final dy = y2 - y1;

    final lineLength = Math.sqrt(dx * dx + dy * dy);

    final scale = lineWidth / (2.0 * lineLength);
    final ddx = -scale * dy;
    final ddy = scale * dx;

    switch (align) {
      case Inside:
        drawSolidTriangle(x1, y1, x1 + ddx * 2, y1 + ddy * 2, x2, y2, transform, color);
        drawSolidTriangle(x2, y2, x1 + ddx * 2, y1 + ddy * 2, x2 + ddx * 2, y2 + ddy * 2, transform, color);

      case Middle:
        drawSolidTriangle(x1 + ddx, y1 + ddy, x1 - ddx, y1 - ddy, x2 + ddx, y2 + ddy, transform, color);
        drawSolidTriangle(x2 + ddx, y2 + ddy, x1 - ddx, y1 - ddy, x2 - ddx, y2 - ddy, transform, color);

      case Outside:
        drawSolidTriangle(x1, y1, x1 - ddx * 2, y1 - ddy * 2, x2, y2, transform, color);
        drawSolidTriangle(x2, y2, x1 - ddx * 2, y1 - ddy * 2, x2 - ddx * 2, y2 - ddy * 2, transform, color);
    }
  }

  /**
   * Draw a rectangle outline.
   * @param x The x position of the top left of the rectangle in pixels.
   * @param y The y position of the top left of the rectangle in pixels.
   * @param width The width of the rectangle in pixels.
   * @param height The height of the rectangle in pixels.
   * @param lineWidth The line width of the outline in pixels.
   * @param align Should the line be on the outside, middle or inside of the rectangle.
   * @param transform The transformation matrix.
   * @param color The line color.
   */
  public function drawRect(x: Float, y: Float, width: Float, height: Float, lineWidth: Float, align: LineAlign,
      transform: FastMatrix4, color: Color) {
    switch (align) {
      case Inside:
        // top
        drawLine(x, y, x + width, y, lineWidth, align, transform, color);
        // right
        drawLine(x + width, y, x + width, y + height, lineWidth, align, transform, color);
        // bottom
        drawLine(x + width, y + height, x, y + height, lineWidth, align, transform, color);
        // left
        drawLine(x, y + height, x, y, lineWidth, align, transform, color);

      case Middle:
         // top
        drawLine(x - lineWidth * 0.5, y, x + width + lineWidth * 0.5, y, lineWidth, align, transform, color);
        // right
        drawLine(x + width, y - lineWidth * 0.5, x + width, y + height + lineWidth * 0.5, lineWidth, align, transform,
            color);
        // bottom
        drawLine(x + width + lineWidth * 0.5, y + height, x - lineWidth * 0.5, y + height, lineWidth, align, transform,
            color);
        // left
        drawLine(x, y + height + lineWidth * 0.5, x, y - lineWidth * 0.5, lineWidth, align, transform, color);

      case Outside:
        // top
        drawLine(x - lineWidth, y, x + width + lineWidth, y, lineWidth, align, transform, color);
        // right
        drawLine(x + width, y - lineWidth, x + width, y + height + lineWidth, lineWidth, align, transform, color);
        // bottom
        drawLine(x + width + lineWidth, y + height, x - lineWidth, y + height, lineWidth, align, transform, color);
        // left
        drawLine(x, y + height + lineWidth, x, y - lineWidth, lineWidth, align, transform, color);
    }
  }

  /**
   * Draw a circle outline.
   * @param x The x position of the center in pixels.
   * @param y The y position of the center in pixels.
   * @param radius The radius in pixels.
   * @param lineWidth The line width of the outline in pixels.
   * @param segments The number of segments. More segments is a smoother circle.
   * @param transform The transformation matrix.
   * @param color The line color.
   */
  public function drawCircle(x: Float, y: Float, radius: Float, lineWidth: Float, segments: Int, transform: FastMatrix4,
      color: Color) {
    final theta = 2 * Math.PI / segments;
    final cos = Math.cos(theta);
    final sin = Math.sin(theta);

    var sx = radius;
    var sy = 0.0;

    for (i in 0...segments) {
      final px = sx + x;
      final py = sy + y;
      final t = sx;
      sx = cos * sx - sin * sy;
      sy = cos * sy + sin * t;
      drawLine(sx + x, sy + y, px, py, lineWidth, Inside, transform, color);
    }
  }

  /**
   * Draw a circle filled with a color.
   * @param x The x position of the center in pixels.
   * @param y The y position o} the center in pixels.
   * @param radius The circle radius in pixels.
   * @param segments The number of segments. More segments is a smoother circle.
   * @param transform The transformation matrix.
   * @param color The circle color.
   */
  public function drawSolidCircle(x: Float, y: Float, radius: Float, segments: Int, transform: FastMatrix4,
      color: Color) {
    final theta = 2 * Math.PI / segments;
    final cos = Math.cos(theta);
    final sin = Math.sin(theta);

    var sx = radius;
    var sy = 0.0;

    for (i in 0...segments) {
      final px = sx + x;
      final py = sy + y;
      final t = sx;

      sx = cos * sx - sin * sy;
      sy = cos * sy + sin * t;
      drawSolidTriangle(px, py, sx + x, sy + y, x, y, transform, color);
    }
  }

  /**
   * Create the default shader pipeline.
   * @return The shader pipeline.
   */
  override function createDefaultPipeline(): Pipeline {
    final pl = new Pipeline(Shaders.painter_colored_vert, Shaders.painter_colored_frag, false);

    return pl;
  }

  /**
   * Set the vertex positions for one triangle. The positions are in projection space.
   * @param x1 The x position of the first point in pixels.
   * @param y1 The y position of the first point in pixels.
   * @param x2 The x position of the second point in pixels.
   * @param y2 The y position of the second point in pixels.
   * @param x3 The x position of the thrid point in pixels.
   * @param y3 The y position of the third point in pixels.
   */
  function setVertices(x1: Float, y1: Float, x2: Float, y2: Float, x3: Float, y3: Float) {
    final index = bufferIndex * offset;

    // First point.
    vertices[index] = x1;
    vertices[index + 1] = y1;
    vertices[index + 2] = -5.0;

    // Second point.
    vertices[index + 7] = x2;
    vertices[index + 8] = y2;
    vertices[index + 9] = -5.0;

    // Third point.
    vertices[index + 14] = x3;
    vertices[index + 15] = y3;
    vertices[index + 16] = -5.0;
  }

  function setColor(color1: Color, color2: Color, color3: Color) {
    final index = bufferIndex * offset;

    // First point.
    vertices[index + 3] = color1.R;
    vertices[index + 4] = color1.G;
    vertices[index + 5] = color1.B;
    vertices[index + 6] = color1.A;

    // Second point.
    vertices[index + 10] = color2.R;
    vertices[index + 11] = color2.G;
    vertices[index + 12] = color2.B;
    vertices[index + 13] = color2.A;

    // Third point.
    vertices[index + 17] = color3.R;
    vertices[index + 18] = color3.G;
    vertices[index + 19] = color3.B;
    vertices[index + 20] = color3.A;
  }
}
