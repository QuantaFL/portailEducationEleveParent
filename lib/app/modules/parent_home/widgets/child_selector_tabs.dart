import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../themes/palette_system.dart';
import '../controllers/parent_home_controller.dart';

class ChildSelectorTabs extends GetView<ParentHomeController> {
  const ChildSelectorTabs({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.children.isEmpty) {
        return const SizedBox.shrink();
      }

      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Mes enfants',
              style: GoogleFonts.inter(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppDesignSystem.textPrimary,
              ),
            ),
            const SizedBox(height: 16),
            // Clean card-based selector
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Header with count
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppDesignSystem.primary.withOpacity(0.05),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.family_restroom,
                          color: AppDesignSystem.primary,
                          size: 20,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          '${controller.children.length} enfant${controller.children.length > 1 ? 's' : ''}',
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppDesignSystem.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Children list
                  ...controller.children.asMap().entries.map((entry) {
                    final index = entry.key;
                    final child = entry.value;
                    final isSelected =
                        controller.selectedChildIndex.value == index;
                    final isLast = index == controller.children.length - 1;

                    return _buildChildItem(child, index, isSelected, isLast)
                        .animate(delay: Duration(milliseconds: 100 * index))
                        .fadeIn(duration: 300.ms)
                        .slideX(begin: 0.3);
                  }).toList(),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildChildItem(
    dynamic child,
    int index,
    bool isSelected,
    bool isLast,
  ) {
    final childUser = child.user;
    final className = child.classId == 1 ? 'Terminale S' : '3ème B';

    return Container(
      decoration: BoxDecoration(
        border: !isLast
            ? Border(
                bottom: BorderSide(
                  color: Colors.grey.withOpacity(0.1),
                  width: 1,
                ),
              )
            : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => controller.selectChild(index),
          borderRadius: BorderRadius.circular(isLast ? 20 : 0),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: isSelected
                  ? AppDesignSystem.primary.withOpacity(0.05)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(isLast ? 20 : 0),
            ),
            child: Row(
              children: [
                // Avatar
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppDesignSystem.primary
                        : AppDesignSystem.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(24),
                    border: isSelected
                        ? Border.all(
                            color: AppDesignSystem.primary.withOpacity(0.3),
                            width: 3,
                          )
                        : null,
                  ),
                  child: Center(
                    child: Text(
                      childUser?.firstName?.substring(0, 1) ?? 'E',
                      style: GoogleFonts.inter(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: isSelected
                            ? Colors.white
                            : AppDesignSystem.primary,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                // Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        childUser?.firstName ?? 'Élève',
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: isSelected
                              ? AppDesignSystem.primary
                              : AppDesignSystem.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        className,
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          color: AppDesignSystem.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                // Selection indicator
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppDesignSystem.primary
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected
                          ? AppDesignSystem.primary
                          : Colors.grey.withOpacity(0.3),
                      width: 2,
                    ),
                  ),
                  child: isSelected
                      ? const Icon(Icons.check, size: 16, color: Colors.white)
                      : null,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
