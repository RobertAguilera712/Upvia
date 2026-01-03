import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:isar_community/isar.dart';
import 'package:upvia/constants.dart';
import 'package:upvia/model/habit.dart';
import 'package:upvia/providers/habits_provider.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  final dir = await getApplicationDocumentsDirectory();
  final Isar isar = await Isar.open([HabitSchema], directory: dir.path);

  runApp(MainApp(isar: isar));
}

class MainApp extends StatelessWidget {
  final Isar isar;
  MainApp({super.key, required this.isar});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => HabitsProvider(isar: isar)),
      ],
      child: MaterialApp(
        initialRoute: '/home',
        routes: Constants.routes,
        theme: Constants.mainTheme,
        debugShowCheckedModeBanner: false,
        title: "Habits",
      ),
    );
  }
}
