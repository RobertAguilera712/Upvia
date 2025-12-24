import 'package:flutter/material.dart';

// ignore: must_be_immutable
class HabitCheck extends StatefulWidget {
  final bool isChecked;
  final VoidCallback? onCheck;

  Color borderColor;
  Color accentColor;

  HabitCheck({
    super.key,
    this.isChecked = false,
    required this.borderColor,
    required this.accentColor,
    this.onCheck,
  });

  @override
  State<HabitCheck> createState() => _HabitCheckState();
}

class _HabitCheckState extends State<HabitCheck> {
  late bool _isChecked;

  @override
  void initState() {
    super.initState();
    _isChecked = widget.isChecked;
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: AspectRatio(
        aspectRatio: 1,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 350),
          curve: Curves.easeOutCubic,
          margin: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            border: Border.all(color: widget.borderColor),
            borderRadius: BorderRadius.circular(8),
            gradient: _isChecked
                ?  LinearGradient(
                    colors: [widget.borderColor, widget.borderColor],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: [0.0, 0.0],
                  )
                : null, // ← important
          ),
          child: InkWell(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            onTap: () {
              setState(() {
                widget.onCheck?.call();
                _isChecked = !_isChecked;
              });
            },
          ),
        ),
      ),
    );
  }
}
