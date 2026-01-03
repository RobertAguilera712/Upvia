// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get habitsTitle => 'Hábitos';

  @override
  String get emptyTitle => 'No hay hábitos';

  @override
  String get emptySubtitle => 'Presiona + para agregar uno';

  @override
  String get newHabitTitle => 'Nuevo Hábito';

  @override
  String get editHabitTitle => 'Editar Hábito';

  @override
  String get habitNameLabel => 'Nombre del Hábito';
}
