import 'package:flutter/material.dart';
import 'package:upvia/constants.dart';
import 'package:upvia/model/habit.dart';
import 'package:upvia/providers/habits_provider.dart';
import 'package:upvia/util/util.dart';
import 'package:provider/provider.dart';
import 'package:upvia/widgets/habit_form.dart';

class NewHabitScreen extends StatefulWidget {
  const NewHabitScreen({super.key});

  @override
  State<NewHabitScreen> createState() => _NewHabitScreenState();
}

class _NewHabitScreenState extends State<NewHabitScreen> {
  bool isNameValid = false;
  final Habit newHabit =
      Habit(emoji: "📖", color: Constants.colors[0], name: "");


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }


  void _saveHabit() {
      final habitsProvider = Provider.of<HabitsProvider>(
        context,
        listen: false,
      );
      habitsProvider.upsertHabit(newHabit);
      Navigator.pop(context);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("New Habit"),
        actions: [
          IconButton(
            onPressed: isNameValid ? _saveHabit : null,
            icon: Icon(Icons.save),
            enableFeedback: false,
          ),
        ],
      ),
      body: HabitForm(habit: newHabit, onNameChanged: () {
        setState(() {
          isNameValid = Util.isValidString(newHabit.name);
        });
      },),
    );
  }
}
