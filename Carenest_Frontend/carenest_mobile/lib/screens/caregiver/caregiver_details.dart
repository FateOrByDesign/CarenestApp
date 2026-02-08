import 'package:flutter/material.dart';

class CaregiverDetailsPage extends StatefulWidget {
  const CaregiverDetailsPage({super.key});

  @override
  State<CaregiverDetailsPage> createState() => _CaregiverDetailsPageState();
}

class _CaregiverDetailsPageState extends State<CaregiverDetailsPage> {
  int selectedTab = 0;
  int bottomIndex = 0;

  final Color primaryBlue = const Color(0xFF6BB8F7);
  final Color bgColor = const Color(0xFFF7F9FC);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,

      body: Column(
        children: [
          // ================= HEADER IMAGE =================
          Stack(
            children: [
              Image.asset(
                'assets/images/caregiver_header.jpg',
                height: 260,
                width: double.infinity,
                fit: BoxFit.cover,
              ),

              // Back button
              Positioned(
                top: 40,
                left: 16,
                child: _circleIcon(Icons.arrow_back, () {
                  Navigator.pop(context);
                }),
              ),

              // Favorite button
              Positioned(
                top: 40,
                right: 16,
                child: _circleIcon(Icons.favorite_border, () {}),
              ),
            ],
          ),

          // ================= FIXED INFO CARD =================
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: _infoCard(),
          ),

          // ================= TABS (FIXED) =================
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: _tabs(),
          ),

          const SizedBox(height: 12),

          // ================= SCROLLABLE CONTENT =================
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Column(
                children: [
                  if (selectedTab == 0) ...[
                    _servicesCard(),
                    const SizedBox(height: 16),
                    _languagesCard(),
                    const SizedBox(height: 16),
                    _verificationCard(),
                  ],

                  if (selectedTab == 1)
                    _sectionCard('Experience', const [
                      '5+ years caregiving experience',
                      'Worked in hospital & home care',
                    ]),

                  if (selectedTab == 2)
                    _sectionCard('Reviews', const [
                      'Very kind and professional',
                      'Highly recommended caregiver',
                    ]),
                ],
              ),
            ),
          ),
        ],
      ),

      // ================= BOTTOM =================
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryBlue,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: const Text(
                  'Book this caregiver',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),

          BottomNavigationBar(
            currentIndex: bottomIndex,
            onTap: (i) => setState(() => bottomIndex = i),
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

  // ================= UI PARTS =================

  Widget _infoCard() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Kumari Perera',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 6),
                Row(
                  children: [
                    Icon(Icons.verified, color: Colors.blue, size: 16),
                    SizedBox(width: 4),
                    Text('Verified caregiver'),
                  ],
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const Text(
                  'LKR 800 / hour',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 6),
                OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.chat_bubble_outline, size: 16),
                  label: const Text('Chat'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.blue,
                    side: const BorderSide(color: Colors.blue),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _tabs() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _tabItem('Overview', 0),
        _tabItem('Experience', 1),
        _tabItem('Reviews', 2),
      ],
    );
  }

  Widget _tabItem(String title, int index) {
    final bool active = selectedTab == index;
    return GestureDetector(
      onTap: () => setState(() => selectedTab = index),
      child: Column(
        children: [
          Text(
            title,
            style: TextStyle(
              color: active ? primaryBlue : Colors.grey,
              fontWeight: active ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          const SizedBox(height: 4),
          if (active) Container(height: 3, width: 40, color: primaryBlue),
        ],
      ),
    );
  }

  Widget _servicesCard() {
    return _sectionCard('Services', const [
      'Elderly care',
      'Post-operative support',
      'Medication management',
    ]);
  }

  Widget _languagesCard() {
    return _sectionCard('Languages', const ['Sinhala', 'English', 'Tamil']);
  }

  Widget _verificationCard() {
    return _sectionCard('Verification', const [
      'Identity verified',
      'Police clearance report',
      'Medical documents',
    ]);
  }

  Widget _sectionCard(String title, List<String> items) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 2,
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
            for (final item in items)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Row(
                  children: [
                    const Icon(
                      Icons.check_circle,
                      color: Colors.green,
                      size: 20,
                    ),
                    const SizedBox(width: 10),
                    Expanded(child: Text(item)),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _circleIcon(IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: CircleAvatar(
        backgroundColor: Colors.white,
        child: Icon(icon, color: Colors.black),
      ),
    );
  }
}
