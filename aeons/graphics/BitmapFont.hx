package aeons.graphics;

import aeons.graphics.bmFont.BmFontChar;
import aeons.graphics.bmFont.BmFontData;

/**
 * Bitmap font class.
 */
class BitmapFont {
  /**
   * The image with the font characters.
   */
  public var image(default, null): Image;

  /**
   * The font height in pixels.
   */
  public var height(get, never): Int;

  /**
   * The .fnt data.
   */
  var fontData: BmFontData;

  /**
   * Constructor.
   * @param image Font image.
   * @param data content of .fnt data file.
   */
  public function new(image: Image, data: String) {
    this.image = image;
    fontData = new BmFontData(data);
  }

  /**
   * Get render data for a string.
   * @param text The text to check.
   * @return A list of character render data.
   */
  public inline function getTextData(text: String): Array<BmFontChar> {
    return fontData.getCharDataForText(text);
  }

  /**
   * Get the offset between two characters.
   * @param charCode The current character.
   * @param nextCharCode The next character to the right.
   * @return The offset.
   */
  public inline function getKerning(charCode: Int, nextCharCode: Int): Int {
    return fontData.getKerning(charCode, nextCharCode);
  }

  /**
   * Get the width in pixels of the string using this font.
   * @param text The string to check.
   * @return The width in pixels.
   */
  public function width(text: String): Int {
    var length = 0;
    var textData = getTextData(text);

    for (i in 0...textData.length) {
      var charData = textData[i];
      if (charData == null) {
        break;
      }

      length += charData.xAdvance;
      if (i > 0) {
        var prevElem = textData[i - 1];
        length += getKerning(prevElem.id, charData.id);
      }
    }

    return length;
  }

  inline function get_height(): Int {
    return fontData.lineHeight;
  }
}
