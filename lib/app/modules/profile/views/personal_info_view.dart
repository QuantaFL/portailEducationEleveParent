import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:portail_eleve/app/modules/profile/controllers/profile_controller.dart';

class PersonalInfoView extends StatelessWidget {
  const PersonalInfoView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ProfileController controller = Get.put(ProfileController());

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: Obx(() {
          if (controller.isLoading.value) {
            return const Center(
              child: CircularProgressIndicator(color: Color(0xFF6366F1)),
            );
          }

          return CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Container(
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
                      children: [
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () => Get.back(),
                              child: Container(
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
                                  Icons.arrow_back_rounded,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            const Expanded(
                              child: Text(
                                'Mon Profil',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                  letterSpacing: -0.5,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 24),

                        _buildProfileHeader(controller),
                      ],
                    ),
                  ),
                ),
              ),

              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 8),

                      _buildSection(
                        'Informations personnelles',
                        Icons.person_rounded,
                        [
                          _buildInfoItem(
                            'Nom complet',
                            controller.getFullName(),
                            Icons.badge_rounded,
                            false,
                          ),
                          _buildInfoItem(
                            'Date de naissance',
                            controller.getBirthDate(),
                            Icons.cake_rounded,
                            false,
                          ),
                          _buildInfoItem(
                            'Genre',
                            controller.getGender(),
                            Icons.wc_rounded,
                            false,
                          ),
                          _buildInfoItem(
                            'Matricule',
                            controller.getMatricule(),
                            Icons.qr_code_rounded,
                            false,
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      _buildSection('Coordonnées', Icons.contact_mail_rounded, [
                        _buildInfoItem(
                          'Email',
                          controller.getEmail(),
                          Icons.email_rounded,
                          true,
                        ),
                        _buildInfoItem(
                          'Téléphone',
                          controller.getPhoneNumber(),
                          Icons.phone_rounded,
                          true,
                        ),
                        _buildInfoItem(
                          'Adresse',
                          controller.getAddress(),
                          Icons.location_on_rounded,
                          true,
                        ),
                      ]),

                      const SizedBox(height: 20),

                      _buildSection(
                        'Informations scolaires',
                        Icons.school_rounded,
                        [
                          _buildInfoItem(
                            'Établissement',
                            'Groupe Scolaire Quanta',
                            Icons.account_balance_rounded,
                            false,
                          ),
                          _buildInfoItem(
                            'Classe actuelle',
                            controller.getCurrentClass(),
                            Icons.class_rounded,
                            false,
                          ),
                          _buildInfoItem(
                            'Année scolaire',
                            controller.getAcademicYear(),
                            Icons.calendar_today_rounded,
                            false,
                          ),
                          _buildInfoItem(
                            'Statut',
                            controller.getStudentStatus(),
                            Icons.verified_user_rounded,
                            false,
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      _buildSection(
                        'Contact parent/tuteur',
                        Icons.family_restroom_rounded,
                        [
                          _buildInfoItem(
                            'Nom du parent',
                            controller.getParentName(),
                            Icons.person_outline_rounded,
                            false,
                          ),
                          _buildInfoItem(
                            'Email du parent',
                            controller.getParentEmail(),
                            Icons.email_outlined,
                            false,
                          ),
                          _buildInfoItem(
                            'Téléphone du parent',
                            controller.getParentPhone(),
                            Icons.phone_outlined,
                            false,
                          ),
                        ],
                      ),

                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildProfileHeader(ProfileController controller) {
    return Row(
      children: [
        Stack(
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(
                  colors: [Colors.white, Color(0xFFF8FAFC)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: CircleAvatar(
                backgroundColor: Colors.transparent,
                child: Text(
                  controller.getInitials(),
                  style: const TextStyle(
                    color: Color(0xFF6366F1),
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 2,
              right: 2,
              child: Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: const Color(0xFF10B981),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
                child: const Icon(
                  Icons.check_rounded,
                  color: Colors.white,
                  size: 12,
                ),
              ),
            ),
          ],
        ),

        const SizedBox(width: 16),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                controller.getFullName(),
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  letterSpacing: -0.3,
                ),
              ),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.3),
                  ),
                ),
                child: Text(
                  controller.getCurrentClass(),
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(
                    Icons.school_rounded,
                    color: Colors.white.withValues(alpha: 0.8),
                    size: 14,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    controller.isStudent ? 'Élève actif' : 'Parent',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Colors.white.withValues(alpha: 0.9),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSection(String title, IconData icon, List<Widget> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 12),
          child: Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: Colors.white, size: 18),
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1E293B),
                  letterSpacing: -0.3,
                ),
              ),
            ],
          ),
        ),

        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(children: items),
        ),
      ],
    );
  }

  /// Builds individual information items with modern styling
  Widget _buildInfoItem(
    String label,
    String value,
    IconData icon,
    bool isEditable,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFFF1F5F9), width: 1)),
      ),
      child: Row(
        children: [
          // Icon Container
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: const Color(0xFF6366F1).withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: const Color(0xFF6366F1), size: 20),
          ),

          const SizedBox(width: 16),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade600,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1E293B),
                    letterSpacing: -0.1,
                  ),
                ),
              ],
            ),
          ),

          if (isEditable)
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFF6366F1).withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.edit_rounded,
                color: const Color(0xFF6366F1),
                size: 16,
              ),
            ),
        ],
      ),
    );
  }
}
