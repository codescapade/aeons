package aeons.graphics.renderers;

import aeons.graphics.Shaders;
import aeons.math.FastFloat;
import aeons.math.FastMatrix4;
import aeons.math.FastVector3;
import aeons.math.Vector2;

import kha.graphics4.Graphics;
import kha.graphics4.IndexBuffer;
import kha.graphics4.VertexBuffer;

using aeons.math.FastVector3Ex;

/**
 * The text renderer.
 */
class TextRenderer extends BaseRenderer {
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
   * The font image for the current batch.
   */
  var currentImage: Image;

  /**
   * Kravur font cache.
   */
  final fontCache = new kha.Kravur.AlignedQuad();

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
   * TextRenderer constructor.
   * @param g4 The kha g4 reference.
   */
  public function new(g4: Graphics) {
    super(g4);

    t1 = new Vector2();
    t2 = new Vector2();
    t3 = new Vector2();
    t4 = new Vector2();

    vertexBuffer = new VertexBuffer(bufferSize * verticesPerQuad, pipeline.structure, DynamicUsage);

    // locking the buffer makes the vertices available to set.
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

    // Unlock the buffer vertices that were set.
    vertexBuffer.unlock(bufferIndex * verticesPerQuad);
    g4.setPipeline(pipeline.state);
    g4.setVertexBuffer(vertexBuffer);
    g4.setIndexBuffer(indexBuffer);
    g4.setTexture(pipeline.textureLocation, currentImage);
    g4.setTextureParameters(pipeline.textureLocation, Clamp, Clamp, LinearFilter, LinearFilter, NoMipFilter);
    g4.setMatrix(pipeline.projectionLocation, projection);
    g4.drawIndexedVertices(0, bufferIndex * indicesPerQuad);
    g4.setTexture(pipeline.textureLocation, null);

    vertices = vertexBuffer.lock();
    bufferIndex = 0;
  }

  /**
   * Draw a string.
   * @param x The x position of the text in pixels.
   * @param y The y position of the text in pixels.
   * @param text The text to draw.
   * @param font The font to use.
   * @param fontSize The font size.
   * @param transform The transformation matrix.
   * @param color The text color.
   */
  public function drawString(x: FastFloat, y: FastFloat, text: String, font: Font, fontSize: Int,
      transform: FastMatrix4, color: Color) {
    final fontImage = cast(font, kha.Kravur)._get(fontSize);
    final texture = fontImage.getTexture();
    if (bufferIndex >= bufferSize || (currentImage != null && currentImage != texture)) {
      present();
    }
    currentImage = texture;

    var offset = x;
    for (i in 0...text.length) {
      final charCode = StringTools.fastCodeAt(text, i);
      final quad = fontImage.getBakedQuad(fontCache, findCharIndex(charCode), offset, y);
      if (quad != null) {
        if (bufferIndex >= bufferSize) {
          present();
        }

        p1 = FastVector3.mulVec3Val(transform, quad.x0, quad.y0, 0);
        p2 = FastVector3.mulVec3Val(transform, quad.x1, quad.y0, 0);
        p3 = FastVector3.mulVec3Val(transform, quad.x1, quad.y1, 0);
        p4 = FastVector3.mulVec3Val(transform, quad.x0, quad.y1, 0);

        t1.set(quad.s0 * texture.width / texture.realWidth, quad.t0 * texture.height / texture.realHeight);
        t2.set(quad.s1 * texture.width / texture.realWidth, quad.t0 * texture.height / texture.realHeight);
        t3.set(quad.s1 * texture.width / texture.realWidth, quad.t1 * texture.height / texture.realHeight);
        t4.set(quad.s0 * texture.width / texture.realWidth, quad.t1 * texture.height / texture.realHeight);

        setVertices(p1.x, p1.y, p2.x, p2.y, p3.x, p3.y, p4.x, p4.y);
        setTextureCoords(t1.x, t1.y, t2.x, t2.y, t3.x, t3.y, t4.x, t4.y);
        setColors(color);
        offset += quad.xadvance;

        bufferIndex++;
      }
    }
  }

  /**
   * Create the default shader pipeline.
   * @return The shader pipeline.
   */
  override function createDefaultPipeline(): Pipeline {
    final pl = new Pipeline(Shaders.painter_text_vert, Shaders.painter_text_frag, true, SourceAlpha,
      InverseSourceAlpha, SourceAlpha, InverseSourceAlpha);

    return pl;
  }

  /**
   * Set the vertex positions for one glyph. The positions are in projection space.
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
   * Set the texture coordinates for one glyph. The positions are between 0 and 1.
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
   * Set the color for on3 glyph. 
   * @param color The color to use.
   */
  function setColors(color: Color) {
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
   * Find the character index from a character code.
   * @param charCode The character code.
   * @return The index.
   */
  function findCharIndex(charCode: Int): Int {
    var blocks = kha.Kravur.KravurImage.charBlocks;
    var offset = 0;
    for (i in 0...Std.int(blocks.length / 2)) {
      var start = blocks[i * 2];
      var end = blocks[i * 2 + 1];
      if (charCode >= start && charCode <= end) {
        return offset + charCode - start;
      }

      offset += end - start + 1;
    }

    return 0;
  }
}
