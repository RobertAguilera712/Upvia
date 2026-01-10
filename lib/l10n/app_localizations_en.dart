// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get habitsTitle => 'Habits';

  @override
  String get emptyTitle => 'No Habits';

  @override
  String get emptySubtitle => 'Tap the + to add one';

  @override
  String get newHabitTitle => 'New Habit';

  @override
  String get editHabitTitle => 'Edit Habit';

  @override
  String get habitNameLabel => 'Habit Name';

  @override
  String get weeklyLabel => '1 Week';

  @override
  String get monthlyLabel => '6 Months';
}
