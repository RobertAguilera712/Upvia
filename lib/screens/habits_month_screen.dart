import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:upvia/l10n/app_localizations.dart';
import 'package:upvia/providers/habits_provider.dart';
import 'package:upvia/util/util.dart';

class HabitsMonthScreen extends StatefulWidget {
  const HabitsMonthScreen({super.key});

  @override
  State<HabitsMonthScreen> createState() => _HabitsMonthScreenState();
}

class _HabitsMonthScreenState extends State<HabitsMonthScreen> {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final habitsProvider = context.watch<HabitsProvider>();
    return habitsProvider.habits.isEmpty
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
        : Column(
            children: [
              Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.all(16),
                  itemCount: habitsProvider.habits.length,
                  itemBuilder: (context, index) {
                    final habit = habitsProvider.habits[index];
                    bool isCompletedToday = habit.completionDates.contains(
                      habitsProvider.today,
                    );
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(habit.emoji, style: TextStyle(fontSize: 24)),
                              SizedBox(width: 8),
                              Text(habit.name, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
                              Expanded(child: Container()),
                              SizedBox(
                                width: 24,
                                height: 24,
                                child: Checkbox(
                                  value: isCompletedToday,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  materialTapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                  side: BorderSide(
                                    color: Util.hexToColor(habit.color),
                                    width: 2,
                                  ),
                                  onChanged: (bool? newValue) {
                                    // Habit was checked
                                    if (newValue == true) {
                                      habit.completionDates.add(
                                        habitsProvider.today,
                                      );
                                    } else {
                                      // Habit was unchecked
                                      habit.completionDates.remove(
                                        habitsProvider.today,
                                      );
                                    }
                                    habitsProvider.upsertHabit(habit);
                                    setState(() {
                                      isCompletedToday = newValue ?? false;
                                    });
                                  },
                                  fillColor: WidgetStateColor.resolveWith((
                                    states,
                                  ) {
                                    if (states.contains(WidgetState.selected)) {
                                      return Util.hexToColor(
                                        habit.color,
                                      ); // Color when selected
                                    }
                                    return Colors.transparent; //
                                  }),
                                ),
                              ),
                            ],
                          ),
                          LayoutBuilder(
                            builder: (context, constraints) {
                              final double cellSize =
                                  (constraints.maxWidth / 26) - 4;

                              return Column(
                                children: List.generate(7, (colIndex) {
                                  return Row(
                                    children: List.generate(26, (rowIndex) {
                                      final index = rowIndex * 7 + colIndex;

                                      if (index >=
                                          habitsProvider.semesterDays.length) {
                                        return SizedBox(width: cellSize + 4);
                                      }

                                      final day =
                                          habitsProvider.semesterDays[index];
                                      final completed = habit.completionDates
                                          .contains(day);

                                      return Container(
                                        margin: const EdgeInsets.all(2),
                                        width: cellSize,
                                        height: cellSize,
                                        decoration: BoxDecoration(
                                          color: completed
                                              ? Util.hexToColor(habit.color)
                                              : Util.hexToColor(
                                                  habit.color,
                                                ).withAlpha(60),
                                          borderRadius: BorderRadius.circular(
                                            4,
                                          ),
                                        ),
                                      );
                                    }),
                                  );
                                }),
                              );
                            },
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          );
  }
}
