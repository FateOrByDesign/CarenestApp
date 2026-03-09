import 'package:flutter/material.dart';
import '../../widgets/caregiver_navigationbar_mobile.dart';

class CaregiverDashboardPage extends StatelessWidget {
  const CaregiverDashboardPage({super.key});

  // ✅ MUST match navbar + main.dart
  static const routeName = '/caregiver/dashboard';

  // Colors tuned to match the UI
  static const _bg = Color(0xFFF7FAFA);
  static const _cardBorder = Color(0xFFE7EEF0);
  static const _textDark = Color(0xFF0F172A);
  static const _textSoft = Color(0xFF7A8A96);
  static const _primary = Color(0xFF16A394);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Expanded(
                  child: Text(
                    'Hi, Caregiver',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w800,
                      color: _textDark,
                      letterSpacing: -0.2,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                const CircleAvatar(
                  radius: 18,
                  backgroundColor: Color(0xFFE9F3F2),
                  child: Icon(Icons.person, color: _textSoft, size: 20),
                ),
              ],
            ),
            const SizedBox(height: 18),
          ],
        ),
      ),

      // ✅ EASY APPLY: just this line
      bottomNavigationBar: const CaregiverNavigationBarMobile(currentIndex: 0),
    );
  }
}
