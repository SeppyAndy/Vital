import 'package:flutter/material.dart';

import '../../models/workout_program.dart';
import '../../services/local_data_service.dart';
import '../../widgets/app_section_header.dart';

class WorkoutHome extends StatelessWidget {
  const WorkoutHome({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: Replace with API-driven workout programs.
    final programs = LocalDataService.getSampleWorkoutPrograms();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Workout'),
      ),
      body: SafeArea(
        child: ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: programs.length + 1,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            if (index == 0) {
              return const AppSectionHeader(
                title: 'Workout programs',
                subtitle: 'Tap a day to view the exercises and details.',
              );
            }
            final program = programs[index - 1];
            return Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side:
                    BorderSide(color: Theme.of(context).colorScheme.outlineVariant),
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
