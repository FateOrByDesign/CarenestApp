import 'package:flutter/material.dart';
import 'screens/patient/patient_details.dart';
import 'screens/caregiver/caregiver_details.dart';
import 'screens/caregiver/caregiver_notification_page.dart';

void main() {
  runApp(const CareNestApp());
}

class CareNestApp extends StatelessWidget {
  const CareNestApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CareNest',
      theme: ThemeData(primarySwatch: Colors.teal),
      home: PatientDetailsPage(),
    );
  }
}
