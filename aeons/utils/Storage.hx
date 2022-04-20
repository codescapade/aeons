package aeons.utils;

/**
 * Save and load saveData. On some platforms like html5 this writes to localstorage that will be erased
 * when clearing browser data.
 */
interface Storage {
  /**
   * Read blob data.
   * @param name The name of the save.
   * @return The loaded blob data.
   */
  function readData(name: String): Blob;

  /**
   * Read a string.
   * @param name The name of the save.
   * @return The loaded string.
   */
  function readString(name: String): String;

  /**
   * Read an object. The data is save as a string. This unserializes the data.
   * @param name The name of the save.
   * @return The loaded object.
   */
  function readObject(name: String): Dynamic;

  /**
   * Write blob data to a save.
   * @param name The name of the save.
   * @param data The data to save.
   */
  function writeData(name: String, data: Blob): Void;

  /**
   * Write a string to a save.
   * @param name The name of the save.
   * @param data The string to save.
   */
  function writeString(name: String, data: String): Void;

  /**
   * Write an object to a save. This serializes the data and save it as a string.
   * @param name The name of the save.
   * @param data The data to save.
   */
  function writeObject(name: String, data: Dynamic): Void;

  /**
   * Append blob data to an existing save.
   * @param name The name of the save.
   * @param data The data to append.
   */
  function appendData(name: String, data: Blob): Void;

  /**
   * Append string data to an existing save.
   * @param name The name of the save.
   * @param data The data to append.
   */
  function appendString(name: String, data: String): Void;

  /**
   * Check if it is possible to append data to a save.
   * @param name The name of the save.
   * @return True if the data can be appended to.
   */
  function canAppend(name: String): Bool;
}
