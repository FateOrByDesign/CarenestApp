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

            Row(
              children: [
                Expanded(
                  child: _StatCard(
                    title: "Today's visits",
                    value: '2',
                    valueColor: _textDark,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: _StatCard(
                    title: 'This month',
                    value: 'LKR 5000',
                    valueColor: _primary,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 18),

            const _NextVisitCard(),

            const SizedBox(height: 18),

            const Text(
              'History',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: _textDark,
              ),
            ),

            const SizedBox(height: 12),

            const _JobCard(
              tag: 'HOSPITAL VISIT - COMPLETED',
              price: "Sahan Fernando",
              time: '23/01/2026',
            ),

            const SizedBox(height: 12),

            const _JobCard(
              tag: 'HOME VISIT - COMPLETED',
              price: "Sathika Perera",
              time: '05/02/2026',
            ),
          ],
        ),
      ),

      // ✅ EASY APPLY: just this line
      bottomNavigationBar: const CaregiverNavigationBarMobile(currentIndex: 0),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final Color valueColor;

  static const _cardBorder = Color(0xFFE7EEF0);
  static const _textSoft = Color(0xFF7A8A96);

  const _StatCard({
    required this.title,
    required this.value,
    required this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 110,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: _cardBorder),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: _textSoft,
            ),
          ),
          const Spacer(),
          Text(
            value,
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w900,
              color: valueColor,
              letterSpacing: -0.3,
            ),
          ),
        ],
      ),
    );
  }
}

class _NextVisitCard extends StatelessWidget {
  static const _primary = Color(0xFF16A394);
  static const _textSoftOnDark = Color(0xFFA9C2BE);

  const _NextVisitCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 185,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF0E3C3A), Color(0xFF062C2B)],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.12),
            blurRadius: 26,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 16),
      child: Stack(
        children: [
          Positioned(
            right: -6,
            top: 28,
            child: Icon(
              Icons.access_time_rounded,
              size: 92,
              color: Colors.white.withOpacity(0.10),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'NEXT VISIT',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.1,
                  color: _primary.withOpacity(0.85),
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(999),
                      border: Border.all(color: Colors.white.withOpacity(0.14)),
                    ),
                    alignment: Alignment.center,
                    child: const Text(
                      'JP',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Mr. J. Perera',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Today, 2:30 PM',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: _textSoftOnDark,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: const [
                  Icon(
                    Icons.location_on_outlined,
                    size: 18,
                    color: _textSoftOnDark,
                  ),
                  SizedBox(width: 6),
                  Text(
                    'Colombo 05',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: _textSoftOnDark,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                height: 46,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _primary,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: const Text(
                    'Start visit',
                    style: TextStyle(fontWeight: FontWeight.w900, fontSize: 15),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _JobCard extends StatelessWidget {
  final String tag;
  final String price;
  final String time;

  static const _cardBorder = Color(0xFFE7EEF0);
  static const _textDark = Color(0xFF0F172A);
  static const _textSoft = Color(0xFF7A8A96);

  const _JobCard({required this.tag, required this.price, required this.time});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: _cardBorder),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 16,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFFEAF3FF),
              borderRadius: BorderRadius.circular(999),
              border: Border.all(color: const Color(0xFFD5E6FF)),
            ),
            child: Text(
              tag,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w900,
                color: Color(0xFF2A6BCB),
                letterSpacing: 0.4,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            price,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w900,
              color: _textDark,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.schedule, size: 18, color: _textSoft),
              const SizedBox(width: 6),
              Text(
                time,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: _textSoft,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            height: 42,
            child: OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                foregroundColor: _textSoft,
                side: BorderSide(color: _cardBorder.withOpacity(1)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'View details',
                style: TextStyle(fontWeight: FontWeight.w900),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
//this page should come first after logging