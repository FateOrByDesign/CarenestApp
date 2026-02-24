import 'package:flutter/material.dart';
import '../../widgets/carereceiver_navigationbar_mobile.dart';

class CareReceiverDashboardPage extends StatelessWidget {
  const CareReceiverDashboardPage({super.key});

  // ✅ Must match main.dart route: '/patient/dashboard'
  static const routeName = '/patient/dashboard';

  // Colors tuned to your UI
  static const _bg = Color(0xFFF7FAFA);
  static const _cardBorder = Color(0xFFE7EEF0);
  static const _textDark = Color(0xFF0F172A);
  static const _textSoft = Color(0xFF7A8A96);
  static const _primary = Color(0xFF16A394);

  @override
  Widget build(BuildContext context) {
    // ✅ Example data (2 sessions)
    // Sort by time so the nearest session appears first
    final sessions = <_CareSession>[
      _CareSession(
        title: 'Physiotherapy Session',
        caregiverName: 'Sahan Fernando',
        location: 'Negombo',
        start: DateTime(2026, 2, 24, 18, 30), // 6:30 PM
        tasks: const [
          _CareTask(title: 'Warm-up stretches', minutesOffset: 0),
          _CareTask(title: 'Knee mobility exercises', minutesOffset: 10),
          _CareTask(title: 'Cool-down + breathing', minutesOffset: 35),
        ],
      ),
      _CareSession(
        title: 'Hospital Care Visit',
        caregiverName: 'Sathika Perera',
        location: 'Colombo 05',
        start: DateTime(2026, 2, 24, 20, 00), // 8:00 PM
        tasks: const [
          _CareTask(title: 'Vitals check (BP, pulse)', minutesOffset: 0),
          _CareTask(title: 'Medication & notes update', minutesOffset: 15),
          _CareTask(title: 'Elder care assistance', minutesOffset: 35),
        ],
      ),
    ]..sort((a, b) => a.start.compareTo(b.start));

    // Flatten tasks and sort them by actual time (chronological order)
    final taskTimeline = <_TimelineTask>[];
    for (final s in sessions) {
      for (final t in s.tasks) {
        taskTimeline.add(
          _TimelineTask(
            time: s.start.add(Duration(minutes: t.minutesOffset)),
            sessionTitle: s.title,
            taskTitle: t.title,
          ),
        );
      }
    }
    taskTimeline.sort((a, b) => a.time.compareTo(b.time));

    return Scaffold(
      backgroundColor: _bg,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
          children: [
            // Header
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Expanded(
                  child: Text(
                    'Hi, Care receiver',
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

            const Text(
              'Upcoming sessions',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w900,
                color: _textDark,
              ),
            ),
            const SizedBox(height: 12),

            // ✅ Two session cards (already sorted by time)
            for (final s in sessions) ...[
              _SessionCard(session: s),
              const SizedBox(height: 12),
            ],

            const SizedBox(height: 6),

            const Text(
              'Tasks (chronological)',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w900,
                color: _textDark,
              ),
            ),
            const SizedBox(height: 12),

            // ✅ Tasks list sorted by time (nearest first)
            _TasksCard(items: taskTimeline),
          ],
        ),
      ),

      // ✅ Apply the new CareReceiver navbar
      // Indices: 0 Home, 1 Find care, 2 Notifications, 3 Profile
      bottomNavigationBar: const CareReceiverNavigationBarMobile(
        currentIndex: 0,
      ),
    );
  }
}

/* ----------------------------- UI Widgets ----------------------------- */

class _SessionCard extends StatelessWidget {
  final _CareSession session;

  static const _cardBorder = Color(0xFFE7EEF0);
  static const _textDark = Color(0xFF0F172A);
  static const _textSoft = Color(0xFF7A8A96);
  static const _primary = Color(0xFF16A394);

  const _SessionCard({required this.session});

  @override
  Widget build(BuildContext context) {
    final timeLabel = _fmtDateTime(session.start);

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
          // Title + time pill
          Row(
            children: [
              Expanded(
                child: Text(
                  session.title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    color: _textDark,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: _primary.withOpacity(0.10),
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(color: _primary.withOpacity(0.20)),
                ),
                child: Text(
                  timeLabel,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w900,
                    color: _primary,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          // Caregiver + location
          Row(
            children: [
              const Icon(Icons.badge_outlined, size: 18, color: _textSoft),
              const SizedBox(width: 6),
              Text(
                session.caregiverName,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                  color: _textSoft,
                ),
              ),
              const SizedBox(width: 14),
              const Icon(
                Icons.location_on_outlined,
                size: 18,
                color: _textSoft,
              ),
              const SizedBox(width: 6),
              Text(
                session.location,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                  color: _textSoft,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Tasks inside session card (in order)
          const Text(
            'Session tasks',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w900,
              color: _textDark,
            ),
          ),
          const SizedBox(height: 8),

          Column(
            children: session.tasks.map((t) {
              final tTime = session.start.add(
                Duration(minutes: t.minutesOffset),
              );
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: _primary.withOpacity(0.9),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      _fmtTimeOnly(tTime),
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w900,
                        color: _textSoft,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        t.title,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          color: _textDark,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

class _TasksCard extends StatelessWidget {
  final List<_TimelineTask> items;

  static const _cardBorder = Color(0xFFE7EEF0);
  static const _textDark = Color(0xFF0F172A);
  static const _textSoft = Color(0xFF7A8A96);

  const _TasksCard({required this.items});

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
        children: [
          for (int i = 0; i < items.length; i++) ...[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _fmtTimeOnly(items[i].time),
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w900,
                    color: _textSoft,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        items[i].taskTitle,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w900,
                          color: _textDark,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        items[i].sessionTitle,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                          color: _textSoft,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (i != items.length - 1) ...[
              const SizedBox(height: 12),
              Divider(height: 1, color: _cardBorder),
              const SizedBox(height: 12),
            ],
          ],
        ],
      ),
    );
  }
}

/* ----------------------------- Data Models ----------------------------- */

class _CareSession {
  final String title;
  final String caregiverName;
  final String location;
  final DateTime start;
  final List<_CareTask> tasks;

  const _CareSession({
    required this.title,
    required this.caregiverName,
    required this.location,
    required this.start,
    required this.tasks,
  });
}

class _CareTask {
  final String title;

  /// minutes from session start (0 = same time)
  final int minutesOffset;

  const _CareTask({required this.title, required this.minutesOffset});
}

class _TimelineTask {
  final DateTime time;
  final String sessionTitle;
  final String taskTitle;

  const _TimelineTask({
    required this.time,
    required this.sessionTitle,
    required this.taskTitle,
  });
}

/* ----------------------------- Format Helpers ----------------------------- */

String _fmtTimeOnly(DateTime dt) {
  String two(int n) => n.toString().padLeft(2, '0');
  final hour = dt.hour;
  final minute = dt.minute;
  final isPm = hour >= 12;
  final h12 = (hour % 12 == 0) ? 12 : (hour % 12);
  return '${h12}:${two(minute)} ${isPm ? 'PM' : 'AM'}';
}

String _fmtDateTime(DateTime dt) {
  // Example: "24 Feb • 6:30 PM"
  const months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];
  return '${dt.day} ${months[dt.month - 1]} • ${_fmtTimeOnly(dt)}';
}
