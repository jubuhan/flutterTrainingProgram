// views/main_wrapper.dart
import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'reports_screen.dart';
import 'add_transaction_screen.dart';
// import 'profile_screen.dart';
// import 'analytics_screen.dart';
import 'widgets/bottom_bar.dart';

class MainWrapper extends StatefulWidget {
  const MainWrapper({super.key});

  @override
  State<MainWrapper> createState() => _MainWrapperState();
}

class _MainWrapperState extends State<MainWrapper> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const ReportsScreen(),
    const AddTransactionScreen(), // Center FAB screen
    // const AnalyticsScreen(),      // Create this screen if needed
    // const ProfileScreen(),        // Create this screen if needed
  ];

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
      ),
    );
  }
}
