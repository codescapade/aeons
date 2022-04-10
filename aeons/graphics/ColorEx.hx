package aeons.graphics;

class ColorEx {
  /**
   * Get an interpolated color based on two different colors.
   * @param 	color1 The first color
   * @param 	color2 The second color
   * @param 	factor Where to mix the color. Value between 0 and 1.
   * @return	The interpolated color.
   */
  public static function interpolate(color1: Color, color2: Color, factor: Float): Color {
    final red  = Std.int((color2.Rb - color1.Rb) * factor + color1.Rb);
    final green = Std.int((color2.Gb - color1.Gb) * factor + color1.Gb);
    final blue = Std.int((color2.Bb - color1.Bb) * factor + color1.Bb);
    final alpha = Std.int((color2.Ab - color1.Ab) * factor + color1.Ab);

    return Color.fromBytes(red, green, blue, alpha);
  }
}
