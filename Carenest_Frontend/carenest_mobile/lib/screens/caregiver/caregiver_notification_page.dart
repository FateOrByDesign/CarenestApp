import 'package:flutter/material.dart';

class CaregiverNotificationsPage extends StatefulWidget {
  const CaregiverNotificationsPage({super.key});

  @override
  State<CaregiverNotificationsPage> createState() =>
      _CaregiverNotificationsPageState();
}

class _CaregiverNotificationsPageState
    extends State<CaregiverNotificationsPage> {
  int _bottomIndex = 1; // Alerts selected

  final Color bgColor = const Color(0xFFF7F9FC);
  final Color cardColor = const Color(0xFFFFF5F7);
  final Color primaryBlue = const Color(0xFF6BB8F7);
  final Color inactiveColor = Colors.grey;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,

      // ================= APP BAR =================
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Notifications',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
      ),

      // ================= BODY =================
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _notificationCard(
            title: 'New Visit Request',
            description: 'Mr. J. Perera requested a visit',
            date: '05 Feb 2026',
            time: '9:00 AM - 11:00 AM',
          ),
          _notificationCard(
            title: 'Visit Updated',
            description: 'Visit time changed for Mrs. Silva',
            date: '06 Feb 2026',
            time: '2:00 PM - 4:00 PM',
          ),
          _notificationCard(
            title: 'New Care Request',
            description: 'New patient assigned: Mr. Fernando',
            date: '07 Feb 2026',
            time: '10:00 AM',
          ),
        ],
      ),

      // ================= BOTTOM NAVIGATION =================
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _bottomIndex,
        onTap: (index) {
          setState(() {
            _bottomIndex = index;
          });

          // Navigation placeholders (connect real pages later)
          if (index == 0) {
            // Navigator.pushReplacement(context,
            //   MaterialPageRoute(builder: (_) => CaregiverHomePage()));
          } else if (index == 1) {
            // Already on Notifications
          } else if (index == 2) {
            // Navigator.pushReplacement(context,
            //   MaterialPageRoute(builder: (_) => CaregiverProfilePage()));
          }
        },
        selectedItemColor: primaryBlue,
        unselectedItemColor: inactiveColor,
        showUnselectedLabels: true,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Alerts',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }

  // ================= NOTIFICATION CARD =================
  Widget _notificationCard({
    required String title,
    required String description,
    required String date,
    required String time,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 22,
            backgroundColor: primaryBlue.withOpacity(0.15),
            child: Icon(Icons.notifications, color: primaryBlue),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  description,
                  style: TextStyle(fontSize: 13, color: Colors.grey.shade700),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Icon(Icons.calendar_today, size: 16, color: primaryBlue),
                    const SizedBox(width: 6),
                    Text(
                      date,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade700,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Icon(Icons.access_time, size: 16, color: primaryBlue),
                    const SizedBox(width: 6),
                    Text(
                      time,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
