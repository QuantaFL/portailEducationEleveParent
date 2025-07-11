import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../themes/palette_system.dart';
import '../controllers/parent_home_controller.dart';

class BulletinsSection extends GetView<ParentHomeController> {
  const BulletinsSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Bulletins disponibles',
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppDesignSystem.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          Obx(() {
            final bulletins = controller.selectedChildBulletins;

            if (bulletins.isEmpty) {
              return _buildEmptyBulletinsState();
            }

            return ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: bulletins.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final bulletin = bulletins[index];
                return _buildBulletinItem(bulletin);
              },
            );
          }),
        ],
      ),
    );
  }

  Widget _buildEmptyBulletinsState() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppDesignSystem.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(
            Icons.description_outlined,
            size: 40,
            color: AppDesignSystem.textSecondary,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              'Aucun bulletin disponible pour le moment',
              style: GoogleFonts.inter(
                fontSize: 14,
                color: AppDesignSystem.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBulletinItem(dynamic reportCard) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppDesignSystem.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppDesignSystem.primary.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          // PDF Icon
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppDesignSystem.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.picture_as_pdf,
              color: AppDesignSystem.primary,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),

          // Bulletin Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${reportCard.period} ${reportCard.academicYear}',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppDesignSystem.textPrimary,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Fichier PDF • Cliquez pour télécharger',
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    color: AppDesignSystem.textSecondary.withOpacity(0.8),
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),

          // Download Button
          Container(
            decoration: BoxDecoration(
              color: AppDesignSystem.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: IconButton(
              onPressed: () => controller.downloadBulletin(reportCard),
              icon: Icon(
                Icons.download,
                color: AppDesignSystem.primary,
                size: 20,
              ),
              tooltip: 'Télécharger le bulletin PDF',
            ),
          ),
        ],
      ),
    );
  }
}
