import 'package:isar_community/isar.dart';
import 'package:upvia/model/habit.dart';
import 'package:flutter/material.dart';

class HabitsProvider extends ChangeNotifier {
  final Isar isar;
  List<Habit> _habits = [];
  List<Habit> get habits => _habits;

  Habit? selectedHabit;

  final List<DateTime> fullWeekDays = List.generate(7, (index) {
    final start = DateTime.now();
    return DateTime(start.year, start.month, start.day - 6 + index);
  });

  final List<DateTime> semesterDays = List.generate(25 * 7, (index) {
    final today = DateTime.now();
    debugPrint("Today:");
    debugPrint(today.toString());
    final start = today.subtract(Duration(days: today.weekday));
    return DateTime(start.year, start.month, start.day - (25 * 7) + index);
  });

  final List<DateTime> _weekDays = List.generate(DateTime.now().weekday + 1, (
    index,
  ) {
    final today = DateTime.now();
    final start = today;
    return DateTime(
      start.year,
      start.month,
      start.day - (today.weekday) + index,
    );
  });

  late DateTime today;

  HabitsProvider({required this.isar}) {
    _loadHabits();
    semesterDays.addAll(_weekDays);
    today = fullWeekDays.last;
  }
  Future<void> _loadHabits() async {
    _habits = await isar.habits.where().findAll();
    notifyListeners();
  }

  Future<void> upsertHabit(Habit habit) async {
    await isar.writeTxn(() async {
      await isar.habits.put(habit);
    });
    _loadHabits();
  }

  Future<void> deleteHabit(Habit habit) async {
    await isar.writeTxn(() async {
      await isar.habits.delete(habit.id);
    });
    _loadHabits();
  }
}
