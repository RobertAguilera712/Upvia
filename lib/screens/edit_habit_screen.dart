import 'package:upvia/providers/habits_provider.dart';
import 'package:flutter/material.dart';
import 'package:upvia/model/habit.dart';
import 'package:upvia/util/util.dart';
import 'package:provider/provider.dart';
import 'package:upvia/widgets/habit_form.dart';

class EditHabitScreen extends StatefulWidget {
  const EditHabitScreen({super.key});

  @override
  State<EditHabitScreen> createState() => _EditHabitScreenState();
}

class _EditHabitScreenState extends State<EditHabitScreen> {
  bool isNameValid = true;
  late HabitsProvider habitsProvider;
  late Habit editedHabit;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    habitsProvider = Provider.of<HabitsProvider>(context, listen: false);
    editedHabit = habitsProvider.selectedHabit!;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  void _saveHabit() {
    // Add the new habit to the provider or database
    habitsProvider.upsertHabit(editedHabit);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Habit"),
        actions: [
          IconButton(
            onPressed: isNameValid ? _saveHabit : null,
            icon: Icon(Icons.save),
            enableFeedback: false,
          ),
        ],
      ),
      body: HabitForm(
        habit: editedHabit,
        defaultEmoji: editedHabit.emoji,
        defaultColorHex: editedHabit.color,
        defaultName: editedHabit.name,
        onNameChanged: () {
          setState(() {
            isNameValid = Util.isValidString(editedHabit.name);
          });
        },
      ),
    );
  }
}
