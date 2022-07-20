package aeons.graphics.bmFont;

/**
 * Kerning offset between two character.
 */
class BmFontKerning {
  /**
   * The character code on the left.
   */
  public var firstId(default, null): Int;

  /**
   * The character code on the right.
   */
  public var secondId(default, null): Int;

  /**
   * The offset amount in pixels.
   */
  public var amount(default, null): Int;

  /**
   * Constructor.
   * @param firstId First character code.
   * @param secondId Second character code.
   * @param amount Offset amount.
   */
  public function new(firstId: Int, secondId: Int, amount: Int) {
    this.firstId = firstId;
    this.secondId = secondId;
    this.amount = amount;
  }
}
