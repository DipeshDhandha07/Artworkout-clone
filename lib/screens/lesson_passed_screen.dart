import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/app_theme.dart';
import '../models/lesson.dart';
import '../services/firestore_service.dart';

class LessonPassedScreen extends StatelessWidget {
  final Lesson lesson;
  final int matchPercentage;
  final int smoothnessPercentage;
  
  const LessonPassedScreen({
    super.key, 
    required this.lesson,
    this.matchPercentage = 95,
    this.smoothnessPercentage = 92,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              const Icon(Icons.stars_rounded, color: Colors.amber, size: 100)
                  .animate()
                  .scale(delay: 200.ms, duration: 500.ms, curve: Curves.easeOutBack),
              const SizedBox(height: 24),
              Text('Lesson Passed!', style: AppTextStyles.h1)
                  .animate()
                  .fadeIn(delay: 400.ms),
              const SizedBox(height: 8),
              Text(lesson.title, style: AppTextStyles.h2.copyWith(color: AppColors.onSurfaceVariant))
                  .animate()
                  .fadeIn(delay: 500.ms),
              const SizedBox(height: 48),
              
              // Stats
              _buildStatRow('Match', '$matchPercentage%').animate().fadeIn(delay: 700.ms).slideX(),
              const SizedBox(height: 16),
              _buildStatRow('Smoothness', '$smoothnessPercentage%').animate().fadeIn(delay: 800.ms).slideX(),
              const SizedBox(height: 16),
              _buildStatRow('First Try', 'Yes').animate().fadeIn(delay: 900.ms).slideX(),
              
              const SizedBox(height: 40),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                decoration: BoxDecoration(
                  color: AppColors.primaryContainer,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('+${lesson.xpReward} XP', style: AppTextStyles.h2.copyWith(color: AppColors.primary)),
                  ],
                ),
              ).animate().fadeIn(delay: 1100.ms).scale(),
              
              const Spacer(),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () async {
                    // Save progress and pop back to library
                    await FirestoreService().completeLesson(lesson);
                    if (!context.mounted) return;
                    Navigator.pop(context); // Pop passed screen
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
                  ),
                  child: Text('Continue', style: AppTextStyles.h3.copyWith(color: Colors.white)),
                ),
              ).animate().fadeIn(delay: 1300.ms),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: AppTextStyles.bodyLg.copyWith(fontWeight: FontWeight.w500)),
        Text(value, style: AppTextStyles.h3),
      ],
    );
  }
}
