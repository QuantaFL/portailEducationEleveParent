import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:portail_eleve/app/routes/app_pages.dart';

import '../../../themes/palette_system.dart';

class StudentProfileHeader extends StatelessWidget {
  const StudentProfileHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: AppDesignSystem.responsivePadding(context, all: 16),
      padding: AppDesignSystem.responsivePadding(context, all: 20),
      decoration: BoxDecoration(
        gradient: AppDesignSystem.primaryGradient,
        borderRadius: BorderRadius.circular(
          AppDesignSystem.responsiveRadius(context, 20),
        ),
        boxShadow: AppDesignSystem.elevation(3),
      ),
      child: Column(
        children: [
          // Main row with profile info and notification
          Row(
            children: [
              // Profile Avatar
              Container(
                width: AppDesignSystem.responsiveSize(context, 60),
                height: AppDesignSystem.responsiveSize(context, 60),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppDesignSystem.textInverse,
                    width: 3,
                  ),
                  boxShadow: AppDesignSystem.elevation(2),
                ),
                child: CircleAvatar(
                  backgroundColor: AppDesignSystem.textInverse,
                  child: Text(
                    'MC',
                    style: AppDesignSystem.textTheme(context).titleLarge
                        ?.copyWith(
                          color: AppDesignSystem.primary,
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                ),
              ),

              SizedBox(width: AppDesignSystem.spacing(context, 16)),

              // Student Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Bonjour,',
                      style: AppDesignSystem.textTheme(context).bodyLarge
                          ?.copyWith(
                            color: AppDesignSystem.textInverse.withValues(
                              alpha: 0.8,
                            ),
                          ),
                    ),
                    SizedBox(height: AppDesignSystem.spacing(context, 4)),
                    Text(
                      'Marie Curie',
                      style: AppDesignSystem.textTheme(context).headlineLarge
                          ?.copyWith(
                            color: AppDesignSystem.textInverse,
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                    SizedBox(height: AppDesignSystem.spacing(context, 2)),
                    Text(
                      'Terminale S • Lycée Victor Hugo',
                      style: AppDesignSystem.textTheme(context).bodyLarge
                          ?.copyWith(
                            color: AppDesignSystem.textInverse.withValues(
                              alpha: 0.9,
                            ),
                          ),
                    ),
                  ],
                ),
              ),

              GestureDetector(
                onTap: () => Get.toNamed(Routes.NOTIFICATIONS),
                child: Container(
                  padding: AppDesignSystem.responsivePadding(context, all: 12),
                  decoration: BoxDecoration(
                    color: AppDesignSystem.textInverse.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(
                      AppDesignSystem.responsiveRadius(context, 12),
                    ),
                  ),
                  child: Stack(
                    children: [
                      Icon(
                        Icons.notifications_outlined,
                        color: AppDesignSystem.textInverse,
                        size: 24,
                      ),
                      Positioned(
                        right: 0,
                        top: 0,
                        child: Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: AppDesignSystem.error,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          Row(
            children: [
              Expanded(
                child: _buildInfoItem(
                  context,
                  Icons.calendar_month_rounded,
                  'Année scolaire',
                  '2024-2025',
                ),
              ),
              Container(
                width: 1,
                height: 32,
                color: AppDesignSystem.textInverse.withValues(alpha: 0.2),
              ),
              Expanded(
                child: _buildInfoItem(
                  context,
                  Icons.group_rounded,
                  'Classe',
                  'TS2',
                ),
              ),
              Container(
                width: 1,
                height: 32,
                color: AppDesignSystem.textInverse.withValues(alpha: 0.2),
              ),
              Expanded(
                child: _buildInfoItem(
                  context,
                  Icons.badge_rounded,
                  'Matricule',
                  'ET_0405',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem(
    BuildContext context,
    IconData icon,
    String label,
    String value,
  ) {
    return Column(
      children: [
        Icon(
          icon,
          color: AppDesignSystem.textInverse.withValues(alpha: 0.8),
          size: AppDesignSystem.responsiveSize(context, 20),
        ),
        SizedBox(height: AppDesignSystem.spacing(context, 6)),
        Text(
          value,
          style: AppDesignSystem.textTheme(context).labelLarge?.copyWith(
            color: AppDesignSystem.textInverse,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: AppDesignSystem.spacing(context, 2)),
        Text(
          label,
          style: AppDesignSystem.textTheme(context).bodySmall?.copyWith(
            color: AppDesignSystem.textInverse.withValues(alpha: 0.7),
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }
}
