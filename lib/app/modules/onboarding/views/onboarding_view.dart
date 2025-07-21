import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../core/data/models/onboarding_data.dart';
import '../../../themes/palette_system.dart';
import '../controllers/onboarding_controller.dart';

class OnboardingView extends GetView<OnboardingController> {
  const OnboardingView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppDesignSystem.surface,
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppDesignSystem.surfaceGradient,
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(context),
              Expanded(
                child: PageView.builder(
                  controller: controller.pageController,
                  onPageChanged: controller.onPageChanged,
                  itemCount: OnboardingData.getOnboardingData().length,
                  itemBuilder: (context, index) {
                    final data = OnboardingData.getOnboardingData()[index];
                    return _buildOnboardingPage(context, data, index);
                  },
                ),
              ),

              _buildBottomNavigation(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: AppDesignSystem.responsivePadding(
        context,
        horizontal: 20,
        vertical: 16,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(AppDesignSystem.spacing(context, 8)),
                decoration: BoxDecoration(
                  gradient: AppDesignSystem.primaryGradient,
                  borderRadius: BorderRadius.circular(
                    AppDesignSystem.responsiveRadius(context, 12),
                  ),
                  boxShadow: AppDesignSystem.elevation(2),
                ),
                child: Icon(
                  Icons.school,
                  color: AppDesignSystem.textInverse,
                  size: AppDesignSystem.responsiveSize(context, 24),
                ),
              ),
              SizedBox(width: AppDesignSystem.spacing(context, 12)),
              Text(
                'EduPortail',
                style: AppDesignSystem.textTheme(context).headlineSmall
                    ?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: AppDesignSystem.primary,
                    ),
              ),
            ],
          ),

          Obx(
            () => AnimatedOpacity(
              opacity: controller.isLastPage.value ? 0.0 : 1.0,
              duration: AppDesignSystem.mediumAnimation,
              child: TextButton(
                onPressed: controller.isLastPage.value
                    ? null
                    : controller.skipOnboarding,
                style: TextButton.styleFrom(
                  foregroundColor: AppDesignSystem.textSecondary,
                  padding: AppDesignSystem.responsivePadding(
                    context,
                    horizontal: 16,
                    vertical: 8,
                  ),
                ),
                child: Text(
                  'Passer',
                  style: AppDesignSystem.textTheme(
                    context,
                  ).labelLarge?.copyWith(color: AppDesignSystem.textSecondary),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOnboardingPage(
    BuildContext context,
    OnboardingData data,
    int index,
  ) {
    return Padding(
      padding: AppDesignSystem.responsivePadding(
        context,
        horizontal: 24,
        vertical: 16,
      ),
      child: Column(
        children: [
          Expanded(
            flex: 3,
            child: Center(
              child: Container(
                constraints: BoxConstraints(
                  maxHeight: AppDesignSystem.responsiveSize(context, 320),
                  maxWidth: AppDesignSystem.responsiveSize(context, 320),
                ),
                child: Lottie.asset(
                  data.lottieAsset,
                  fit: BoxFit.contain,
                  repeat: true,
                  animate: true,
                  frameRate: FrameRate(60),
                  options: LottieOptions(enableMergePaths: true),
                ),
              ),
            ),
          ),

          Expanded(
            flex: 4,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                      data.title,
                      style: AppDesignSystem.textTheme(context).displaySmall
                          ?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: AppDesignSystem.textPrimary,
                          ),
                      textAlign: TextAlign.center,
                    )
                    .animate()
                    .fadeIn(duration: 600.ms, delay: 400.ms)
                    .slideX(begin: 0.3, end: 0),

                SizedBox(height: AppDesignSystem.spacing(context, 16)),

                Text(
                      data.description,
                      style: AppDesignSystem.textTheme(context).bodyLarge
                          ?.copyWith(
                            color: AppDesignSystem.textSecondary,
                            height: 1.6,
                          ),
                      textAlign: TextAlign.center,
                    )
                    .animate()
                    .fadeIn(duration: 600.ms, delay: 600.ms)
                    .slideX(begin: -0.3, end: 0),

                SizedBox(height: AppDesignSystem.spacing(context, 32)),

                if (index == 1) _buildFeatureHighlights(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureHighlights(BuildContext context) {
    final features = [
      {'icon': Icons.analytics, 'text': 'Analyse en temps réel'},
      {'icon': Icons.notifications, 'text': 'Notifications intelligentes'},
      {'icon': Icons.security, 'text': 'Sécurité avancée'},
    ];

    return Column(
          children: features.map((feature) {
            return Padding(
              padding: EdgeInsets.symmetric(
                vertical: AppDesignSystem.spacing(context, 8),
              ),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(
                      AppDesignSystem.spacing(context, 8),
                    ),
                    decoration: BoxDecoration(
                      color: AppDesignSystem.primarySoft,
                      borderRadius: BorderRadius.circular(
                        AppDesignSystem.responsiveRadius(context, 8),
                      ),
                    ),
                    child: Icon(
                      feature['icon'] as IconData,
                      color: AppDesignSystem.primary,
                      size: AppDesignSystem.responsiveSize(context, 20),
                    ),
                  ),
                  SizedBox(width: AppDesignSystem.spacing(context, 12)),
                  Expanded(
                    child: Text(
                      feature['text'] as String,
                      style: AppDesignSystem.textTheme(context).bodyMedium
                          ?.copyWith(color: AppDesignSystem.textSecondary),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        )
        .animate()
        .fadeIn(duration: 600.ms, delay: 800.ms)
        .slideY(begin: 0.3, end: 0);
  }

  Widget _buildBottomNavigation(BuildContext context) {
    return Container(
      padding: AppDesignSystem.responsivePadding(
        context,
        horizontal: 24,
        vertical: 22,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Obx(
          //   () =>
          SmoothPageIndicator(
            controller: controller.pageController,
            count: OnboardingData.getOnboardingData().length,
            effect: WormEffect(
              dotHeight: AppDesignSystem.responsiveSize(context, 8),
              dotWidth: AppDesignSystem.responsiveSize(context, 8),
              spacing: AppDesignSystem.spacing(context, 16),
              radius: AppDesignSystem.responsiveRadius(context, 8),
              activeDotColor: AppDesignSystem.primary,
              dotColor: AppDesignSystem.border,
            ),
          ),

          // ),
          SizedBox(height: AppDesignSystem.spacing(context, 32)),

          Row(
            children: [
              Obx(
                () => AnimatedOpacity(
                  opacity: controller.currentPage.value > 0 ? 1.0 : 0.0,
                  duration: AppDesignSystem.mediumAnimation,
                  child: GestureDetector(
                    onTap: controller.currentPage.value > 0
                        ? controller.previousPage
                        : null,
                    child: Container(
                      padding: EdgeInsets.all(
                        AppDesignSystem.spacing(context, 12),
                      ),
                      decoration: BoxDecoration(
                        color: AppDesignSystem.surfaceContainer,
                        borderRadius: BorderRadius.circular(
                          AppDesignSystem.responsiveRadius(context, 12),
                        ),
                        border: Border.all(
                          color: AppDesignSystem.border,
                          width: 1,
                        ),
                        boxShadow: AppDesignSystem.elevation(1),
                      ),
                      child: Icon(
                        Icons.arrow_back_ios,
                        color: AppDesignSystem.textSecondary,
                        size: AppDesignSystem.responsiveSize(context, 20),
                      ),
                    ),
                  ),
                ),
              ),

              const Spacer(),

              Obx(
                () => GestureDetector(
                  onTap: () {
                    HapticFeedback.lightImpact();
                    controller.nextPage();
                  },
                  child: AnimatedContainer(
                    duration: AppDesignSystem.mediumAnimation,
                    padding: AppDesignSystem.responsivePadding(
                      context,
                      horizontal: controller.isLastPage.value ? 32 : 24,
                      vertical: 16,
                    ),
                    decoration: AppDesignSystem.buttonDecoration(context),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          controller.isLastPage.value ? 'Commencer' : 'Suivant',
                          style: AppDesignSystem.textTheme(context).labelLarge
                              ?.copyWith(
                                color: AppDesignSystem.textInverse,
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                        SizedBox(width: AppDesignSystem.spacing(context, 8)),
                        Icon(
                          controller.isLastPage.value
                              ? Icons.rocket_launch
                              : Icons.arrow_forward_ios,
                          color: AppDesignSystem.textInverse,
                          size: AppDesignSystem.responsiveSize(context, 18),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
