import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:keyboard_emoji_picker/keyboard_emoji_picker.dart';
import 'package:upvia/constants.dart';
import 'package:upvia/model/habit.dart';
import 'package:upvia/util/util.dart';

class HabitForm extends StatefulWidget {
  final String? defaultEmoji;
  final String? defaultColorHex;
  final String? defaultName;
  final Habit habit;
  final VoidCallback? onNameChanged;

  HabitForm({
    super.key,
    required this.habit,
    this.onNameChanged,
    this.defaultEmoji = "📖",
    this.defaultColorHex = "#DC7171",
    this.defaultName = "",
  });

  @override
  State<HabitForm> createState() => _HabitFormState();
}

class _HabitFormState extends State<HabitForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  late String _selectedEmoji;
  bool _emojiShowing = false;

  late String? _colorHex;
  late Color _selectedColor;
  late Habit _habit;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _habit = widget.habit;
    _selectedEmoji = widget.defaultEmoji!;
    _colorHex = widget.defaultColorHex!;
    _selectedColor = Util.hexToColor(_colorHex!);
    _nameController.text = widget.defaultName!;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _formKey.currentState?.dispose();
    _nameController.dispose();
  }

  void _pickEmoji() async {
    FocusScope.of(context).unfocus();
    final hasEmojiKeyboard = await KeyboardEmojiPicker()
        .checkHasEmojiKeyboard();

    if (!hasEmojiKeyboard) {
      // Show some error or fallback UI
      setState(() {
        _emojiShowing = true;
      });
      return;
    }

    final emoji = await KeyboardEmojiPicker().pickEmoji();
    if (emoji != null) {
      setState(() {
        _selectedEmoji = emoji;
        _habit.emoji = _selectedEmoji;
        // ValidateForm
      });
    } else {
      // The emoji picking process was cancelled (usually, the keyboard was closed).
    }
  }

  void _onEmojiSelected(Category? category, Emoji emoji) {
    setState(() {
      _selectedEmoji = emoji.emoji;
      _emojiShowing = false;
      _habit.emoji = _selectedEmoji;
    });
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardEmojiPickerWrapper(
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
                  child: Text(_selectedEmoji, style: TextStyle(fontSize: 60)),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: RadioGroup<String>(
                groupValue: _colorHex,
                onChanged: (String? value) {
                  setState(() {
                    _colorHex = value;
                    _selectedColor = Util.hexToColor(_colorHex!);
                    _habit.color = _colorHex!;
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
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: "Habit Name",
                  border: OutlineInputBorder(),
                ),
                validator: Util.validateStringField,
                onTap: () {
                  setState(() {
                    _emojiShowing = false;
                  });
                },
                onChanged: (value) {
                  setState(() {
                    _habit.name = value;
                    widget.onNameChanged?.call();
                  });
                },
              ),
            ),
            if (_emojiShowing)
              Expanded(
                child: EmojiPicker(
                  onEmojiSelected: _onEmojiSelected,
                  // Do something when emoji is tapped (optional)
                ),
              ),
      
            // Offstage(
            //   offstage: !_emojiShowing,
            //   child: EmojiPicker(
            //     onEmojiSelected: _onEmojiSelected,
            //     // Do something when emoji is tapped (optional)
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
