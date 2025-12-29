
import 'package:isar_community/isar.dart';

part 'habit.g.dart';

@Collection()
class Habit {
  Id id = Isar.autoIncrement;
  String emoji;
  String color;
  String name;

  List<DateTime> completionDates = [];
  int currentStreak = 0;
  int longestStreak = 0;

  Habit({required this.emoji, required this.color, required this.name});
}
