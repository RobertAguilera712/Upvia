import 'package:chikua/model/habit.dart';
import 'package:flutter/material.dart';
import 'package:isar/isar.dart';

class HabitsProvider extends ChangeNotifier {
  final Isar isar;
  List<Habit> _habits = [];
  List<Habit> get habits => _habits;

  Habit? selectedHabit;

  final List<DateTime> weekDays = List.generate(7, (index) {
    final start = DateTime.now();
    return DateTime(start.year, start.month, start.day - 6 + index);
  });


  HabitsProvider({required this.isar}) {
    _loadHabits();
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
