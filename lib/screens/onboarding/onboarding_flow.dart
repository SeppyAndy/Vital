import 'package:flutter/material.dart';

import '../../services/user_settings_service.dart';

class OnboardingFlow extends StatefulWidget {
  final VoidCallback onFinished;

  const OnboardingFlow({
    required this.onFinished,
    super.key,
  });

  @override
  State<OnboardingFlow> createState() => _OnboardingFlowState();
}

class _OnboardingFlowState extends State<OnboardingFlow> {
  int _currentStep = 0;
  int? _age;
  double? _height;
  double? _weight;
  String? _goal;
  String? _experience;
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();

  @override
  void dispose() {
    _ageController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pages = <Widget>[
      _buildWelcomeStep(context),
      _buildBasicInfoStep(context),
      _buildGoalStep(context),
      _buildExperienceStep(context),
      _buildSummaryStep(context),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Setup your profile'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Expanded(
                child: IndexedStack(
                  index: _currentStep,
                  children: pages,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (_currentStep > 0)
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _currentStep -= 1;
                        });
                      },
                      child: const Text('Back'),
                    )
                  else
                    const SizedBox(width: 72),
                  ElevatedButton(
                    onPressed: () {
                      if (_currentStep < pages.length - 1) {
                        setState(() {
                          _currentStep += 1;
                        });
                      } else {
                        final svc = UserSettingsService.instance;
                        if (_age != null) svc.setAge(_age!);
                        if (_height != null) svc.setHeight(_height!);
                        if (_weight != null) svc.setWeight(_weight!);
                        if (_goal != null) svc.setGoal(_goal!);
                        if (_experience != null) {
                          svc.setExperienceLevel(_experience!);
                        }
                        widget.onFinished();
                      }
                    },
                    child:
                        Text(_currentStep < pages.length - 1 ? 'Next' : 'Finish'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWelcomeStep(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Welcome to Vital',
          style: textTheme.headlineSmall?.copyWith(color: colorScheme.primary),
        ),
        const SizedBox(height: 12),
        Text(
          'We will ask a few quick questions to personalize your training and nutrition experience.',
          style: textTheme.bodyLarge,
        ),
        const SizedBox(height: 24),
        const Icon(Icons.favorite, size: 72),
        const SizedBox(height: 12),
        Text(
          'Let’s get started!',
          style: textTheme.titleMedium,
        ),
      ],
    );
  }

  Widget _buildBasicInfoStep(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Basic info',
            style: textTheme.titleLarge,
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _ageController,
            keyboardType: TextInputType.number,
            onChanged: (value) {
              setState(() {
                _age = int.tryParse(value);
              });
            },
            decoration: const InputDecoration(
              labelText: 'Age',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _heightController,
            keyboardType: TextInputType.number,
            onChanged: (value) {
              setState(() {
                _height = double.tryParse(value);
              });
            },
            decoration: const InputDecoration(
              labelText: 'Height (cm)',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _weightController,
            keyboardType: TextInputType.number,
            onChanged: (value) {
              setState(() {
                _weight = double.tryParse(value);
              });
            },
            decoration: const InputDecoration(
              labelText: 'Weight (kg)',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'This information will help tailor your plan later.',
            style: textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }

  Widget _buildGoalStep(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final goals = ['Lose fat', 'Build muscle', 'Improve health'];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Your primary goal', style: textTheme.titleLarge),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: goals
              .map(
                (goal) => ChoiceChip(
                  label: Text(goal),
                  selected: _goal == goal,
                  onSelected: (_) {
                    setState(() {
                      _goal = goal;
                    });
                  },
                ),
              )
              .toList(),
        ),
        const SizedBox(height: 16),
        Text(
          'Choosing a goal helps personalize your recommendations.',
          style: textTheme.bodyMedium,
        ),
      ],
    );
  }

  Widget _buildExperienceStep(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final experiences = ['Beginner', 'Intermediate', 'Advanced'];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Your experience level', style: textTheme.titleLarge),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: experiences
              .map(
                (level) => ChoiceChip(
                  label: Text(level),
                  selected: _experience == level,
                  onSelected: (_) {
                    setState(() {
                      _experience = level;
                    });
                  },
                ),
              )
              .toList(),
        ),
        const SizedBox(height: 16),
        Text(
          'We will use this to set appropriate intensity and volume later.',
          style: textTheme.bodyMedium,
        ),
      ],
    );
  }

  Widget _buildSummaryStep(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final goalText = _goal ?? 'a balanced plan';
    final experienceText = _experience ?? 'an intermediate level';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('You\'re all set', style: textTheme.titleLarge),
        const SizedBox(height: 12),
        Text(
          'We will tailor your experience towards $goalText with $experienceText focus.',
          style: textTheme.bodyMedium,
        ),
        const SizedBox(height: 16),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Summary', style: textTheme.titleMedium),
                const SizedBox(height: 8),
                Text('Goal: ${_goal ?? 'Not selected'}'),
                Text('Experience: ${_experience ?? 'Not selected'}'),
                Text('Age: ${_age?.toString() ?? (_ageController.text.isEmpty ? 'Not provided' : _ageController.text)}'),
                Text('Height: ${_height?.toString() ?? (_heightController.text.isEmpty ? 'Not provided' : '${_heightController.text} cm')}'),
                Text('Weight: ${_weight?.toString() ?? (_weightController.text.isEmpty ? 'Not provided' : '${_weightController.text} kg')}'),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'You can update these details later in the app. Tap Finish to continue to your dashboard.',
          style: textTheme.bodyMedium,
        ),
      ],
    );
  }
}
