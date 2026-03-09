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

            // Caregiver 1
            _CurrentCaregiverCard(
              caregiverName: 'Kumari Perera',
              specialty: 'Elder Care Specialist',
            ),

            SizedBox(height: 14),

            _SessionStatusTile(
              timeText: '9:00 AM',
              title: 'Morning Medication',
              status: _ItemStatus.completed,
            ),

            SizedBox(height: 20),

            // Caregiver 2
            _CurrentCaregiverCard(
              caregiverName: 'Shalini Fernando',
              specialty: 'Physiotherapy Assistant',
            ),

            SizedBox(height: 14),

            _SessionStatusTile(
              timeText: '2:00 PM',
              title: 'Physiotherapy Session',
              status: _ItemStatus.upcoming,
            ),

            SizedBox(height: 10),
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

/* -------------------------------------------------------------------------- */
/*                           CAREGIVER CARD                                   */
/* -------------------------------------------------------------------------- */

class _CurrentCaregiverCard extends StatelessWidget {
  final String caregiverName;
  final String specialty;

  const _CurrentCaregiverCard({
    required this.caregiverName,
    required this.specialty,
  });

  static const _radius = 18.0;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(_radius),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF0B3B3A), Color(0xFF062F2E)],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(_radius),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Current Caregiver',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.white70,
                ),
              ),
              const SizedBox(height: 12),

              Row(
                children: [
                  Container(
                    width: 54,
                    height: 54,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.92),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.medical_services_outlined,
                      color: Color(0xFF6B7280),
                      size: 26,
                    ),
                  ),
                  const SizedBox(width: 14),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          caregiverName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          specialty,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 14),

              SizedBox(
                width: double.infinity,
                height: 46,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0EA5A0),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Contact now',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/* -------------------------------------------------------------------------- */
/*                              SESSION TILE                                  */
/* -------------------------------------------------------------------------- */

class _SessionStatusTile extends StatelessWidget {
  final String timeText;
  final String title;
  final _ItemStatus status;

  const _SessionStatusTile({
    required this.timeText,
    required this.title,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    final isCompleted = status == _ItemStatus.completed;

    return Row(
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: isCompleted
                ? const Color(0xFF0EA5A0).withOpacity(0.12)
                : const Color(0xFFCBD5E1).withOpacity(0.20),
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: Icon(
            isCompleted ? Icons.check : Icons.access_time,
            size: 20,
            color: isCompleted
                ? const Color(0xFF0EA5A0)
                : const Color(0xFF64748B),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFFE7EEF0)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 14,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Text(
              '$timeText: $title – ${isCompleted ? "Completed" : "Upcoming"}',
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: Color(0xFF334155),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

enum _ItemStatus { completed, upcoming }
