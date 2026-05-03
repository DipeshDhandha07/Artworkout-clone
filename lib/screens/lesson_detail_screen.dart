import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../theme/app_theme.dart';
import '../models/lesson.dart';
import 'drawing_canvas_screen.dart';

class LessonDetailScreen extends StatefulWidget {
  final Lesson lesson;
  const LessonDetailScreen({super.key, required this.lesson});

  @override
  State<LessonDetailScreen> createState() => _LessonDetailScreenState();
}

class _LessonDetailScreenState extends State<LessonDetailScreen> {
  @override
  Widget build(BuildContext context) {
    final lesson = widget.lesson;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          _buildAppBar(lesson),
          SliverToBoxAdapter(child: _buildHeader(lesson)),
          SliverToBoxAdapter(child: _buildInfoRow(lesson)),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 12),
              child: Text('Curriculum', style: AppTextStyles.h2),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, i) => _buildStepTile(lesson.steps[i], i),
              childCount: lesson.steps.length,
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
      bottomSheet: _buildBottomAction(lesson),
    );
  }

  SliverAppBar _buildAppBar(Lesson lesson) {
    return SliverAppBar(
      pinned: true,
      backgroundColor: AppColors.surface,
      surfaceTintColor: Colors.transparent,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_rounded, color: AppColors.onSurface),
        onPressed: () => Navigator.of(context).pop(),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.share_outlined, color: AppColors.onSurface),
          onPressed: () {},
        ),
      ],
    );
  }

  Widget _buildHeader(Lesson lesson) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: CachedNetworkImage(
              imageUrl: lesson.thumbnailUrl,
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 20),
          Text(lesson.title, style: AppTextStyles.h1),
          const SizedBox(height: 8),
          Text(lesson.subtitle, style: AppTextStyles.bodyMd.copyWith(color: AppColors.onSurfaceVariant)),
        ],
      ),
    );
  }

  Widget _buildInfoRow(Lesson lesson) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Row(
        children: [
          _infoItem(Icons.timer_outlined, '${lesson.durationMinutes} min'),
          const SizedBox(width: 16),
          _infoItem(Icons.bolt_rounded, '${lesson.xpReward} XP'),
          const SizedBox(width: 16),
          _infoItem(Icons.bar_chart_rounded, lesson.difficulty),
        ],
      ),
    );
  }

  Widget _infoItem(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, size: 16, color: AppColors.primary),
          const SizedBox(width: 6),
          Text(label, style: AppTextStyles.labelMd.copyWith(fontSize: 13)),
        ],
      ),
    );
  }

  Widget _buildStepTile(LessonStep step, int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.outline),
        ),
        child: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text('${index + 1}', style: AppTextStyles.labelMd.copyWith(color: AppColors.primary)),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(step.title, style: AppTextStyles.labelMd),
                  Text(step.description, style: AppTextStyles.caption),
                ],
              ),
            ),
            Icon(Icons.play_circle_outline_rounded, color: AppColors.onSurfaceVariant.withOpacity(0.5)),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomAction(Lesson lesson) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
      decoration: BoxDecoration(
        color: AppColors.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => DrawingCanvasScreen(lesson: lesson)),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(vertical: 18),
              ),
              child: Text('Start Workout', style: AppTextStyles.h2.copyWith(color: Colors.white, fontSize: 18)),
            ),
          ),
        ],
      ),
    );
  }
}
