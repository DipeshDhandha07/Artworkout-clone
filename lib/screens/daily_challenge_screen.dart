import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../theme/app_theme.dart';
import '../models/lesson.dart';
import 'drawing_canvas_screen.dart';

import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../models/user_progress.dart';

class DailyChallengeScreen extends StatelessWidget {
  const DailyChallengeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dailyLesson = sampleLessons.first;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          _buildAppBar(),
          SliverToBoxAdapter(child: _buildWorkoutHero(context, dailyLesson)),
          SliverToBoxAdapter(child: _buildSectionHeader('Community Gallery')),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
                childAspectRatio: 1,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) => _buildGalleryItem(index),
                childCount: 12,
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 80)),
        ],
      ),
    );
  }

  SliverAppBar _buildAppBar() {
    return SliverAppBar(
      pinned: true,
      backgroundColor: AppColors.surface,
      surfaceTintColor: Colors.transparent,
      title: Text('Daily Workout', style: AppTextStyles.h1),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 16),
          child: Consumer<AuthProvider>(
            builder: (context, auth, _) {
              final stream = auth.getUserProfile();
              if (stream == null) return const SizedBox();
              
              return StreamBuilder<UserProgress>(
                stream: stream,
                builder: (context, snapshot) {
                  final streak = snapshot.data?.streakDays ?? 0;
                  return Row(
                    children: [
                      const Icon(Icons.local_fire_department_rounded, color: Colors.orange, size: 24),
                      const SizedBox(width: 4),
                      Text('$streak', style: AppTextStyles.h2.copyWith(color: Colors.orange)),
                    ],
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildWorkoutHero(BuildContext context, Lesson lesson) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 280,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(32),
              image: DecorationImage(
                image: CachedNetworkImageProvider(lesson.thumbnailUrl),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.3), BlendMode.darken),
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.2),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'CHALLENGE OF THE DAY',
                    style: AppTextStyles.labelMd.copyWith(color: Colors.white, fontSize: 10, letterSpacing: 1.2),
                  ),
                ),
                const SizedBox(height: 12),
                Text(lesson.title, style: AppTextStyles.h1.copyWith(color: Colors.white, fontSize: 32)),
                const SizedBox(height: 8),
                Text(
                  'Join 4.2k others drawing this today!',
                  style: AppTextStyles.bodyMd.copyWith(color: Colors.white.withOpacity(0.8)),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => DrawingCanvasScreen(lesson: lesson)),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: AppColors.primary,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                    child: Text('Start Workout', style: AppTextStyles.h2.copyWith(color: AppColors.primary)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: AppTextStyles.h2),
          Text('View All', style: AppTextStyles.labelMd.copyWith(color: AppColors.primary)),
        ],
      ),
    );
  }

  Widget _buildGalleryItem(int index) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(12),
        image: DecorationImage(
          image: CachedNetworkImageProvider('https://i.pravatar.cc/150?u=art$index'),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
