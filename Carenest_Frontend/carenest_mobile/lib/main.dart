import 'package:flutter/material.dart';
import 'screens/caregiver_dashboard.dart';

void main() {
  runApp(const CareNestApp());
}

class CareNestApp extends StatelessWidget {
  const CareNestApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CareNest',
      theme: ThemeData(primarySwatch: Colors.teal),
      home: const CaregiverDashboard(),
    );
  }
}
