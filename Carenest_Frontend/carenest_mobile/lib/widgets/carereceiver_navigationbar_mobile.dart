import 'package:flutter/material.dart';

class CareReceiverBottomNav extends StatelessWidget {
  final int currentIndex;

  static const int homeIndex = 0;
  static const int findCareIndex = 1;
  static const int notificationsIndex = 2;
  static const int profileIndex = 3;

  // ✅ Single source of truth for routes
  static const String routeHome = '/carereceiver-dashboard';
  static const String routeFindCare = '/carereceiver-find-care';
  static const String routeNotifications = '/carereceiver-notifications';
  static const String routeProfile = '/carereceiver-profile';

  const CareReceiverBottomNav({super.key, required this.currentIndex});

  void _go(BuildContext context, int index) {
    final routes = <String>[
      routeHome,
      routeFindCare,
      routeNotifications,
      routeProfile,
    ];

    final target = routes[index];
    final current = ModalRoute.of(context)?.settings.name;

    if (current == target) return;
    Navigator.pushReplacementNamed(context, target);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border(
          top: BorderSide(
            color: Theme.of(context).dividerColor.withOpacity(0.35),
            width: 1,
          ),
        ),
      ),
      child: NavigationBar(
        height: 70,
        selectedIndex: currentIndex,
        onDestinationSelected: (i) => _go(context, i),
        indicatorColor: Theme.of(context).colorScheme.primary.withOpacity(0.14),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home_rounded),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.search_rounded),
            selectedIcon: Icon(Icons.search_rounded),
            label: 'Find care',
          ),
          NavigationDestination(
            icon: Icon(Icons.notifications_none_rounded),
            selectedIcon: Icon(Icons.notifications_rounded),
            label: 'Notifications',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline_rounded),
            selectedIcon: Icon(Icons.person_rounded),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
