import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/data/models/user_model.dart';
import '../../../shared/widgets/child_info_card.dart';
import '../../../shared/widgets/dashboard_layout.dart';
import '../../../shared/widgets/user_profile_header.dart';
import '../../../themes/palette_system.dart';
import '../../profile/views/about_view.dart';
import '../../profile/views/help_view.dart';
import '../../profile/views/personal_info_view.dart';
import '../../profile/views/security_view.dart';
import '../../student_home/widgets/bulletin_card.dart';
import '../controllers/parent_home_controller.dart';
import '../widgets/parent_bottom_nav_bar.dart';

/// Clean and simple parent home view
class ParentHomeView extends GetView<ParentHomeController> {
  const ParentHomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppDesignSystem.surface,
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppDesignSystem.surfaceGradient,
        ),
        child: Obx(
          () => IndexedStack(
            index: controller.currentIndex.value,
            children: [
              _buildDashboard(context),
              _buildBulletinsHistory(context),
              _buildProfile(context),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const ParentBottomNavBar(),
    );
  }

  /// Clean dashboard focused on parent, children, and bulletins
  Widget _buildDashboard(BuildContext context) {
    return Obx(() {
      final parent = controller.currentParent.value;
      final children = controller.children;

      return DashboardLayout(
        header: parent != null
            ? UserProfileHeader(
                user: parent,
                subtitle: children.isNotEmpty
                    ? '${children.length} enfant${children.length > 1 ? 's' : ''}'
                    : 'Espace Parent',
                role: 'Parent',
              )
            : _buildLoadingHeader(context),
        selector: children.isNotEmpty ? _buildChildSelector(context) : null,
        cards: _buildDashboardCards(context),
        onRefresh: controller.loadParentDashboardData,
        isLoading: controller.isLoading.value && children.isEmpty,
      );
    });
  }

  /// Loading header placeholder
  Widget _buildLoadingHeader(BuildContext context) {
    return Container(
      height: 120,
      decoration: BoxDecoration(
        gradient: AppDesignSystem.primaryGradient,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(
            AppDesignSystem.textInverse,
          ),
        ),
      ),
    );
  }

  /// Beautiful child selector with enhanced design
  Widget _buildChildSelector(BuildContext context) {
    return Obx(() {
      final children = controller.children;
      final childrenUsers = controller.childrenUsers;

      if (children.isEmpty) return const SizedBox.shrink();

      return Container(
        height: 140,
        margin: EdgeInsets.symmetric(
          horizontal: AppDesignSystem.spacing(context, 16),
          vertical: AppDesignSystem.spacing(context, 8),
        ),
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: children.length,
          itemBuilder: (context, index) {
            final child = children[index];
            final childUser = childrenUsers.firstWhere(
              (u) => u.id == child.userModelId,
              orElse: () => UserModel(firstName: 'Enfant ${index + 1}'),
            );

            final isSelected = controller.selectedChildIndex.value == index;

            return GestureDetector(
              onTap: () => controller.selectChild(index),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                width: 120,
                margin: EdgeInsets.only(
                  right: AppDesignSystem.spacing(context, 16),
                ),
                padding: AppDesignSystem.responsivePadding(context, all: 16),
                decoration: BoxDecoration(
                  gradient: isSelected
                      ? AppDesignSystem.primaryGradient
                      : LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            AppDesignSystem.surfaceContainer,
                            AppDesignSystem.surfaceContainer.withValues(
                              alpha: 0.8,
                            ),
                          ],
                        ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: AppDesignSystem.primary.withValues(
                              alpha: 0.3,
                            ),
                            blurRadius: 15,
                            offset: const Offset(0, 5),
                          ),
                        ]
                      : AppDesignSystem.elevation(2),
                  border: isSelected
                      ? null
                      : Border.all(
                          color: AppDesignSystem.primary.withValues(alpha: 0.1),
                          width: 1,
                        ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Child Avatar with beautiful design
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: isSelected
                            ? LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  Colors.white.withValues(alpha: 0.3),
                                  Colors.white.withValues(alpha: 0.1),
                                ],
                              )
                            : LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  AppDesignSystem.primary.withValues(
                                    alpha: 0.2,
                                  ),
                                  AppDesignSystem.primary.withValues(
                                    alpha: 0.1,
                                  ),
                                ],
                              ),
                        boxShadow: [
                          BoxShadow(
                            color: isSelected
                                ? Colors.white.withValues(alpha: 0.2)
                                : AppDesignSystem.primary.withValues(
                                    alpha: 0.1,
                                  ),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          _getChildInitials(
                            childUser.firstName,
                            childUser.lastName,
                          ),
                          style: TextStyle(
                            color: isSelected
                                ? AppDesignSystem.textInverse
                                : AppDesignSystem.primary,
                            fontWeight: FontWeight.w700,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: AppDesignSystem.spacing(context, 8)),

                    // Child Name
                    Text(
                      childUser.firstName ?? 'Enfant ${index + 1}',
                      style: TextStyle(
                        color: isSelected
                            ? AppDesignSystem.textInverse
                            : AppDesignSystem.textPrimary,
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),

                    // Child Grade/Class indicator (if available)
                    if (child.latestStudentSession != null)
                      Container(
                        margin: EdgeInsets.only(
                          top: AppDesignSystem.spacing(context, 4),
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: AppDesignSystem.spacing(context, 6),
                          vertical: AppDesignSystem.spacing(context, 2),
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? Colors.white.withValues(alpha: 0.2)
                              : AppDesignSystem.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'Classe ${child.latestStudentSession!.classModelId}',
                          style: TextStyle(
                            color: isSelected
                                ? AppDesignSystem.textInverse.withValues(
                                    alpha: 0.9,
                                  )
                                : AppDesignSystem.primary,
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            );
          },
        ),
      );
    });
  }

  /// Get child initials for avatar
  String _getChildInitials(String? firstName, String? lastName) {
    final first = firstName?.isNotEmpty == true
        ? firstName![0].toUpperCase()
        : '';
    final last = lastName?.isNotEmpty == true ? lastName![0].toUpperCase() : '';
    return '$first$last'.isEmpty ? '👶' : '$first$last';
  }

  /// Dashboard cards showing child info and bulletins
  List<Widget> _buildDashboardCards(BuildContext context) {
    final children = controller.children;

    if (children.isEmpty) {
      return [_buildNoChildrenCard(context)];
    }

    final selectedChildUser = controller.selectedChildUser;
    final recentBulletins = controller.recentBulletins;

    return [
      // Selected child info card
      if (selectedChildUser != null)
        ChildInfoCard(
          child: selectedChildUser,
          studentData: children[controller.selectedChildIndex.value],
        ),

      // Recent bulletins section
      _buildBulletinsSection(context, recentBulletins),
    ];
  }

  /// No children placeholder
  Widget _buildNoChildrenCard(BuildContext context) {
    return Container(
      padding: AppDesignSystem.responsivePadding(context, all: 32),
      decoration: BoxDecoration(
        color: AppDesignSystem.surfaceContainer,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppDesignSystem.elevation(1),
      ),
      child: Column(
        children: [
          Icon(
            Icons.family_restroom,
            size: 64,
            color: AppDesignSystem.primary.withValues(alpha: 0.5),
          ),
          SizedBox(height: AppDesignSystem.spacing(context, 16)),
          Text(
            'Aucun enfant trouvé',
            style: AppDesignSystem.textTheme(context).titleLarge?.copyWith(
              color: AppDesignSystem.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: AppDesignSystem.spacing(context, 8)),
          Text(
            'Contactez l\'administration pour ajouter vos enfants.',
            style: AppDesignSystem.textTheme(
              context,
            ).bodyMedium?.copyWith(color: AppDesignSystem.textSecondary),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  /// Bulletins section
  Widget _buildBulletinsSection(BuildContext context, List bulletins) {
    return Container(
      padding: AppDesignSystem.responsivePadding(context, all: 16),
      decoration: BoxDecoration(
        color: AppDesignSystem.surfaceContainer,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppDesignSystem.elevation(1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.description, color: AppDesignSystem.primary, size: 20),
              SizedBox(width: AppDesignSystem.spacing(context, 8)),
              Text(
                'Bulletins récents',
                style: AppDesignSystem.textTheme(context).titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppDesignSystem.textPrimary,
                ),
              ),
            ],
          ),
          SizedBox(height: AppDesignSystem.spacing(context, 16)),
          if (bulletins.isEmpty)
            Center(
              child: Padding(
                padding: AppDesignSystem.responsivePadding(context, all: 32),
                child: Column(
                  children: [
                    Icon(
                      Icons.inbox,
                      size: 48,
                      color: AppDesignSystem.textSecondary.withValues(
                        alpha: 0.5,
                      ),
                    ),
                    SizedBox(height: AppDesignSystem.spacing(context, 12)),
                    Text(
                      'Aucun bulletin disponible',
                      style: AppDesignSystem.textTheme(context).bodyLarge
                          ?.copyWith(color: AppDesignSystem.textSecondary),
                    ),
                  ],
                ),
              ),
            )
          else
            ...bulletins.map(
              (bulletin) => Padding(
                padding: EdgeInsets.only(
                  bottom: AppDesignSystem.spacing(context, 12),
                ),
                child: BulletinCard(
                  bulletin: bulletin,
                  onDownload: () => controller.downloadBulletin(bulletin.id!),
                ),
              ),
            ),
        ],
      ),
    );
  }

  /// Bulletins history view
  Widget _buildBulletinsHistory(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: AppDesignSystem.responsivePadding(
          context,
          horizontal: 16,
          vertical: 16,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Historique des bulletins',
              style: AppDesignSystem.textTheme(context).headlineMedium
                  ?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppDesignSystem.textPrimary,
                  ),
            ),
            SizedBox(height: AppDesignSystem.spacing(context, 20)),
            Expanded(
              child: ListView.builder(
                itemCount: controller.bulletinsHistory.length,
                itemBuilder: (context, index) {
                  final bulletin = controller.bulletinsHistory[index];

                  return Padding(
                    padding: EdgeInsets.only(
                      bottom: AppDesignSystem.spacing(context, 12),
                    ),
                    child: BulletinCard(
                      bulletin: bulletin,
                      onDownload: () =>
                          controller.downloadBulletin(bulletin.id!),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Profile view using existing ProfileListItem pattern from student home
  Widget _buildProfile(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: AppDesignSystem.responsivePadding(
          context,
          horizontal: 16,
          vertical: 16,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Profil',
              style: AppDesignSystem.textTheme(context).headlineMedium
                  ?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppDesignSystem.textPrimary,
                  ),
            ),
            SizedBox(height: AppDesignSystem.spacing(context, 24)),
            Expanded(
              child: ListView(
                children: [
                  ProfileListItem(
                    icon: Icons.person_outline,
                    title: 'Informations Personnelles',
                    onTap: () => Get.to(() => const PersonalInfoView()),
                  ),
                  ProfileListItem(
                    icon: Icons.lock_outline,
                    title: 'Sécurité',
                    onTap: () => Get.to(() => const SecurityView()),
                  ),
                  ProfileListItem(
                    icon: Icons.notifications_outlined,
                    title: 'Notifications',
                    onTap: () => Get.snackbar('Info', 'Notifications'),
                  ),
                  ProfileListItem(
                    icon: Icons.help_outline,
                    title: 'Aide et Support',
                    onTap: () => Get.to(() => const HelpView()),
                  ),
                  ProfileListItem(
                    icon: Icons.info_outline,
                    title: 'À Propos',
                    onTap: () => Get.to(() => const AboutView()),
                  ),
                  SizedBox(height: AppDesignSystem.spacing(context, 20)),
                  ProfileListItem(
                    icon: Icons.logout,
                    title: 'Déconnexion',
                    onTap: () => controller.logout(),
                    isDestructive: true,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// ProfileListItem widget - copied from student home
class ProfileListItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final bool isDestructive;

  const ProfileListItem({
    Key? key,
    required this.icon,
    required this.title,
    required this.onTap,
    this.isDestructive = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: AppDesignSystem.spacing(context, 12)),
      decoration: BoxDecoration(
        color: AppDesignSystem.surfaceContainer,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppDesignSystem.elevation(1),
      ),
      child: ListTile(
        leading: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: (isDestructive ? Colors.red : AppDesignSystem.primary)
                .withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: isDestructive ? Colors.red : AppDesignSystem.primary,
            size: 20,
          ),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: isDestructive ? Colors.red : AppDesignSystem.textPrimary,
          ),
        ),
        trailing: Icon(
          Icons.chevron_right,
          color: AppDesignSystem.textSecondary.withValues(alpha: 0.5),
        ),
        onTap: onTap,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }
}
