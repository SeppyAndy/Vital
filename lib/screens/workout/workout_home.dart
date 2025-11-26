import 'package:flutter/material.dart';

import '../../models/workout_program.dart';
import '../../services/local_data_service.dart';
import '../../services/user_settings_service.dart';
import '../../widgets/app_section_header.dart';

class WorkoutHome extends StatelessWidget {
  const WorkoutHome({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: Replace with API-driven workout programs.
    final programs = LocalDataService.getSampleWorkoutPrograms();
    final settings = UserSettingsService.instance.settings;
    final experience = settings.experienceLevel ?? 'Beginner';

    String experienceHint(String level) {
      switch (level) {
        case 'Intermediate':
          return 'Intermediate: Aim for 4–5 workouts per week and gradually increase volume.';
        case 'Advanced':
          return 'Advanced: Focus on progressive overload and structured deload weeks.';
        case 'Beginner':
        default:
          return 'Beginner: Start with 3 workouts per week and focus on learning proper form.';
      }
    }

    String programTagForExperience(String level) {
      switch (level) {
        case 'Intermediate':
          return 'Build strength and volume';
        case 'Advanced':
          return 'Push intensity and volume';
        case 'Beginner':
        default:
          return 'Great starting point';
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Workout'),
      ),
      body: SafeArea(
        child: programs.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.fitness_center_outlined, size: 48),
                    const SizedBox(height: 12),
                    Text(
                      'No workouts yet',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Sample programs will appear here later.',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              )
            : ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: programs.length + 2,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return const AppSectionHeader(
                      title: 'Workout programs',
                      subtitle: 'Tap a day to view the exercises and details.',
                    );
                  }
                  if (index == 1) {
                    return Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Your experience: $experience',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              experienceHint(experience),
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                  final program = programs[index - 2];
                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: BorderSide(
                          color: Theme.of(context).colorScheme.outlineVariant),
                    ),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(16),
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => WorkoutProgramDetailPage(program: program),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              program.dayName,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 8),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: program.muscleGroups
                                  .map((group) => Chip(label: Text(group)))
                                  .toList(),
                            ),
                            const SizedBox(height: 12),
                            Text('${program.exercises.length} exercises',
                                style: Theme.of(context).textTheme.bodyMedium),
                            const SizedBox(height: 4),
                            Text(
                              programTagForExperience(experience),
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}

class WorkoutProgramDetailPage extends StatelessWidget {
  const WorkoutProgramDetailPage({super.key, required this.program});

  final WorkoutProgram program;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(program.dayName),
      ),
      body: SafeArea(
        child: ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: program.exercises.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final exercise = program.exercises[index];
            return Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side:
                    BorderSide(color: Theme.of(context).colorScheme.outlineVariant),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      exercise.name,
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        Chip(label: Text(exercise.primaryMuscleGroup)),
                        Chip(label: Text(exercise.equipment)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(exercise.description,
                        style: Theme.of(context).textTheme.bodyMedium),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
