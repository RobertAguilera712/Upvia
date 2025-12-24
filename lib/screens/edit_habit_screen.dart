import 'package:chikua/providers/habits_provider.dart';
import 'package:flutter/material.dart';
import 'package:chikua/constants.dart';
import 'package:chikua/model/habit.dart';
import 'package:chikua/util/util.dart';
import 'package:keyboard_emoji_picker/keyboard_emoji_picker.dart';
import 'package:provider/provider.dart';

class EditHabitScreen extends StatefulWidget {
  const EditHabitScreen({super.key});

  @override
  State<EditHabitScreen> createState() => _EditHabitScreenState();
}

class _EditHabitScreenState extends State<EditHabitScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  late String _selectedEmoji;
  bool isNameValid = true;

  late String? _colorHex;
  late Color _selectedColor;
  late HabitsProvider habitsProvider;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    habitsProvider = Provider.of<HabitsProvider>(context, listen: false);
    _selectedEmoji = habitsProvider.selectedHabit?.emoji ?? "📖";
    _colorHex = habitsProvider.selectedHabit?.color ?? Constants.colors[0];
    _selectedColor = Util.hexToColor(_colorHex!);
    _nameController.text = habitsProvider.selectedHabit?.name ?? "";
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _formKey.currentState?.dispose();
    _nameController.dispose();
  }

  void _pickEmoji() async {
    final emoji = await KeyboardEmojiPicker().pickEmoji();
    if (emoji != null) {
      setState(() {
        _selectedEmoji = emoji;
        // ValidateForm
      });
    } else {
      // The emoji picking process was cancelled (usually, the keyboard was closed).
    }
  }

  void _saveHabit() {
    if (_formKey.currentState!.validate()) {
      // Save the habit
      final name = _nameController.text.trim();
      final color = _colorHex!;
      final emoji = _selectedEmoji;

      Habit editedHabit = habitsProvider.selectedHabit!;
      editedHabit.name = name;
      editedHabit.color = color;
      editedHabit.emoji = emoji;
      // Add the new habit to the provider or database
      habitsProvider.upsertHabit(editedHabit);
      Navigator.pop(context);
    }
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
      body: KeyboardEmojiPickerWrapper(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              spacing: 16.0,
              children: [
                Center(
                  child: InkWell(
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    onTap: _pickEmoji,
                    child: CircleAvatar(
                      radius: 60,
                      backgroundColor: _selectedColor,
                      child: Text(
                        _selectedEmoji,
                        style: TextStyle(fontSize: 60),
                      ),
                    ),
                  ),
                ),
                RadioGroup<String>(
                  groupValue: _colorHex,
                  onChanged: (String? value) {
                    setState(() {
                      _colorHex = value;
                      _selectedColor = Util.hexToColor(_colorHex!);
                    });
                  },
                  child: GridView.count(
                    crossAxisCount: 6,
                    shrinkWrap: true,
                    children: List.generate(Constants.colors.length, (index) {
                      Color color = Util.hexToColor(Constants.colors[index]);
                      return Transform.scale(
                        scale: 2.0,
                        child: Radio<String>(
                          backgroundColor: WidgetStatePropertyAll(color),
                          overlayColor: WidgetStateColor.resolveWith((states) {
                            if (states.contains(WidgetState.hovered) ||
                                states.contains(WidgetState.pressed)) {
                              return Colors.black12;
                            }
                            return color;
                          }),
                          activeColor: Colors.black26,
                          side: BorderSide(color: color, width: 2),
                          value: Constants.colors[index],
                          innerRadius: WidgetStatePropertyAll(2),
                        ),
                      );
                    }),
                  ),
                ),
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: "Habit Name",
                    border: OutlineInputBorder(),
                  ),
                  validator: Util.validateStringField,
                  onChanged: (value) {
                    setState(() {
                      isNameValid = Util.isValidString(value);
                    });
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
