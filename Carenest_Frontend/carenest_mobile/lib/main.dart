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
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: _StartupGate(),
    );
  }
}

class _StartupGate extends StatelessWidget {
  const _StartupGate();

  // @override
  // Widget build(BuildContext context) {
  //   return FutureBuilder<UserRole?>(
  //     future: RoleStorage.getRole(),
  //     builder: (context, snapshot) {
  //       // Loading state
  //       if (snapshot.connectionState == ConnectionState.waiting) {
  //         return const Scaffold(
  //           body: Center(child: CircularProgressIndicator()),
  //         );
  //       }

  //       final role = snapshot.data;

  //       if (role == UserRole.caregiver) {
  //         return const CaregiverDashboardPage();
  //       }

  //       if (role == UserRole.careReceiver) {
  //         return const CareReceiverDashboardPage();
  //       }

  //       return const RoleSelectPage();
  //     },
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: RoleSelectPage(),
    );
  }
}
