import 'package:flutter/material.dart';
import 'screens/calendar/calendar_home.dart';
import 'screens/info_center/info_center_home.dart';
import 'screens/nutrition/nutrition_home.dart';
import 'screens/onboarding/onboarding_flow.dart';
import 'screens/tracking_progress/tracking_progress_home.dart';
import 'screens/workout/workout_home.dart';
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

class RootFlow extends StatefulWidget {
  const RootFlow({super.key});

  @override
  State<RootFlow> createState() => _RootFlowState();
}

class _RootFlowState extends State<RootFlow> {
  bool _isReady = false;
  bool _shouldSkipOnboarding = false;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    final svc = UserSettingsService.instance;
    await svc.load();

    setState(() {
      _isReady = true;
      _shouldSkipOnboarding = svc.hasCompletedOnboarding;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_isReady) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_shouldSkipOnboarding) {
      return const MainShell();
    }

    return OnboardingFlow(
      onFinished: () {
        setState(() {
          _shouldSkipOnboarding = true;
        });
      },
    );
  }
}

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _selectedIndex = 2;

  final List<Widget> _pages = const [
    WorkoutHome(),
    NutritionHome(),
    TrackingProgressHome(),
    CalendarHome(),
    InfoCenterHome(),
  ];

  void _onDestinationSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: IndexedStack(
          index: _selectedIndex,
          children: _pages,
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: _onDestinationSelected,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.fitness_center_outlined),
            selectedIcon: Icon(Icons.fitness_center),
            label: 'Workout',
          ),
          NavigationDestination(
            icon: Icon(Icons.restaurant_outlined),
            selectedIcon: Icon(Icons.restaurant),
            label: 'Nutrition',
          ),
          NavigationDestination(
            icon: Icon(Icons.show_chart_outlined),
            selectedIcon: Icon(Icons.show_chart),
            label: 'Progress',
          ),
          NavigationDestination(
            icon: Icon(Icons.calendar_today_outlined),
            selectedIcon: Icon(Icons.calendar_month),
            label: 'Calendar',
          ),
          NavigationDestination(
            icon: Icon(Icons.info_outline),
            selectedIcon: Icon(Icons.info),
            label: 'Info',
          ),
        ],
      ),
    );
  }
}
