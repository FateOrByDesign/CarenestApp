import 'package:flutter/material.dart';

class PatientDetailsPage extends StatefulWidget {
  const PatientDetailsPage({super.key});

  @override
  State<PatientDetailsPage> createState() => _PatientDetailsPageState();
}

class _PatientDetailsPageState extends State<PatientDetailsPage> {
  int _currentIndex = 0;

  final Color primaryBlue = const Color(0xFF6BB8F7);
  final Color bgColor = const Color(0xFFF7F9FC);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,

      body: Column(
        children: [
          /// ================= HEADER IMAGE =================
          Stack(
            children: [
              SizedBox(
                height: 260,
                width: double.infinity,
                child: Image.asset(
                  'assets/images/patientimg.jpg',
                  fit: BoxFit.cover,
                ),
              ),

              /// BACK BUTTON
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: InkWell(
                    onTap: () => Navigator.pop(context),
                    child: const CircleAvatar(
                      backgroundColor: Colors.white,
                      child: Icon(Icons.arrow_back, color: Colors.black),
                    ),
                  ),
                ),
              ),
            ],
          ),

          /// ================= FIXED HEADER CARD =================
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: _patientHeaderCard(),
          ),

          /// ================= SCROLLABLE CONTENT =================
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 120),
              child: Column(
                children: [
                  _medicalInfoCard(),
                  const SizedBox(height: 16),
                  _careInstructionsCard(),
                  const SizedBox(height: 16),
                  _emergencyContactCard(),
                ],
              ),
            ),
          ),
        ],
      ),

      /// ================= ACTION + NAV =================
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          /// ACCEPT / DECLINE
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 10),
            child: Row(
              children: [
                Expanded(
                  child: _softButton(
                    label: 'Accept Visit',
                    icon: Icons.check,
                    bg: const Color(0xFFDFF4E7),
                    fg: const Color(0xFF2E7D32),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _softButton(
                    label: 'Decline Visit',
                    icon: Icons.close,
                    bg: const Color(0xFFFBE4E4),
                    fg: const Color(0xFFC62828),
                  ),
                ),
              ],
            ),
          ),

          /// BOTTOM NAV
          BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: (index) {
              setState(() => _currentIndex = index);
            },
            selectedItemColor: primaryBlue,
            unselectedItemColor: Colors.grey,
            type: BottomNavigationBarType.fixed,
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
              BottomNavigationBarItem(
                icon: Icon(Icons.notifications),
                label: 'Alerts',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'Profile',
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// ================= HEADER CARD =================
  Widget _patientHeaderCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// NAME + CHAT (NO OVERFLOW)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Mr. J. Perera',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text('Age: 72', style: TextStyle(color: Colors.grey)),
                    ],
                  ),
                ),
                OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.chat_bubble_outline, size: 16),
                  label: const Text('Chat'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: primaryBlue,
                    side: BorderSide(color: primaryBlue),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),
            const Divider(),

            /// DATE + TIME
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Row(
                  children: [
                    Icon(Icons.calendar_today, size: 18, color: Colors.blue),
                    SizedBox(width: 6),
                    Text('05 Feb 2026'),
                  ],
                ),
                Row(
                  children: [
                    Icon(Icons.access_time, size: 18, color: Colors.blue),
                    SizedBox(width: 6),
                    Text('9:00 AM - 11:00 AM'),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// ================= INFO CARDS =================
  Widget _medicalInfoCard() => _infoCard(
    title: 'Medical Information',
    items: const [
      _InfoItem(Icons.local_hospital, 'Condition', 'Post-surgery'),
      _InfoItem(Icons.directions_walk, 'Mobility', 'Low'),
      _InfoItem(Icons.monitor_heart, 'Monitoring', 'Blood pressure & vitals'),
    ],
  );

  Widget _careInstructionsCard() => _infoCard(
    title: 'Care Instructions',
    items: const [
      _InfoItem(
        Icons.check_circle,
        '',
        'Needs assistance while walking',
        isCheck: true,
      ),
      _InfoItem(
        Icons.check_circle,
        '',
        'Medication twice a day',
        isCheck: true,
      ),
      _InfoItem(
        Icons.check_circle,
        '',
        'Physiotherapy required',
        isCheck: true,
      ),
    ],
  );

  Widget _emergencyContactCard() => _infoCard(
    title: 'Emergency Contact',
    items: const [
      _InfoItem(Icons.person, 'Name', 'S. Perera (Son)'),
      _InfoItem(Icons.phone, 'Phone', '077 555 8899'),
    ],
  );

  /// ================= REUSABLE =================
  Widget _softButton({
    required String label,
    required IconData icon,
    required Color bg,
    required Color fg,
  }) {
    return ElevatedButton.icon(
      onPressed: () {},
      icon: Icon(icon, size: 18),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: bg,
        foregroundColor: fg,
        elevation: 0,
        padding: const EdgeInsets.symmetric(vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
    );
  }
}

/// ================= MODELS =================
class _InfoItem {
  final IconData icon;
  final String label;
  final String value;
  final bool isCheck;

  const _InfoItem(this.icon, this.label, this.value, {this.isCheck = false});
}

Widget _infoCard({required String title, required List<_InfoItem> items}) {
  return Card(
    elevation: 3,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          ...items.map(
            (item) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Row(
                children: [
                  Icon(
                    item.icon,
                    color: item.isCheck ? Colors.green : Colors.blue,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      item.label.isEmpty
                          ? item.value
                          : '${item.label}: ${item.value}',
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
