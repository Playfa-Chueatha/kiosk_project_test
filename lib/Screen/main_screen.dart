import 'package:flutter/material.dart';
import 'package:kiosk_project_test/widget/left_panelMainhome.dart';
import 'package:kiosk_project_test/widget/right_panelMainhome.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      body: Row(
        children: [
          Expanded(
            flex: 8,
            child: LeftPanel(),
          ),
          Expanded(
            flex: 2,
            child: RightPanel(),
          ),
        ],
      ),
    );
  }
}
