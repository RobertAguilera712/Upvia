import 'package:flutter/material.dart';

class TabsScreen extends StatelessWidget {
  const TabsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Upvia'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Day'),
              Tab(text: 'Week'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            Center(child: Text('Day View')),
            Center(child: Text('Month View')),
          ],
        ),
      ),
    );
  }
}
