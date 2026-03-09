import 'package:flutter/material.dart';
import '../../widgets/carereceiver_navigationbar_mobile.dart';

class CareReceiverDashboardPage extends StatelessWidget {
  const CareReceiverDashboardPage({super.key});

  static const routeName = '/patient/dashboard';

  static const _bg = Color(0xFFF7FAFA);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
          children: const [
            SizedBox(height: 2),
            _Header(),
            SizedBox(height: 16),
          ],
        ),
      ),
      bottomNavigationBar: const CareReceiverNavigationBarMobile(
        currentIndex: 0,
      ),
    );
  }
}

/* -------------------------------------------------------------------------- */
/*                                  HEADER                                    */
/* -------------------------------------------------------------------------- */

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return const Text(
      'Hi, Mr. Perera',
      style: TextStyle(
        fontSize: 26,
        fontWeight: FontWeight.w800,
        color: Color(0xFF0F172A),
        letterSpacing: -0.2,
      ),
    );
  }
}
