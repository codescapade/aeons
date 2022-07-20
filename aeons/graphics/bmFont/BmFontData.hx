package aeons.graphics.bmFont;

using StringTools;

/**
 * Bitmap font information.
 */
class BmFontData {
  /**
   * Font height in pixels.
   */
  public var lineHeight(default, null): Int;

  /**
   * Character map.
   */
  var chars: Map<Int, BmFontChar>;

  /**
   * List of font kernings to get the correct space between letters.
   */
  var kernings: Array<BmFontKerning>;

  /**
   * cache text array.
   */
  var textCache: Array<BmFontChar>;

  /**
   * Constructor.
   * @param fontData The contents of the .fnt file. 
   */
  public function new(fontData: String) {
    chars = new Map<Int, BmFontChar>();
    kernings = [];
    textCache = [];

    var data = fontData.trim();
    var lines = ~/\r?\n/g.split(data);
    for (line in lines) {
      var temp = line.trim().split(' ');
      var segments: Array<String> = [];
      for (segment in temp) {
        if (segment != '') {
          segments.push(segment);
        }
      }
      if (segments.length == 0) {
        continue;
      }

      var lineName = segments[0];
      if (lineName == 'common') {
        lineHeight = getFontInfo(segments[1]);
      } else if (lineName == 'char') {
        var character = new BmFontChar(getFontInfo(segments[1]), getFontInfo(segments[2]), getFontInfo(segments[3]),
          getFontInfo(segments[4]), getFontInfo(segments[5]), getFontInfo(segments[6]), getFontInfo(segments[7]),
          getFontInfo(segments[8]));
        chars[character.id] = character;
      } else if (lineName == 'kerning') {
        var kerning = new BmFontKerning(getFontInfo(segments[1]), getFontInfo(segments[2]), getFontInfo(segments[3]));
        kernings.push(kerning);
      }
    }
  }

  /**
   * Get the char data for a string.
   * @param text The string to use.
   * @return The lis5 of char data.
   */
  public function getCharDataForText(text: String): Array<BmFontChar> {
    if (text.length >= textCache.length) {
      textCache.resize(text.length + 1);
    }

    var nextpos = 0;
    for (i in 0...text.length) {
      var code = text.charCodeAt(i);
      if (chars.exists(code)) {
        textCache[nextpos] = chars[code];
        nextpos++;
      } else {
        trace('Missing font data for character: ${text.charAt(i)}');
      }
    }
    textCache[nextpos] = null;

    return textCache;
  }

  /**
   * Get kerning amount between character.
   * @param charCode The current character code.
   * @param nextCharCode The next character code.
   * @return The pixel offset between the characters.
   */
  public function getKerning(charCode: Int, nextCharCode: Int): Int {
    var amount = 0;

    for (kerning in kernings) {
      if (kerning.firstId == charCode && kerning.secondId == nextCharCode) {
        amount = kerning.amount;
        break;
      }
    }

    return amount;
  }

  /**
   * Get the info after the '=' character in a segment.
   * @param segment The segment to check.
   * @return The info.
   */
  function getFontInfo(segment: String): Int {
    var split = segment.split('=');
    if (split.length != 2) {
      throw 'Incorrect segment format';
    }

    return Std.parseInt(split[1]);
  }
}
