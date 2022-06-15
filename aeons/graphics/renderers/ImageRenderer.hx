package aeons.graphics.renderers;

import aeons.graphics.Shaders;
import aeons.math.FastFloat;
import aeons.math.FastMatrix4;
import aeons.math.FastVector3;
import aeons.math.Vector2;

import kha.graphics4.Graphics;
import kha.graphics4.IndexBuffer;
import kha.graphics4.TextureFilter;
import kha.graphics4.VertexBuffer;

using aeons.math.FastVector3Ex;

/**
 * The image renderer.
 */
class ImageRenderer extends BaseRenderer {
  /**
   * Offset per quad.
   * x, y, z positions.
   * u, v texture coordinates.
   * r, g, b, a colors.
   * 4 vertices per quad.
   */
  final offset = 9 * 4;

  /**
   * Temp vertex positions.
   */
  var p1: FastVector3;

  var p2: FastVector3;
  var p3: FastVector3;
  var p4: FastVector3;

  /**
   * Temp texture coordinates.
   */
  final t1: Vector2;

  final t2: Vector2;
  final t3: Vector2;
  final t4: Vector2;

  /**
   * The image for the current batch.
   */
  var currentImage: Image;

  /**
   * The number of vertices per quad.
   */
  final verticesPerQuad = 4;

  /**
   * The number of indices per quad.
   * Two triangles per quad. Three per triangle.
   */
  final indicesPerQuad = 6;

  /**
   * ImageRenderer constructor.
   * @param g4 The kha g4 reference.
   */
  public function new(g4: Graphics) {
    super(g4);

    t1 = new Vector2();
    t2 = new Vector2();
    t3 = new Vector2();
    t4 = new Vector2();

    vertexBuffer = new VertexBuffer(bufferSize * verticesPerQuad, pipeline.structure, DynamicUsage);
    vertices = vertexBuffer.lock();

    indexBuffer = new IndexBuffer(bufferSize * indicesPerQuad, StaticUsage);

    // Set all index buffer indices.
    final indices = indexBuffer.lock();
    for (i in 0...bufferSize) {
      indices[i * indicesPerQuad] = i * verticesPerQuad;
      indices[i * indicesPerQuad + 1] = i * verticesPerQuad + 1;
      indices[i * indicesPerQuad + 2] = i * verticesPerQuad + 2;
      indices[i * indicesPerQuad + 3] = i * verticesPerQuad;
      indices[i * indicesPerQuad + 4] = i * verticesPerQuad + 2;
      indices[i * indicesPerQuad + 5] = i * verticesPerQuad + 3;
    }
    indexBuffer.unlock();
  }

  /**
   * Renderer cleanup.
   */
  public override function cleanup() {
    vertices = null;
    currentImage = null;
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
    vertexBuffer.unlock(bufferIndex * verticesPerQuad);
    g4.setPipeline(pipeline.state);
    g4.setVertexBuffer(vertexBuffer);
    g4.setIndexBuffer(indexBuffer);
    g4.setTexture(pipeline.textureLocation, currentImage);
    var filter: TextureFilter = Aeons.display.pixelArt ? PointFilter : LinearFilter;
    g4.setTextureParameters(pipeline.textureLocation, Clamp, Clamp, filter, filter, NoMipFilter);
    g4.setMatrix(pipeline.projectionLocation, projection);
    g4.drawIndexedVertices(0, bufferIndex * indicesPerQuad);
    g4.setTexture(pipeline.textureLocation, null);

    vertices = vertexBuffer.lock();
    bufferIndex = 0;
  }

  /**
   * Draw an image into the buffer.
   * @param x The x position in pixels.
   * @param y The y position in pixels.
   * @param image The image to draw.
   * @param transform The transformation matrix.
   * @param color The tint color.
   */
  public inline function drawImage(x: FastFloat, y: FastFloat, image: Image, transform: FastMatrix4, color: Color) {
    drawImageSection(x, y, 0, 0, image.width, image.height, image, transform, color);
  }

  /**
   * Draw an image with a custom size into the buffer.
   * @param x The x position in pixels.
   * @param y The y position in pixels.
   * @param width The custom image width in pixels.
   * @param height The custom image height in pixels.
   * @param image The image to draw.
   * @param transform The transformation matrix.
   * @param color The tint color.
   */
  public inline function drawImageWithSize(x: FastFloat, y: FastFloat, width: FastFloat, height: FastFloat,
      image: Image, transform: FastMatrix4, color: Color) {
    drawImageSectionWithSize(x, y, width, height, 0, 0, image.width, image.height, image, transform, color);
  }

  /**
   * Draw a section of an image.
   * @param x The x position in pixels.
   * @param y The y position in pixels.
   * @param sx The x position inside the source image in pixels.
   * @param sy The y position inside the source image in pixels.
   * @param sw The width of the section in pixels.
   * @param sh The height of the section in pixels.
   * @param image The source image.
   * @param transform The transformation matrix.
   * @param color The tint color.
   */
  public inline function drawImageSection(x: FastFloat, y: FastFloat, sx: FastFloat, sy: FastFloat, sw: FastFloat,
      sh: FastFloat, image: Image, transform: FastMatrix4, color: Color) {
    drawImageSectionWithSize(x, y, sw, sh, sx, sy, sw, sh, image, transform, color);
  }

  /**
   * Draw a section of an image and set a custom image size.
   * @param x The x position in pixels.
   * @param y The y position in pixels.
   * @param width The custom image width in pixels.
   * @param height The custom image height in pixels.
   * @param sx The x position inside the source image in pixels.
   * @param sy The y position inside the source image in pixels.
   * @param sw The width of the section in pixels.
   * @param sh The height of the section in pixels.
   * @param image The source image.
   * @param transform The transformation matrix.
   * @param color The tint color.
   */
  public function drawImageSectionWithSize(x: FastFloat, y: FastFloat, width: FastFloat, height: FastFloat,
      sx: FastFloat, sy: FastFloat, sw: FastFloat, sh: FastFloat, image: Image, transform: FastMatrix4, color: Color) {
    if (bufferIndex >= bufferSize || (currentImage != null && currentImage != image)) {
      present();
    }

    currentImage = image;

    final textureWidth = currentImage.realWidth;
    final textureHeight = currentImage.realHeight;

    // Apply the transformation matrix to the vertex positions.
    p1 = FastVector3.mulVec3Val(transform, x, y, 0);
    p2 = FastVector3.mulVec3Val(transform, x + width, y, 0);
    p3 = FastVector3.mulVec3Val(transform, x + width, y + height, 0);
    p4 = FastVector3.mulVec3Val(transform, x, y + height, 0);

    // Set the texture coordinates.
    t1.set(sx / textureWidth, sy / textureHeight);
    t2.set((sx + sw) / textureWidth, sy / textureHeight);
    t3.set((sx + sw) / textureWidth, (sy + sh) / textureHeight);
    t4.set(sx / textureWidth, (sy + sh) / textureHeight);

    // fill the current buffer.
    setVertices(p1.x, p1.y, p2.x, p2.y, p3.x, p3.y, p4.x, p4.y);
    setTextureCoords(t1.x, t1.y, t2.x, t2.y, t3.x, t3.y, t4.x, t4.y);
    setColor(color);

    bufferIndex++;
  }

  /**
   * Create the default shader pipeline.
   * @return The shader pipeline.
   */
  override function createDefaultPipeline(): Pipeline {
    final pl = new Pipeline(Shaders.painter_image_vert, Shaders.painter_image_frag, true);

    return pl;
  }

  /**
   * Set the vertex positions for one image. The positions are in projection space.
   * @param tlX The top left x position.
   * @param tlY The top left y position.
   * @param trX The top right x position.
   * @param trY The top right y position.
   * @param brX The bottom right x position.
   * @param brY The bottom right y position.
   * @param blX The bottom left x position.
   * @param blY The bottom left y position.
   */
  function setVertices(tlX: FastFloat, tlY: FastFloat, trX: FastFloat, trY: FastFloat, brX: FastFloat, brY: FastFloat,
      blX: FastFloat, blY: FastFloat) {
    final index = bufferIndex * offset;

    // Top left.
    vertices[index] = tlX;
    vertices[index + 1] = tlY;
    vertices[index + 2] = -5.0;

    // Top right.
    vertices[index + 9] = trX;
    vertices[index + 10] = trY;
    vertices[index + 11] = -5.0;

    // Bottom right.
    vertices[index + 18] = brX;
    vertices[index + 19] = brY;
    vertices[index + 20] = -5.0;

    // Bottom left.
    vertices[index + 27] = blX;
    vertices[index + 28] = blY;
    vertices[index + 29] = -5.0;
  }

  /**
   * Set the texture coordinates for one image. The positions are between 0 and 1.
   * @param tlX The top left x position.
   * @param tlY The top left y position.
   * @param trX The top right x position.
   * @param trY The top right y position.
   * @param brX The bottom right x position.
   * @param brY The bottom right y position.
   * @param blX The bottom left x position.
   * @param blY The bottom left y position.
   */
  function setTextureCoords(tlX: FastFloat, tlY: FastFloat, trX: FastFloat, trY: FastFloat, brX: FastFloat,
      brY: FastFloat, blX: FastFloat, blY: FastFloat) {
    var index = bufferIndex * offset;

    // Top left.
    vertices[index + 3] = tlX;
    vertices[index + 4] = tlY;

    // Top right.
    vertices[index + 12] = trX;
    vertices[index + 13] = trY;

    // Bottom right.
    vertices[index + 21] = brX;
    vertices[index + 22] = brY;

    // Bottom left.
    vertices[index + 30] = blX;
    vertices[index + 31] = blY;
  }

  /**
   * Set the color for an image. 
   * @param color The color to use.
   */
  function setColor(color: Color) {
    final index = bufferIndex * offset;

    final r = color.R;
    final g = color.G;
    final b = color.B;
    final a = color.A;

    // Top left.
    vertices[index + 5] = r;
    vertices[index + 6] = g;
    vertices[index + 7] = b;
    vertices[index + 8] = a;

    // Top right.
    vertices[index + 14] = r;
    vertices[index + 15] = g;
    vertices[index + 16] = b;
    vertices[index + 17] = a;

    // Bottom right.
    vertices[index + 23] = r;
    vertices[index + 24] = g;
    vertices[index + 25] = b;
    vertices[index + 26] = a;

    // Bottom left.
    vertices[index + 32] = r;
    vertices[index + 33] = g;
    vertices[index + 34] = b;
    vertices[index + 35] = a;
  }

  /**
   * Set the color of each vertex.
   * @param tlColor The top left color.
   * @param trColor The top right color.
   * @param brColor The bottom right color.
   * @param blColor The bottom left color.
   */
  function setEachColor(tlColor: Color, trColor: Color, brColor: Color, blColor: Color) {
    var index = bufferIndex * offset;

    // Top left.
    vertices[index + 5] = tlColor.R;
    vertices[index + 6] = tlColor.G;
    vertices[index + 7] = tlColor.B;
    vertices[index + 8] = tlColor.A;

    // Top right.
    vertices[index + 14] = trColor.R;
    vertices[index + 15] = trColor.G;
    vertices[index + 16] = trColor.B;
    vertices[index + 17] = trColor.A;

    // Bottom right.
    vertices[index + 23] = brColor.R;
    vertices[index + 24] = brColor.G;
    vertices[index + 25] = brColor.B;
    vertices[index + 26] = brColor.A;

    // Bottom left.
    vertices[index + 32] = blColor.R;
    vertices[index + 33] = blColor.G;
    vertices[index + 34] = blColor.B;
    vertices[index + 35] = blColor.A;
  }
}
