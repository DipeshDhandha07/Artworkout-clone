import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class SubscriptionScreen extends StatelessWidget {
  const SubscriptionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          _buildBackground(),
          SafeArea(
            child: Column(
              children: [
                _buildHeader(context),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      children: [
                        const SizedBox(height: 20),
                        _buildFeatureList(),
                        const SizedBox(height: 40),
                        _buildPricingCards(),
                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ),
                _buildFooter(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBackground() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.primary.withOpacity(0.8),
            AppColors.background,
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.close_rounded, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          Text(
            'ArtWorkout PRO',
            style: AppTextStyles.h2.copyWith(color: Colors.white, fontSize: 24),
          ),
          const SizedBox(width: 48), // Spacer
        ],
      ),
    );
  }

  Widget _buildFeatureList() {
    final features = [
      {'icon': Icons.all_inclusive_rounded, 'title': 'Unlimited Lessons', 'desc': 'Access 500+ drawing courses'},
      {'icon': Icons.visibility_off_rounded, 'title': 'No Interruptions', 'desc': 'Ad-free learning experience'},
      {'icon': Icons.cloud_done_rounded, 'title': 'Cloud Sync', 'desc': 'Save your art across all devices'},
      {'icon': Icons.palette_rounded, 'title': 'Advanced Tools', 'desc': 'Unlock custom brushes and layers'},
    ];

    return Column(
      children: features.map((f) => Padding(
        padding: const EdgeInsets.only(bottom: 24),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(f['icon'] as IconData, color: Colors.white, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(f['title'] as String, style: AppTextStyles.labelMd.copyWith(color: Colors.white, fontSize: 18)),
                  Text(f['desc'] as String, style: AppTextStyles.caption.copyWith(color: Colors.white70)),
                ],
              ),
            ),
          ],
        ),
      )).toList(),
    );
  }

  Widget _buildPricingCards() {
    return Column(
      children: [
        _pricingCard(
          title: 'Yearly Plan',
          price: '\$3.99 / mo',
          desc: 'Billed annually (\$47.88)',
          isPopular: true,
        ),
        const SizedBox(height: 16),
        _pricingCard(
          title: 'Monthly Plan',
          price: '\$7.99 / mo',
          desc: 'Cancel anytime',
          isPopular: false,
        ),
      ],
    );
  }

  Widget _pricingCard({required String title, required String price, required String desc, bool isPopular = false}) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isPopular ? Colors.white : AppColors.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: isPopular ? AppColors.primary : AppColors.outline, width: 2),
        boxShadow: [
          if (isPopular) BoxShadow(color: AppColors.primary.withOpacity(0.1), blurRadius: 20, offset: const Offset(0, 10)),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (isPopular)
                  Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text('SAVE 50%', style: AppTextStyles.labelMd.copyWith(color: Colors.white, fontSize: 10)),
                  ),
                Text(title, style: AppTextStyles.h2.copyWith(color: isPopular ? AppColors.primary : AppColors.onSurface)),
                Text(desc, style: AppTextStyles.caption),
              ],
            ),
          ),
          Text(price, style: AppTextStyles.h2.copyWith(fontSize: 20)),
        ],
      ),
    );
  }

  Widget _buildFooter() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.background,
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -4)),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(vertical: 18),
              ),
              child: Text('Try 7 Days Free', style: AppTextStyles.h2.copyWith(color: Colors.white)),
            ),
          ),
          const SizedBox(height: 16),
          Text('Restore Purchase', style: AppTextStyles.caption.copyWith(decoration: TextDecoration.underline)),
        ],
      ),
    );
  }
}
