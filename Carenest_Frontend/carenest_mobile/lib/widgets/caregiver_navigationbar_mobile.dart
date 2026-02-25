import 'package:flutter/material.dart';
import '../core/app_theme.dart';

/// ---------------------------------------------------------------------------
/// CAREGIVER MOBILE NAVIGATION WRAPPER
/// ---------------------------------------------------------------------------
/// HOW TO USE:
/// Wrap any caregiver page inside this widget.
/// Example:
///
/// return CaregiverNavigationBarMobile(
///   currentIndex: CaregiverNavigationBarMobile.homeIndex,
///   child: CaregiverDashboardPage(),
/// );
///
/// This keeps navigation consistent across all caregiver screens.
/// ---------------------------------------------------------------------------
class CaregiverNavigationBarMobile extends StatelessWidget {
  final Widget child;

  /// Active tab index (0..2)
  final int currentIndex;

  /// Disable navigation if needed (optional)
  final bool enableNavigation;

  const CaregiverNavigationBarMobile({
    super.key,
    required this.child,
    required this.currentIndex,
    this.enableNavigation = true,
  });

  // ---------------------------------------------------------------------------
  // TAB INDEXES (Use these in pages)
  // ---------------------------------------------------------------------------
  static const int homeIndex = 0;
  static const int notificationsIndex = 1;
  static const int profileIndex = 2;

  // ---------------------------------------------------------------------------
  // ROUTE NAMES (Make sure these exist in main.dart)
  // ---------------------------------------------------------------------------
  static const String homeRoute = '/caregiver-dashboard';
  static const String notificationsRoute = '/caregiver-notifications';
  static const String profileRoute = '/caregiver-profile';

  // ---------------------------------------------------------------------------
  // NAVIGATION HANDLER
  // ---------------------------------------------------------------------------
  void _go(BuildContext context, int index) {
    if (index == currentIndex) return;
    if (!enableNavigation) return;

    final route = switch (index) {
      homeIndex => homeRoute,
      notificationsIndex => notificationsRoute,
      profileIndex => profileRoute,
      _ => homeRoute,
    };

    // Replace current page instead of stacking pages
    Navigator.pushReplacementNamed(context, route);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,

      /// This is where your actual page appears
      body: child,

      /// Bottom Navigation Bar
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppTheme.surface,
          border: Border(top: BorderSide(color: Colors.grey.withOpacity(0.12))),
        ),
        child: NavigationBar(
          backgroundColor: AppTheme.surface,
          elevation: 0,
          height: 70,
          selectedIndex: currentIndex,
          onDestinationSelected: (i) => _go(context, i),
          indicatorColor: AppTheme.primary.withOpacity(0.12),

          /// 3 Equal Items (Auto spread by Flutter)
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home, color: AppTheme.primary),
              label: 'Home',
            ),
            NavigationDestination(
              icon: Icon(Icons.notifications_outlined),
              selectedIcon: Icon(Icons.notifications, color: AppTheme.primary),
              label: 'Notifications',
            ),
            NavigationDestination(
              icon: Icon(Icons.person_outline),
              selectedIcon: Icon(Icons.person, color: AppTheme.primary),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}
