import 'package:flutter/material.dart';

class CareReceiverNavigationBarMobile extends StatelessWidget {
  final int currentIndex;

  const CareReceiverNavigationBarMobile({
    super.key,
    required this.currentIndex,
  });

  void _go(BuildContext context, int index) {
    const routes = [
      '/patient/dashboard', // Home
      '/patient/request-caregiver', // Find care
      '/patient/notifications', // Notifications
      '/patient/profile', // Profile
    ];

    final target = routes[index];
    final current = ModalRoute.of(context)?.settings.name;

    if (current == target) return;
    Navigator.pushReplacementNamed(context, target);
  }

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      height: 70,
      selectedIndex: currentIndex,
      onDestinationSelected: (i) => _go(context, i),
      destinations: const [
        NavigationDestination(
          icon: Icon(Icons.home_outlined),
          selectedIcon: Icon(Icons.home),
          label: 'Home',
        ),
        NavigationDestination(
          icon: Icon(Icons.search_rounded),
          selectedIcon: Icon(Icons.search),
          label: 'Find care',
        ),
        NavigationDestination(
          icon: Icon(Icons.notifications_none_rounded),
          selectedIcon: Icon(Icons.notifications),
          label: 'Notifications',
        ),
        NavigationDestination(
          icon: Icon(Icons.person_outline),
          selectedIcon: Icon(Icons.person),
          label: 'Profile',
        ),
      ],
    );
  }
}
