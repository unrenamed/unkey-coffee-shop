import 'dart:math';

int durationToTimestamp(String duration) {
  final now = DateTime.now().millisecondsSinceEpoch;

  // Regular expression to match the format
  final regex = RegExp(r'(\d+)([mhdw])');
  final match = regex.firstMatch(duration);

  if (match == null) {
    throw const FormatException('Invalid duration format');
  }

  // Extract the number and the unit
  final number = int.parse(match.group(1)!);
  final unit = match.group(2);

  // Calculate the timestamp based on the unit
  int millis;
  switch (unit) {
    case 'm':
      millis = number * 60 * 1000; // minutes to milliseconds
      break;
    case 'h':
      millis = number * 60 * 60 * 1000; // hours to milliseconds
      break;
    case 'd':
      millis = number * 24 * 60 * 60 * 1000; // days to milliseconds
      break;
    case 'w':
      millis = number * 7 * 24 * 60 * 60 * 1000; // weeks to milliseconds
      break;
    default:
      throw const FormatException('Invalid time unit');
  }

  return now + millis;
}

int generateRandomTenToHundred() {
  // Generate a random index from 1 to 10 (inclusive) and multiply by 10
  final random = Random();
  return (random.nextInt(10) + 1) * 10;
}
