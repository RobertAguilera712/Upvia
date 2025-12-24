import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:chikua/providers/habits_provider.dart';
import 'package:chikua/util/util.dart';
import 'package:chikua/widgets/habit_check.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class HabitsScreen extends StatelessWidget {
  const HabitsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final habitsProvider = context.watch<HabitsProvider>();

    return Scaffold(
      appBar: AppBar(
        title: Text("Habits"),
        actions: [
          IconButton(
            onPressed: () {
              // Go to new habit screen
              Navigator.pushNamed(context, '/habits/add');
            },
            icon: Icon(Icons.add),
          ),
        ],
      ),
      body: habitsProvider.habits.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.list, size: 70),
                  Text(
                    "No Habits",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  Text("Tap the + to add one"),
                ],
              ),
            )
          : Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 8.0,
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        flex: 1, // Takes 1 part of 4 total parts (1+3)
                        child: Container(),
                      ),
                      Expanded(
                        flex: 2, // Takes 3 parts of 4 total parts (1+3)
                        child: Row(
                          children: List.generate(
                            habitsProvider.weekDays.length,
                            (index) {
                              return Expanded(
                                child: AspectRatio(
                                  aspectRatio: 1,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Colors.grey,
                                        style: BorderStyle.solid,
                                      ),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    margin: EdgeInsets.all(4),
                                    child: Center(
                                      child: Text(
                                        DateFormat("E")
                                            .format(
                                              habitsProvider.weekDays[index],
                                            )
                                            .substring(0, 1),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: habitsProvider.habits.length,
                      itemBuilder: (context, index) {
                        final habit = habitsProvider.habits[index];
                        return Slidable(
                          key: ValueKey(habit.id),
                          startActionPane: ActionPane(
                            motion: const DrawerMotion(),
                            extentRatio: 0.15,
                            children: [
                              SlidableAction(
                                onPressed: (context) {
                                  habitsProvider.deleteHabit(habit);
                                },
                                backgroundColor: Colors.red,
                                foregroundColor: Colors.white,
                                icon: Icons.delete,
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 1,
                                child: InkWell(
                                  onTap: () {
                                    habitsProvider.selectedHabit = habit;
                                    Navigator.pushNamed(context, '/habits/edit');
                                  },
                                  child: Row(
                                    spacing: 8,
                                    children: [
                                      Text(
                                        habit.emoji,
                                        style: TextStyle(fontSize: 24),
                                      ),
                                      // Why does it overflow here???
                                      Expanded(
                                        child: Text(
                                          habit.name,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Row(
                                  children: List.generate(7, (index) {
                                    return HabitCheck(
                                      borderColor: Util.hexToColor(habit.color),
                                      accentColor: Util.getAccentColor(
                                        habit.color,
                                      ),
                                      isChecked: habit.completionDates.contains(
                                        habitsProvider.weekDays[index],
                                      ),
                          
                                      onCheck: () {
                                        // Habit was unchecked
                                        if (habit.completionDates.contains(
                                          habitsProvider.weekDays[index],
                                        )) {
                                          habit.completionDates.remove(
                                            habitsProvider.weekDays[index],
                                          );
                                          // Habit was checked
                                        } else {
                                          habit.completionDates.add(
                                            habitsProvider.weekDays[index],
                                          );
                                        }
                                        habitsProvider.upsertHabit(habit);
                                      },
                                    );
                                  }),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
