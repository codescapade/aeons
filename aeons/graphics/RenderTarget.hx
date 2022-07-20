package aeons.graphics;

import aeons.graphics.renderers.ImageRenderer;
import aeons.graphics.renderers.ShapeRenderer;
import aeons.graphics.renderers.TextRenderer;
import aeons.math.FastFloat;
import aeons.math.FastMatrix3;
import aeons.math.FastMatrix4;
import aeons.math.FastVector2;
import aeons.math.FastVector3;
import aeons.math.FastVector4;
import aeons.utils.Float32Array;
import aeons.utils.Int32Array;

import kha.graphics4.Graphics;

/**
 * A render target lets you render to a texture.
 */
class RenderTarget {
  /**
   * The target image.
   */
  public var image(default, null): Image;

  /**
   * The target width in pixels.
   */
  public var width(get, never): Int;

  /**
   * The target height in pixels.
   */
  public var height(get, never): Int;

  /**
   * The transformation matrix.
   */
  public var transform: FastMatrix4;

  /**
   * The projection matrix.
   */
  var projection: FastMatrix4;

  /**
   * Kha graphics 4 reference.
   */
  var g4: Graphics;

  /**
   * The shape renderer.
   */
  var shapeRenderer: ShapeRenderer;

  /**
   * The image renderer.
   */
  var imageRenderer: ImageRenderer;

  /**
   * The text renderer.
   */
  var textRenderer: TextRenderer;

  /**
   * Create a new render target
   * @param width 
   * @param height 
   */
  public function new(width: Int, height: Int) {
    image = Image.createRenderTarget(width, height);
    g4 = image.g4;
    shapeRenderer = new ShapeRenderer(g4);
    imageRenderer = new ImageRenderer(g4);
    textRenderer = new TextRenderer(g4);

    // Some targets invert images. Set the matrix to correct that.
    if (Image.renderTargetsInvertedY()) {
      projection = FastMatrix4.orthogonalProjection(0, width, 0, height, 0.1, 1000);
    } else {
      projection = FastMatrix4.orthogonalProjection(0, width, height, 0, 0.1, 1000);
    }

    transform = FastMatrix4.identity();

    shapeRenderer.setProjection(projection);
    imageRenderer.setProjection(projection);
    textRenderer.setProjection(projection);
  }

  public function cleanup() {
    shapeRenderer.cleanup();
    imageRenderer.cleanup();
    textRenderer.cleanup();

    image.unload();
    image = null;
  }

  /**
   * Start the rendering.
   * @param clear Clear the target.
   * @param color The color to clear it with.
   */
  public function start(clear = true, color = Color.Black) {
    g4.begin();
    if (clear) {
      g4.clear(color);
    }
  }

  /**
   * Send the things you have drawn to the buffer to render it onto the image.
   */
  public function present() {
    shapeRenderer.present();
    imageRenderer.present();
    textRenderer.present();
    g4.end();
  }

  /**
   * Draw a triangle filled with a color.
   * @param x1 The x position of the first point in pixels.
   * @param y1 The y position of the first point in pixels.
   * @param x2 The x position of the second point in pixels.
   * @param y2 The y position of the second point in pixels.
   * @param x3 The x position of the thrid point in pixels.
   * @param y3 The y position of the third point in pixels.
   * @param color The triangle color.
   */
  public inline function drawSolidTriangle(x1: FastFloat, y1: FastFloat, x2: FastFloat, y2: FastFloat, x3: FastFloat,
      y3: FastFloat, color: Color) {
    imageRenderer.present();
    textRenderer.present();
    shapeRenderer.drawSolidTriangle(x1, y1, x2, y2, x3, y3, transform, color);
  }

  /**
   * Draw a rectangle filled with color.
   * @param x The x position of the top left of the rectangle in pixels.
   * @param y The y position of the top left of the rectangle in pixels.
   * @param width The width of the rectangle in pixels.
   * @param height The height of the rectangle in pixels.
   * @param color The line color.
   */
  public inline function drawSolidRect(x: FastFloat, y: FastFloat, width: FastFloat, height: FastFloat, color: Color) {
    imageRenderer.present();
    textRenderer.present();
    shapeRenderer.drawSolidRect(x, y, width, height, transform, color);
  }

  /**
   * Draw a line between two points.
   * @param x1 The x position of the first point in pixels.
   * @param y1 The y position of the first point in pixels.
   * @param x2 The x position of the second point in pixels.
   * @param y2 The y position of the second point in pixels.
   * @param color The line color.
   * @param lineWidth The width of the line in pixels.
   * @param align Should the line be on the outside, middle or inside of the points.
   */
  public inline function drawLine(x1: FastFloat, y1: FastFloat, x2: FastFloat, y2: FastFloat, color: Color,
      lineWidth = 1.0, align = LineAlign.Middle) {
    imageRenderer.present();
    textRenderer.present();
    shapeRenderer.drawLine(x1, y1, x2, y2, lineWidth, align, transform, color);
  }

  /**
   * Draw a rectangle outline.
   * @param x The x position of the top left of the rectangle in pixels.
   * @param y The y position of the top left of the rectangle in pixels.
   * @param width The width of the rectangle in pixels.
   * @param height The height of the rectangle in pixels.
   * @param color The line color.
   * @param lineWidth The line width of the outline in pixels.
   * @param align Should the line be on the outside, middle or inside of the rectangle.
   */
  public inline function drawRect(x: FastFloat, y: FastFloat, width: FastFloat, height: FastFloat, color: Color,
      lineWidth = 1.0, align = LineAlign.Middle) {
    imageRenderer.present();
    textRenderer.present();
    shapeRenderer.drawRect(x, y, width, height, lineWidth, align, transform, color);
  }

  /**
   * Draw a circle outline.
   * @param x The x position of the center in pixels.
   * @param y The y position of the center in pixels.
   * @param radius The radius in pixels.
   * @param color The line color.
   * @param lineWidth The line width of the outline in pixels.
   * @param segments The number of segments. More segments is a smoother circle.
   */
  public inline function drawCircle(x: FastFloat, y: FastFloat, radius: FastFloat, color: Color, lineWidth = 1.0,
      segments = 32) {
    imageRenderer.present();
    textRenderer.present();
    shapeRenderer.drawCircle(x, y, radius, lineWidth, segments, transform, color);
  }

  /**
   * Draw a circle filled with a color.
   * @param x The x position of the center in pixels.
   * @param y The y position o} the center in pixels.
   * @param radius The circle radius in pixels.
   * @param color The circle color.
   * @param segments The number of segments. More segments is a smoother circle.
   */
  public inline function drawSolidCircle(x: FastFloat, y: FastFloat, radius: FastFloat, color: Color, segments = 32) {
    imageRenderer.present();
    textRenderer.present();
    shapeRenderer.drawSolidCircle(x, y, radius, segments, transform, color);
  }

  /**
   * Draw an image into the buffer.
   * @param x The x position in pixels.
   * @param y The y position in pixels.
   * @param image The image to draw.
   * @param color The tint color.
   */
  public function drawImage(x: FastFloat, y: FastFloat, image: Image, color: Color) {
    shapeRenderer.present();
    textRenderer.present();
    imageRenderer.drawImage(x, y, image, transform, color);
  }

  /**
   * Draw an image
   * @param x The x position in pixels.
   * @param y The y position in pixels.
   * @param width The custom image width in pixels.
   * @param height The custom image height in pixels.
   * @param image The image to draw.
   * @param color The tint color.
   */
  public function drawImageWithSize(x: FastFloat, y: FastFloat, width: FastFloat, height: FastFloat, color: Color) {
    shapeRenderer.present();
    textRenderer.present();
    imageRenderer.drawImageWithSize(x, y, width, height, image, transform, color);
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
   * @param color The tint color.
   */
  public function drawImageSection(x: FastFloat, y: FastFloat, sx: FastFloat, sy: FastFloat, sw: FastFloat,
      sh: FastFloat, image: Image, color: Color) {
    shapeRenderer.present();
    textRenderer.present();
    imageRenderer.drawImageSection(x, y, sx, sy, sw, sh, image, transform, color);
  }

  /**
   * Draw a section of an image with a custom size.
   * @param x The x position in pixels.
   * @param y The y position in pixels.
   * @param width The custom image width in pixels.
   * @param height The custom image height in pixels.
   * @param sx The x position inside the source image in pixels.
   * @param sy The y position inside the source image in pixels.
   * @param sw The width of the section in pixels.
   * @param sh The height of the section in pixels.
   * @param image The source image.
   * @param color The tint color.
   */
  public function drawImageSectionWithSize(x: FastFloat, y: FastFloat, width: FastFloat, height: FastFloat,
      sx: FastFloat, sy: FastFloat, sw: FastFloat, sh: FastFloat, image: Image, color: Color) {
    shapeRenderer.present();
    textRenderer.present();
    imageRenderer.drawImageSectionWithSize(x, y, width, height, sx, sy, sw, sh, image, transform, color);
  }

  /**
   * Draw a string using a ttf font.
   * @param x The x position of the text in pixels.
   * @param y The y position of the text in pixels.
   * @param text The text to draw.
   * @param font The font to use.
   * @param fontSize The font size.
   * @param transform The transformation matrix.
   * @param color The text color.
   */
  public function drawText(x: FastFloat, y: FastFloat, text: String, font: Font, fontSize: Int, color: Color) {
    shapeRenderer.present();
    imageRenderer.present();
    textRenderer.drawText(x, y, text, font, fontSize, transform, color);
  }

  /**
   * Draw a string using a bitmap font.
   * @param x The x position of the text in pixels.
   * @param y The y position of the text in pixels.
   * @param text The text to draw.
   * @param font The bitmap font to use.
   * @param transform The transformation matrix.
   * @param color The text color.
   */
  public function drawBitmapText(x: FastFloat, y: FastFloat, text: String, font: BitmapFont, color: Color) {
    shapeRenderer.present();
    textRenderer.present();
    imageRenderer.drawBitmapText(x, y, text, font, transform, color);
  }

  /**
   * Set a shader pipeline for the renderers.
   * @param pipeline The shader pipeline.
   */
  public function setPipeline(?pipeline: Pipeline) {
    // Set the g4 pipeline so you can set shader parameters.
    if (pipeline != null) {
      g4.setPipeline(pipeline.state);
    }
    shapeRenderer.setPipeline(pipeline);
    imageRenderer.setPipeline(pipeline);
    textRenderer.setPipeline(pipeline);
  }

  /**
   * Set a boolean value for the current pipeline.
   * @param location The location in the shader.
   * @param value The new value.
   */
  public function setBool(location: ConstantLocation, value: Bool) {
    g4.setBool(location, value);
  }

  /**
   * Set an integer value for the current pipeline.
   * @param location The location in the shader.
   * @param value The new value.
   */
  public function setInt(location: ConstantLocation, value: Int) {
    g4.setInt(location, value);
  }

  /**
   * Set two integer values for the current pipeline.
   * @param location The location in the shader.
   * @param value1 The first new integer value.
   * @param value2 The second integer value.
   */
  public function setInt2(location: ConstantLocation, value1: Int, value2: Int) {
    g4.setInt2(location, value1, value2);
  }

  /**
   * Set three integer values for the current pipeline.
   * @param location The location in the shader.
   * @param value1 The first new integer value.
   * @param value2 The second integer value.
   * @param value3 The third integer value.
   */
  public function setInt3(location: ConstantLocation, value1: Int, value2: Int, value3: Int) {
    g4.setInt3(location, value1, value2, value3);
  }

  /**
   * Set four integer values for the current pipeline.
   * @param location The location in the shader.
   * @param value1 The first new integer value.
   * @param value2 The second integer value.
   * @param value4 The fourth integer value.
   */
  public function setInt4(location: ConstantLocation, value1: Int, value2: Int, value3: Int, value4: Int) {
    g4.setInt4(location, value1, value2, value3, value4);
  }

  /**
   * Set an array of integer for the current pipeline.
   * @param location The location in the shader.
   * @param values The new values.
   */
  public function setInts(location: ConstantLocation, values: Int32Array) {
    g4.setInts(location, values);
  }

  /**
   * Set a float value for the current pipeline.
   * @param location The location in the shader.
   * @param value The new value.
   */
  public function setFloat(location: ConstantLocation, value: FastFloat) {
    g4.setFloat(location, value);
  }

  /**
   * Set two float values for the current pipeline.
   * @param location The location in the shader.
   * @param value1 The first float value.
   * @param value2 The second float value.
   */
  public function setFloat2(location: ConstantLocation, value1: FastFloat, value2: FastFloat) {
    g4.setFloat2(location, value1, value2);
  }

  /**
   * Set three float values for the current pipeline.
   * @param location The location in the shader.
   * @param value1 The first float value.
   * @param value2 The second float value.
   * @param value3 The third float value.
   */
  public function setFloat3(location: ConstantLocation, value1: FastFloat, value2: FastFloat, value3: FastFloat) {
    g4.setFloat3(location, value1, value2, value3);
  }

  /**
   * Set four float values for the current pipeline.
   * @param location The location in the shader.
   * @param value1 The first float value.
   * @param value2 The second float value.
   * @param value3 The third float value.
   * @param value4 The fourth float value.
   */
  public function setFloat4(location: ConstantLocation, value1: FastFloat, value2: FastFloat, value3: FastFloat,
      value4: FastFloat) {
    g4.setFloat4(location, value1, value2, value3, value4);
  }

  /**
   * Set an array of float values for the current pipeline.
   * @param location The location in the shader.
   * @param values The new values.
   */
  public function setFloats(location: ConstantLocation, values: Float32Array) {
    g4.setFloats(location, values);
  }

  /**
   * Set a vector2 value for the current pipeline.
   * @param location The location in the shader.
   * @param value The new value.
   */
  public function setVector2(location: ConstantLocation, value: FastVector2) {
    g4.setVector2(location, value);
  }

  /**
   * Set a vector3 value for the current pipeline.
   * @param location The location in the shader.
   * @param value The new value.
   */
  public function setVector3(location: ConstantLocation, value: FastVector3) {
    g4.setVector3(location, value);
  }

  /**
   * Set a vector4 value for the current pipeline.
   * @param location The location in the shader.
   * @param value The new value.
   */
  public function setVector4(location: ConstantLocation, value: FastVector4) {
    g4.setVector4(location, value);
  }

  /**
   * Set a 4x4 matrix value for the current pipeline.
   * @param location The location in the shader.
   * @param value The new value.
   */
  public function setMatrix(location: ConstantLocation, value: FastMatrix4) {
    g4.setMatrix(location, value);
  }

  /**
   * Set a 3x3 matrix value for the current pipeline.
   * @param location The location in the shader.
   * @param value The new value.
   */
  public function setMatrix3(location: ConstantLocation, value: FastMatrix3) {
    g4.setMatrix3(location, value);
  }

  /**
   * Set a texture for the current pipeline.
   * @param unit The location in the shader.
   * @param texture The texture image.
   */
  public function setTexture(unit: TextureUnit, texture: Image) {
    g4.setTexture(unit, texture);
  }

  /**
   * Target width getter.
   */
  inline function get_width(): Int {
    return image.width;
  }

  /**
   * Target height getter.
   */
  inline function get_height(): Int {
    return image.height;
  }
}
