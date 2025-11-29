import 'package:flutter/material.dart';

import 'screens/tracking_progress/tracking_progress_home.dart';
import 'screens/workout/workout_home.dart';
import 'screens/nutrition/nutrition_home.dart';
import 'screens/calendar/calendar_home.dart';
import 'screens/info_center/info_center_home.dart';
import 'screens/onboarding/onboarding_flow.dart';
import 'services/user_settings_service.dart';

void main() {
  runApp(const VitalApp());
}

class VitalApp extends StatelessWidget {
  const VitalApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Vital',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      ),
      home: const RootFlow(),
    );
  }
}

/// Decides whether to show onboarding or the main shell
class RootFlow extends StatefulWidget {
  const RootFlow({super.key});

  @override
  State<RootFlow> createState() => _RootFlowState();
}

class _RootFlowState extends State<RootFlow> {
  bool _isReady = false;
  bool _skipOnboarding = false;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    final svc = UserSettingsService.instance;
    await svc.load();

    // Debug log so we can see the state in the console.
    // Ignore if not needed later.
    // e.g. "DEBUG: onboardingComplete = true/false"
    // This helps us verify persistence is working.
    // You can remove later if you want.
    // (kept simple on purpose)
    // ignore: avoid_print
    print('DEBUG: onboardingComplete = ${svc.onboardingComplete}');

    setState(() {
      _isReady = true;
      _skipOnboarding = svc.onboardingComplete;
    });
  }

  Future<void> _handleOnboardingFinished() async {
    final svc = UserSettingsService.instance;
    await svc.markOnboardingComplete();
    setState(() {
      _skipOnboarding = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_isReady) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_skipOnboarding) {
      return const MainShell();
    }

    return OnboardingFlow(
      onFinished: _handleOnboardingFinished,
    );
  }
}

/// Main bottom-nav shell for Workout/Nutrition/Progress/Calendar/Info
class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _selectedIndex = 2; // Progress tab by default

  final List<Widget> _pages = const [
    WorkoutHome(),
    NutritionHome(),
    TrackingProgressHome(),
    CalendarHome(),
    InfoCenterHome(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.fitness_center_outlined),
            label: 'Workout',
          ),
          NavigationDestination(
            icon: Icon(Icons.restaurant_outlined),
            label: 'Nutrition',
          ),
          NavigationDestination(
            icon: Icon(Icons.show_chart_outlined),
            label: 'Progress',
          ),
          NavigationDestination(
            icon: Icon(Icons.calendar_today_outlined),
            label: 'Calendar',
          ),
          NavigationDestination(
            icon: Icon(Icons.menu_book_outlined),
            label: 'Info',
          ),
        ],
      ),
    );
  }
}
