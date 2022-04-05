package aeons.graphics;

import kha.graphics4.BlendingFactor;
import kha.graphics4.PipelineState;

/**
 * The Pipeline class is used to store and use shaders.
 */
class Pipeline {
  /**
   * The matrix projection shader location.
   */
  public final projectionLocation: ConstantLocation;

  /**
   * The texture shader location.
   */
  public final textureLocation: TextureUnit;

  /**
   * The internal pipeline state.
   */
  public final state: PipelineState;

  /**
   * The vertex shader structure.
   */
  public final structure: VertexStructure;

  public function new(vertexShader: VertexShader, fragmentShader: FragmentShader, hasTexture: Bool,
      blendSource = BlendingFactor.BlendOne, blendDestination = BlendingFactor.InverseSourceAlpha,
      alphaBlendSource = BlendingFactor.BlendOne, alphaBlendDestination = BlendingFactor.InverseSourceAlpha) {
    structure = new VertexStructure();
    structure.add('vertexPosition', Float3);
    if (hasTexture) {
      structure.add('vertexUV', Float2);
    }
    structure.add('vertexColor', Float4);
    state = new PipelineState();
    state.vertexShader = vertexShader;
    state.fragmentShader = fragmentShader;
    state.inputLayout = [structure];
    state.blendSource = blendSource;
    state.blendDestination = blendDestination;
    state.alphaBlendSource = alphaBlendSource;
    state.alphaBlendDestination = alphaBlendDestination;
    state.compile();

    projectionLocation = state.getConstantLocation('projectionMatrix');

    if (hasTexture) {
      textureLocation = state.getTextureUnit('tex');
    }
  }
}