import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:upvia/l10n/app_localizations.dart';
import 'package:upvia/providers/habits_provider.dart';
import 'package:upvia/util/util.dart';
import 'package:upvia/widgets/habit_check.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class HabitsScreen extends StatelessWidget {
  const HabitsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final habitsProvider = context.watch<HabitsProvider>();
    final l10n = AppLocalizations.of(context)!;
    final today = DateTime.now().weekday;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.habitsTitle),
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
                    l10n.emptyTitle,
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  Text(l10n.emptySubtitle),
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
                              final day = habitsProvider.weekDays[index];
                              return Expanded(
                                child: AspectRatio(
                                  aspectRatio: 1,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: day.weekday == today
                                          ? Color.fromARGB(15, 0, 0, 0)
                                          : Colors.transparent,
                                      border: Border.all(
                                        color: Colors.grey,
                                        style: BorderStyle.solid,
                                      ),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    margin: EdgeInsets.all(4),
                                    child: Center(
                                      child: Text(
                                        DateFormat(
                                              "E",
                                              Localizations.localeOf(
                                                context,
                                              ).toString(),
                                            )
                                            .format(day)
                                            .toUpperCase()
                                            .substring(0, 1),
                                        style: TextStyle(
                                          fontWeight: day.weekday == today
                                              ? FontWeight.bold
                                              : FontWeight.normal,
                                        ),
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
                                    Navigator.pushNamed(
                                      context,
                                      '/habits/edit',
                                    );
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
