import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../../../themes/palette_system.dart';
import '../controllers/bulletin_detail_controller.dart';

class BulletinDetailView extends GetView<BulletinDetailController> {
  const BulletinDetailView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppDesignSystem.surface,
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppDesignSystem.surfaceGradient,
        ),
        child: Obx(
          () => controller.isLoading.value
              ? _buildLoadingState(context)
              : CustomScrollView(
                  slivers: [
                    _buildAppBar(context),
                    SliverToBoxAdapter(
                      child: Column(
                        children: [
                          _buildBulletinHeader(context),
                          _buildStatsSection(context),
                          _buildSubjectsSection(context),
                          _buildAppreciationSection(context),
                          SizedBox(
                            height: AppDesignSystem.spacing(context, 100),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
        ),
      ),
      floatingActionButton: _buildFloatingActionButton(context),
    );
  }

  Widget _buildLoadingState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: AppDesignSystem.responsiveSize(context, 80),
            height: AppDesignSystem.responsiveSize(context, 80),
            child: Lottie.asset(
              'assets/animations/loading_education.json',
              fit: BoxFit.contain,
            ),
          ),
          SizedBox(height: AppDesignSystem.spacing(context, 24)),
          Text(
            'Chargement du bulletin...',
            style: AppDesignSystem.textTheme(
              context,
            ).titleMedium?.copyWith(color: AppDesignSystem.textSecondary),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return SliverAppBar(
      expandedHeight: AppDesignSystem.responsiveSize(context, 120),
      floating: false,
      pinned: true,
      backgroundColor: AppDesignSystem.primary,
      foregroundColor: AppDesignSystem.textInverse,
      elevation: 0,
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          'Bulletin Scolaire',
          style: AppDesignSystem.textTheme(context).titleLarge?.copyWith(
            color: AppDesignSystem.textInverse,
            fontWeight: FontWeight.w600,
          ),
        ),
        background: Container(
          decoration: const BoxDecoration(
            gradient: AppDesignSystem.primaryGradient,
          ),
          child: Stack(
            children: [
              Positioned(
                right: -50,
                top: -50,
                child: Container(
                  width: AppDesignSystem.responsiveSize(context, 200),
                  height: AppDesignSystem.responsiveSize(context, 200),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppDesignSystem.textInverse.withValues(alpha: 0.1),
                  ),
                ),
              ),
              Positioned(
                right: 20,
                bottom: 20,
                child: Icon(
                  Icons.school,
                  size: AppDesignSystem.responsiveSize(context, 40),
                  color: AppDesignSystem.textInverse.withValues(alpha: 0.3),
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        IconButton(
          onPressed: controller.shareBulletin,
          icon: const Icon(Icons.share),
        ),
        PopupMenuButton<String>(
          onSelected: (value) {
            switch (value) {
              case 'download':
                controller.downloadBulletin();
                break;
              case 'pdf':
                controller.viewPDF();
                break;
            }
          },
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'download',
              child: Row(
                children: [
                  Icon(Icons.download),
                  SizedBox(width: 8),
                  Text('Télécharger'),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'pdf',
              child: Row(
                children: [
                  Icon(Icons.picture_as_pdf),
                  SizedBox(width: 8),
                  Text('Voir PDF'),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildBulletinHeader(BuildContext context) {
    return Container(
      margin: AppDesignSystem.responsivePadding(context, all: 16),
      padding: AppDesignSystem.responsivePadding(context, all: 20),
      decoration: AppDesignSystem.cardDecoration(context, elevation: 3),
      child: Obx(() {
        final data = controller.bulletinData;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: AppDesignSystem.responsivePadding(
                    context,
                    horizontal: 12,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    gradient: AppDesignSystem.primaryGradient,
                    borderRadius: BorderRadius.circular(
                      AppDesignSystem.responsiveRadius(context, 12),
                    ),
                  ),
                  child: Icon(
                    Icons.description,
                    color: AppDesignSystem.textInverse,
                    size: AppDesignSystem.responsiveSize(context, 24),
                  ),
                ),
                SizedBox(width: AppDesignSystem.spacing(context, 16)),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        data['title'] ?? 'Bulletin',
                        style: AppDesignSystem.textTheme(context).headlineSmall
                            ?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: AppDesignSystem.textPrimary,
                            ),
                      ),
                      SizedBox(height: AppDesignSystem.spacing(context, 4)),
                      Text(
                        '${data['classe']} • ${data['periode']}',
                        style: AppDesignSystem.textTheme(context).bodyMedium
                            ?.copyWith(color: AppDesignSystem.textSecondary),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: AppDesignSystem.spacing(context, 20)),
            _buildInfoRow(
              context,
              'Établissement',
              data['etablissement'] ?? 'N/A',
            ),
            _buildInfoRow(
              context,
              'Date du conseil',
              data['date_conseil'] ?? 'N/A',
            ),
            _buildInfoRow(
              context,
              'Date d\'édition',
              data['date_edition'] ?? 'N/A',
            ),
          ],
        );
      }).animate().fadeIn(duration: 600.ms).slideY(begin: 0.3),
    );
  }

  Widget _buildInfoRow(BuildContext context, String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: AppDesignSystem.spacing(context, 4),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: AppDesignSystem.textTheme(
              context,
            ).bodyMedium?.copyWith(color: AppDesignSystem.textSecondary),
          ),
          Text(
            value,
            style: AppDesignSystem.textTheme(context).bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: AppDesignSystem.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsSection(BuildContext context) {
    return Container(
      margin: AppDesignSystem.responsivePadding(context, horizontal: 16),
      child: Obx(() {
        final data = controller.bulletinData;
        return AnimationLimiter(
          child: GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: AppDesignSystem.spacing(context, 12),
            mainAxisSpacing: AppDesignSystem.spacing(context, 12),
            childAspectRatio: 1.5,
            children: [
              AnimationConfiguration.staggeredGrid(
                position: 0,
                duration: const Duration(milliseconds: 375),
                columnCount: 2,
                child: ScaleAnimation(
                  child: FadeInAnimation(
                    child: _buildStatCard(
                      context,
                      'Moyenne générale',
                      '${data['moyenne_generale']}/20',
                      Icons.trending_up,
                      AppDesignSystem.success,
                    ),
                  ),
                ),
              ),
              AnimationConfiguration.staggeredGrid(
                position: 1,
                duration: const Duration(milliseconds: 375),
                columnCount: 2,
                child: ScaleAnimation(
                  child: FadeInAnimation(
                    child: _buildStatCard(
                      context,
                      'Moyenne classe',
                      '${data['moyenne_classe']}/20',
                      Icons.group,
                      AppDesignSystem.info,
                    ),
                  ),
                ),
              ),
              AnimationConfiguration.staggeredGrid(
                position: 2,
                duration: const Duration(milliseconds: 375),
                columnCount: 2,
                child: ScaleAnimation(
                  child: FadeInAnimation(
                    child: _buildStatCard(
                      context,
                      'Classement',
                      '${data['rang']}/${data['total_eleves']}',
                      Icons.emoji_events,
                      AppDesignSystem.accent,
                    ),
                  ),
                ),
              ),
              AnimationConfiguration.staggeredGrid(
                position: 3,
                duration: const Duration(milliseconds: 375),
                columnCount: 2,
                child: ScaleAnimation(
                  child: FadeInAnimation(
                    child: _buildStatCard(
                      context,
                      'Matières',
                      '${controller.subjects.length}',
                      Icons.book,
                      AppDesignSystem.secondary,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildStatCard(
    BuildContext context,
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: AppDesignSystem.responsivePadding(
        context,
        horizontal: 16,
        vertical: 16,
      ),
      decoration: AppDesignSystem.cardDecoration(context, elevation: 2),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: AppDesignSystem.responsivePadding(
              context,
              horizontal: 8,
              vertical: 8,
            ),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(
                AppDesignSystem.responsiveRadius(context, 8),
              ),
            ),
            child: Icon(
              icon,
              color: color,
              size: AppDesignSystem.responsiveSize(context, 24),
            ),
          ),
          SizedBox(height: AppDesignSystem.spacing(context, 8)),
          Text(
            value,
            style: AppDesignSystem.textTheme(context).titleLarge?.copyWith(
              fontWeight: FontWeight.w700,
              color: AppDesignSystem.textPrimary,
            ),
          ),
          SizedBox(height: AppDesignSystem.spacing(context, 4)),
          Text(
            title,
            style: AppDesignSystem.textTheme(
              context,
            ).bodySmall?.copyWith(color: AppDesignSystem.textSecondary),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildSubjectsSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: AppDesignSystem.responsivePadding(
            context,
            horizontal: 16,
            vertical: 20,
          ),
          child: Text(
            'Détail par matière',
            style: AppDesignSystem.textTheme(context).headlineSmall?.copyWith(
              fontWeight: FontWeight.w700,
              color: AppDesignSystem.textPrimary,
            ),
          ),
        ).animate().fadeIn(delay: 800.ms).slideX(begin: -0.3),

        Obx(
          () => AnimationLimiter(
            child: ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: AppDesignSystem.responsivePadding(
                context,
                horizontal: 16,
              ),
              itemCount: controller.subjects.length,
              itemBuilder: (context, index) {
                final subject = controller.subjects[index];
                return AnimationConfiguration.staggeredList(
                  position: index,
                  duration: const Duration(milliseconds: 375),
                  child: SlideAnimation(
                    verticalOffset: 50.0,
                    child: FadeInAnimation(
                      child: _buildSubjectCard(context, subject, index),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSubjectCard(
    BuildContext context,
    Map<String, dynamic> subject,
    int index,
  ) {
    final colors = [
      AppDesignSystem.primary,
      AppDesignSystem.secondary,
      AppDesignSystem.accent,
      AppDesignSystem.success,
    ];
    final color = colors[index % colors.length];

    return Container(
      margin: EdgeInsets.only(bottom: AppDesignSystem.spacing(context, 16)),
      decoration: AppDesignSystem.cardDecoration(context, elevation: 2),
      child: ExpansionTile(
        leading: Container(
          padding: AppDesignSystem.responsivePadding(context, all: 8),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(
              AppDesignSystem.responsiveRadius(context, 8),
            ),
          ),
          child: Icon(
            Icons.subject,
            color: color,
            size: AppDesignSystem.responsiveSize(context, 20),
          ),
        ),
        title: Text(
          subject['nom'],
          style: AppDesignSystem.textTheme(context).titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: AppDesignSystem.textPrimary,
          ),
        ),
        subtitle: Text(
          'Moyenne: ${subject['moyenne']}/20 • Coef: ${subject['coefficient']}',
          style: AppDesignSystem.textTheme(
            context,
          ).bodySmall?.copyWith(color: AppDesignSystem.textSecondary),
        ),
        trailing: Container(
          padding: AppDesignSystem.responsivePadding(
            context,
            horizontal: 8,
            vertical: 4,
          ),
          decoration: BoxDecoration(
            color: _getGradeColor(subject['moyenne']).withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(
              AppDesignSystem.responsiveRadius(context, 12),
            ),
          ),
          child: Text(
            '${subject['moyenne']}/20',
            style: AppDesignSystem.textTheme(context).labelMedium?.copyWith(
              color: _getGradeColor(subject['moyenne']),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        children: [
          Padding(
            padding: AppDesignSystem.responsivePadding(context, all: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSubjectStats(context, subject),
                SizedBox(height: AppDesignSystem.spacing(context, 16)),
                _buildSubjectNotes(context, subject),
                SizedBox(height: AppDesignSystem.spacing(context, 16)),
                _buildSubjectAppreciation(context, subject),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubjectStats(
    BuildContext context,
    Map<String, dynamic> subject,
  ) {
    return Row(
      children: [
        Expanded(
          child: _buildStatItem(
            context,
            'Moyenne classe',
            '${subject['moyenne_classe']}/20',
          ),
        ),
        Expanded(child: _buildStatItem(context, 'Rang', '${subject['rang']}')),
        Expanded(
          child: _buildStatItem(context, 'Professeur', subject['professeur']),
        ),
      ],
    );
  }

  Widget _buildStatItem(BuildContext context, String label, String value) {
    return Column(
      children: [
        Text(
          label,
          style: AppDesignSystem.textTheme(
            context,
          ).labelSmall?.copyWith(color: AppDesignSystem.textTertiary),
        ),
        SizedBox(height: AppDesignSystem.spacing(context, 4)),
        Text(
          value,
          style: AppDesignSystem.textTheme(context).bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: AppDesignSystem.textPrimary,
          ),
        ),
      ],
    );
  }

  Widget _buildSubjectNotes(
    BuildContext context,
    Map<String, dynamic> subject,
  ) {
    final notes = subject['notes'] as List;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Notes obtenues',
          style: AppDesignSystem.textTheme(context).titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
            color: AppDesignSystem.textPrimary,
          ),
        ),
        SizedBox(height: AppDesignSystem.spacing(context, 8)),
        ...notes
            .map(
              (note) => Padding(
                padding: EdgeInsets.symmetric(
                  vertical: AppDesignSystem.spacing(context, 4),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        note['type'],
                        style: AppDesignSystem.textTheme(context).bodySmall
                            ?.copyWith(color: AppDesignSystem.textSecondary),
                      ),
                    ),
                    Text(
                      '${note['note']}/${note['sur']}',
                      style: AppDesignSystem.textTheme(context).bodySmall
                          ?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: _getGradeColor(note['note']),
                          ),
                    ),
                    SizedBox(width: AppDesignSystem.spacing(context, 8)),
                    Text(
                      note['date'],
                      style: AppDesignSystem.textTheme(context).bodySmall
                          ?.copyWith(color: AppDesignSystem.textTertiary),
                    ),
                  ],
                ),
              ),
            )
            .toList(),
      ],
    );
  }

  Widget _buildSubjectAppreciation(
    BuildContext context,
    Map<String, dynamic> subject,
  ) {
    return Container(
      padding: AppDesignSystem.responsivePadding(context, all: 12),
      decoration: BoxDecoration(
        color: AppDesignSystem.surfaceVariant,
        borderRadius: BorderRadius.circular(
          AppDesignSystem.responsiveRadius(context, 8),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Appréciation',
            style: AppDesignSystem.textTheme(context).labelMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: AppDesignSystem.textPrimary,
            ),
          ),
          SizedBox(height: AppDesignSystem.spacing(context, 4)),
          Text(
            subject['appreciation'],
            style: AppDesignSystem.textTheme(context).bodySmall?.copyWith(
              color: AppDesignSystem.textSecondary,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppreciationSection(BuildContext context) {
    return Container(
      margin: AppDesignSystem.responsivePadding(context, all: 16),
      padding: AppDesignSystem.responsivePadding(context, all: 20),
      decoration: AppDesignSystem.cardDecoration(context, elevation: 2),
      child: Obx(() {
        final data = controller.bulletinData;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.rate_review,
                  color: AppDesignSystem.primary,
                  size: AppDesignSystem.responsiveSize(context, 24),
                ),
                SizedBox(width: AppDesignSystem.spacing(context, 8)),
                Text(
                  'Appréciation générale',
                  style: AppDesignSystem.textTheme(context).titleMedium
                      ?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppDesignSystem.textPrimary,
                      ),
                ),
              ],
            ),
            SizedBox(height: AppDesignSystem.spacing(context, 16)),
            Container(
              padding: AppDesignSystem.responsivePadding(context, all: 16),
              decoration: BoxDecoration(
                color: AppDesignSystem.primarySoft,
                borderRadius: BorderRadius.circular(
                  AppDesignSystem.responsiveRadius(context, 12),
                ),
              ),
              child: Text(
                data['appreciation_generale'] ?? 'Aucune appréciation',
                style: AppDesignSystem.textTheme(context).bodyMedium?.copyWith(
                  color: AppDesignSystem.textPrimary,
                  height: 1.5,
                ),
              ),
            ),
          ],
        );
      }),
    ).animate().fadeIn(delay: 1000.ms).slideY(begin: 0.3);
  }

  Widget _buildFloatingActionButton(BuildContext context) {
    return Obx(
      () => FloatingActionButton.extended(
        onPressed: controller.isDownloading.value
            ? null
            : controller.downloadBulletin,
        backgroundColor: AppDesignSystem.primary,
        foregroundColor: AppDesignSystem.textInverse,
        icon: controller.isDownloading.value
            ? SizedBox(
                width: AppDesignSystem.responsiveSize(context, 20),
                height: AppDesignSystem.responsiveSize(context, 20),
                child: const CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : const Icon(Icons.download),
        label: Text(
          controller.isDownloading.value
              ? 'Téléchargement...'
              : 'Télécharger PDF',
          style: AppDesignSystem.textTheme(context).labelLarge?.copyWith(
            color: AppDesignSystem.textInverse,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Color _getGradeColor(double grade) {
    if (grade >= 16) return AppDesignSystem.success;
    if (grade >= 14) return AppDesignSystem.accent;
    if (grade >= 10) return AppDesignSystem.warning;
    return AppDesignSystem.error;
  }
}
