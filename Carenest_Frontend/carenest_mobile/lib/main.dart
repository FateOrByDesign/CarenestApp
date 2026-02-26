import 'package:flutter/material.dart';
// main screens
import 'screens/login_screen.dart';
import 'screens/splash_screen.dart';
import 'screens/reset_password_screen.dart';
// patient screens
import 'screens/patient/patient_register_page.dart';
import 'screens/patient/patient_profile_page.dart';
import 'screens/patient/carereceiver_dashboard_page.dart';
import 'screens/patient/patient_details.dart';
import 'screens/patient/request_caregiver.dart';
import 'screens/patient/patient_notification_page.dart';
// caregiver screens
import 'screens/caregiver/caregiver_register_page.dart';
import 'screens/caregiver/caregiver_profile_page.dart';
import 'screens/caregiver/caregiver_dashboard_page.dart';
import 'screens/caregiver/caregiver_details.dart';
import 'screens/caregiver/update_caregiver_status.dart';
import 'screens/caregiver/caregiver_notification_page.dart';
import 'package:carenest_mobileapp/screens/caregiver/caregiver_authentication_page.dart';
// common screens
import 'pages/role_select_page.dart';

void main() {
  runApp(const CareNestApp());
}

class CareNestApp extends StatelessWidget {
  const CareNestApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CareNest',
      theme: ThemeData(primarySwatch: Colors.teal),
      home: CaregiverAuthenticationPage(
        username: 'perera', // your custom username
        password: '12345', // your custom password
      ),
      debugShowCheckedModeBanner: false,

      // --- Initial Route ---
      initialRoute: '/',

      routes: {
        '/': (context) => const SplashScreen(),
        '/login': (context) => const LoginScreen(),
        '/reset-password': (context) => const ResetPasswordScreen(),
        '/select-role': (context) => const RoleSelectPage(),

        // --- Patient Routes ---
        '/patient/register': (context) => const RegisterPatientScreen(),
        '/patient/profile': (context) => const PatientProfilePage(),
        '/patient/dashboard': (context) => const CareReceiverDashboardPage(),
        '/patient/details': (context) => const PatientDetailsPage(),
        '/patient/request-caregiver': (context) => const RequestCarePage(),
        '/patient/notifications': (context) => const PatientNotificationsPage(),

        // --- Caregiver Routes ---
        '/caregiver/register': (context) => const RegisterCaregiverScreen(),
        '/caregiver/profile': (context) => const CaregiverProfilePage(),
        '/caregiver/profile': (context) => const CaregiverProfilePage(),
        '/caregiver/dashboard': (context) => const CaregiverDashboardPage(),
        '/caregiver/details': (context) => const CaregiverDetailsPage(),
        '/caregiver/notifications': (context) =>
            const CaregiverNotificationsPage(),
        // '/caregiver/update-status': (context) => const UpdateCareStatusPage(),
      },
    );
  }
}
