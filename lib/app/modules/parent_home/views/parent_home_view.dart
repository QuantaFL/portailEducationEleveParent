import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/data/models/user_model.dart';
import '../../profile/views/about_view.dart';
import '../../profile/views/help_view.dart';
import '../../profile/views/personal_info_view.dart';
import '../../profile/views/security_view.dart';
import '../../student_home/widgets/bulletin_card.dart';
import '../controllers/parent_home_controller.dart';
import '../widgets/parent_bottom_nav_bar.dart';

class ParentHomeView extends GetView<ParentHomeController> {
  const ParentHomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFF8FAFC), Color(0xFFFFFFFF)],
          ),
        ),
        child: Obx(
          () => IndexedStack(
            index: controller.currentIndex.value,
            children: [
              _buildModernDashboard(context, controller),
              _buildBulletinsHistory(context, controller),
              _buildProfile(context, controller),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const ParentBottomNavBar(),
    );
  }

  Widget _buildModernDashboard(
    BuildContext context,
    ParentHomeController controller,
  ) {
    return Obx(() {
      final parent = controller.currentParent.value;
      final children = controller.children;

      return SafeArea(
        child: RefreshIndicator(
          onRefresh: controller.refreshData,
          color: const Color(0xFF6366F1),
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(
                child: _buildModernHeader(context, parent, children),
              ),

              if (children.isNotEmpty)
                SliverToBoxAdapter(
                  child: _buildModernChildSelector(context, controller),
                ),

              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: _buildDashboardCards(context, controller),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildModernHeader(
    BuildContext context,
    UserModel? parent,
    List children,
  ) {
    return Container(
      margin: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF6366F1).withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withValues(alpha: 0.2),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.3),
                      width: 2,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      parent != null ? _getInitials(parent, controller) : 'P',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        parent != null
                            ? '${parent.firstName} ${parent.lastName}'
                            : 'Parent',
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        children.isNotEmpty
                            ? '${children.length} enfant${children.length > 1 ? 's' : ''}'
                            : 'Espace Parent',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.white.withValues(alpha: 0.9),
                        ),
                      ),
                    ],
                  ),
                ),

                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.3),
                    ),
                  ),
                  child: const Icon(
                    Icons.notifications_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ],
            ),

            if (children.isNotEmpty) ...[
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.2),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.school_rounded,
                      color: Colors.white.withValues(alpha: 0.9),
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Suivi de la scolarité',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.white.withValues(alpha: 0.95),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildModernChildSelector(
    BuildContext context,
    ParentHomeController controller,
  ) {
    return Obx(() {
      final children = controller.children;
      final childrenUsers = controller.childrenUsers;

      if (children.isEmpty) return const SizedBox.shrink();

      return Container(
        height: 140,
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
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
                margin: const EdgeInsets.only(right: 16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: isSelected
                      ? const LinearGradient(
                          colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        )
                      : LinearGradient(
                          colors: [Colors.white, Colors.grey.shade50],
                        ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: const Color(
                              0xFF6366F1,
                            ).withValues(alpha: 0.3),
                            blurRadius: 15,
                            offset: const Offset(0, 5),
                          ),
                        ]
                      : [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 2),
                          ),
                        ],
                  border: isSelected
                      ? null
                      : Border.all(color: Colors.grey.shade200, width: 1),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isSelected
                            ? Colors.white.withValues(alpha: 0.2)
                            : const Color(0xFF6366F1).withValues(alpha: 0.1),
                        border: Border.all(
                          color: isSelected
                              ? Colors.white.withValues(alpha: 0.3)
                              : const Color(0xFF6366F1).withValues(alpha: 0.2),
                          width: 2,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          _getInitials(childUser, controller),
                          style: TextStyle(
                            color: isSelected
                                ? Colors.white
                                : const Color(0xFF6366F1),
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      childUser.firstName ?? 'Enfant',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: isSelected
                            ? Colors.white
                            : const Color(0xFF1E293B),
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (child.latestStudentSession?.classModel?.name !=
                        null) ...[
                      const SizedBox(height: 4),
                      Text(
                        child.latestStudentSession!.classModel!.name!,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                          color: isSelected
                              ? Colors.white.withValues(alpha: 0.8)
                              : Colors.grey.shade600,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
            );
          },
        ),
      );
    });
  }

  List<Widget> _buildDashboardCards(
    BuildContext context,
    ParentHomeController controller,
  ) {
    final children = controller.children;

    if (children.isEmpty) {
      return [_buildModernNoChildrenCard(context, controller)];
    }

    final selectedChildUser = controller.selectedChildUser;
    final recentBulletins = controller.recentBulletins;

    return [
      if (selectedChildUser != null)
        _buildModernChildInfoCard(
          selectedChildUser,
          children[controller.selectedChildIndex.value],
          controller,
        ),

      const SizedBox(height: 20),

      _buildModernBulletinsSection(context, recentBulletins, controller),
    ];
  }

  Widget _buildModernNoChildrenCard(
    BuildContext context,
    ParentHomeController controller,
  ) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Icon(
              Icons.family_restroom,
              size: 40,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Aucun enfant trouvé',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1E293B),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Contactez l\'administration pour ajouter vos enfants à votre compte.',
            style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Text(
              'Contacter l\'administration',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModernChildInfoCard(
    UserModel child,
    dynamic studentData,
    ParentHomeController controller,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                  ),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Center(
                  child: Text(
                    _getInitials(child, controller),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${child.firstName} ${child.lastName}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1E293B),
                      ),
                    ),
                    const SizedBox(height: 4),
                    if (studentData.latestStudentSession?.classModel?.name !=
                        null)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF6366F1).withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          studentData.latestStudentSession!.classModel!.name!,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF6366F1),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF10B981).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.check_circle_rounded,
                  color: Color(0xFF10B981),
                  size: 20,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _buildInfoChip(Icons.school_rounded, 'Élève actif', controller),
              const SizedBox(width: 12),
              if (studentData.matricule != null)
                _buildInfoChip(
                  Icons.badge_rounded,
                  studentData.matricule!,
                  controller,
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip(
    IconData icon,
    String label,
    ParentHomeController controller,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: Colors.grey.shade600),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Colors.grey.shade700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModernBulletinsSection(
    BuildContext context,
    List bulletins,
    ParentHomeController controller,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.description_rounded,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'Bulletins récents',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1E293B),
                  ),
                ),
              ),
              TextButton(
                onPressed: () => controller.currentIndex.value = 1,
                child: const Text(
                  'Voir tout',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF6366F1),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (bulletins.isEmpty)
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  Icon(
                    Icons.inbox_rounded,
                    size: 48,
                    color: Colors.grey.shade400,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Aucun bulletin disponible',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            )
          else
            ...bulletins.map(
              (bulletin) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
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

  String _getInitials(UserModel user, ParentHomeController controller) {
    final firstName = user.firstName ?? '';
    final lastName = user.lastName ?? '';
    return '${firstName.isNotEmpty ? firstName[0] : ''}${lastName.isNotEmpty ? lastName[0] : ''}'
        .toUpperCase();
  }

  Widget _buildBulletinsHistory(
    BuildContext context,
    ParentHomeController controller,
  ) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Historique des bulletins',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1E293B),
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: Obx(() {
                final bulletins = controller.bulletinsHistory;

                if (bulletins.isEmpty) {
                  return Container(
                    padding: const EdgeInsets.all(32),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 15,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Icon(
                            Icons.description_rounded,
                            size: 40,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 24),
                        const Text(
                          'Aucun bulletin disponible',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF1E293B),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Les bulletins de vos enfants apparaîtront ici une fois disponibles.',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade600,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: bulletins.length,
                  itemBuilder: (context, index) {
                    final bulletin = bulletins[index];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: BulletinCard(
                        bulletin: bulletin,
                        onDownload: () =>
                            controller.downloadBulletin(bulletin.id!),
                      ),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfile(BuildContext context, ParentHomeController controller) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Profil',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1E293B),
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: ListView(
                children: [
                  _buildModernProfileItem(
                    icon: Icons.person_rounded,
                    title: 'Informations Personnelles',
                    subtitle: 'Gérer vos informations personnelles',
                    onTap: () => _navigateToParentProfile(controller),
                    controller: controller,
                  ),
                  _buildModernProfileItem(
                    icon: Icons.family_restroom_rounded,
                    title: 'Historique des bulletins',
                    subtitle: 'Consulter tous les bulletins de vos enfants',
                    onTap: () => controller.currentIndex.value = 1,
                    controller: controller,
                  ),
                  _buildModernProfileItem(
                    icon: Icons.lock_rounded,
                    title: 'Sécurité',
                    subtitle: 'Modifier votre mot de passe',
                    onTap: () => Get.to(() => const SecurityView()),
                    controller: controller,
                  ),
                  _buildModernProfileItem(
                    icon: Icons.notifications_rounded,
                    title: 'Notifications',
                    subtitle: 'Gérer vos préférences de notifications',
                    onTap: () => Get.snackbar('Info', 'Notifications à venir'),
                    controller: controller,
                  ),
                  _buildModernProfileItem(
                    icon: Icons.help_rounded,
                    title: 'Aide et Support',
                    subtitle: 'Besoin d\'aide ? Contactez-nous',
                    onTap: () => Get.to(() => const HelpView()),
                    controller: controller,
                  ),
                  _buildModernProfileItem(
                    icon: Icons.info_rounded,
                    title: 'À Propos',
                    subtitle: 'En savoir plus sur l\'application',
                    onTap: () => Get.to(() => const AboutView()),
                    controller: controller,
                  ),
                  const SizedBox(height: 20),
                  _buildModernProfileItem(
                    icon: Icons.logout_rounded,
                    title: 'Déconnexion',
                    subtitle: 'Se déconnecter de votre compte',
                    onTap: () => controller.logout(),
                    isDestructive: true,
                    controller: controller,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildModernProfileItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    required ParentHomeController controller,
    bool isDestructive = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            gradient: isDestructive
                ? const LinearGradient(
                    colors: [Color(0xFFEF4444), Color(0xFFF87171)],
                  )
                : const LinearGradient(
                    colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                  ),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(icon, color: Colors.white, size: 22),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: isDestructive
                ? const Color(0xFFEF4444)
                : const Color(0xFF1E293B),
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios_rounded,
          size: 16,
          color: Colors.grey.shade400,
        ),
      ),
    );
  }

  void _navigateToParentProfile(ParentHomeController controller) {
    final parent = controller.currentParent.value;

    if (parent != null) {
      Get.to(
        () => const PersonalInfoView(),
        arguments: {'parentUser': parent}, // Pass UserModel directly
      );
    }
  }
}
