import 'package:flutter/material.dart';
import 'package:upvia/l10n/app_localizations.dart';
import 'package:upvia/screens/habits_month_screen.dart';
import 'package:upvia/screens/habits_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Upvia'),
          actions: [
            IconButton(
              onPressed: () {
                // Go to new habit screen
                Navigator.pushNamed(context, '/habits/add');
              },
              icon: Icon(Icons.add),
            ),
          ],
          bottom: TabBar(
            tabs: [
              Tab(text: l10n.weeklyLabel),
              Tab(text: l10n.monthlyLabel),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            HabitsScreen(),
            HabitsMonthScreen(),
          ],
        ),
      ),
    );
  }
}
