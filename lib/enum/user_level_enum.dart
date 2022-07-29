enum Level {
  beginner,
  intermediate,
  advanced,
}
extension LevelExtension on Level {
String get string {
  switch (this) {
    case Level.beginner:
      return "beginner";
    case Level.intermediate :
      return "intermediate";
    case Level.advanced:
      return "advanced";
      default:
      return "beginner";
  }
}
}