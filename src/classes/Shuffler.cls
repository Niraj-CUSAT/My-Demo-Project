public class Shuffler {

  /**
   * Gets a random integer number between lower (inclusive) and upper (exclusive)
   */
  public static Integer getRandomInt (Integer lower, Integer upper)
  {
    return Math.round(Math.random() * (upper - lower)) + lower;
  }
}