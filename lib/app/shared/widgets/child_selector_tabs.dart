import 'package:flutter/material.dart';
import 'package:portail_eleve/app/core/data/models/student.dart';
import 'package:portail_eleve/app/themes/palette_system.dart';

/// Child selector component for parents to switch between their children
/// Uses the same design patterns as the rest of the app
class ChildSelectorTabs extends StatelessWidget {
  final List<Student> children;
  final int selectedIndex;
  final Function(int) onChildSelected;

  const ChildSelectorTabs({
    Key? key,
    required this.children,
    required this.selectedIndex,
    required this.onChildSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (children.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: AppDesignSystem.responsivePadding(
        context,
        horizontal: 16,
        vertical: 8,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Mes enfants',
            style: AppDesignSystem.textTheme(context).titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: AppDesignSystem.textPrimary,
            ),
          ),
          SizedBox(height: AppDesignSystem.spacing(context, 12)),
          SizedBox(
            height: 80,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: children.length,
              itemBuilder: (context, index) {
                final child = children[index];
                final isSelected = index == selectedIndex;

                return GestureDetector(
                  onTap: () => onChildSelected(index),
                  child: Container(
                    width: 120,
                    margin: EdgeInsets.only(
                      right: AppDesignSystem.spacing(context, 12),
                    ),
                    decoration: BoxDecoration(
                      gradient: isSelected
                          ? AppDesignSystem.primaryGradient
                          : LinearGradient(
                              colors: [
                                AppDesignSystem.surface,
                                AppDesignSystem.surface.withValues(alpha: 0.8),
                              ],
                            ),
                      borderRadius: BorderRadius.circular(
                        AppDesignSystem.responsiveRadius(context, 16),
                      ),
                      boxShadow: isSelected
                          ? AppDesignSystem.elevation(3)
                          : AppDesignSystem.elevation(1),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Child Avatar
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isSelected
                                  ? AppDesignSystem.textInverse
                                  : AppDesignSystem.primary,
                              width: 2,
                            ),
                          ),
                          child: CircleAvatar(
                            backgroundColor: isSelected
                                ? AppDesignSystem.textInverse
                                : AppDesignSystem.primaryLight,
                            child: Text(
                              _getChildInitials(child),
                              style: AppDesignSystem.textTheme(context)
                                  .bodyMedium
                                  ?.copyWith(
                                    color: isSelected
                                        ? AppDesignSystem.primary
                                        : AppDesignSystem.textInverse,
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                          ),
                        ),
                        SizedBox(height: AppDesignSystem.spacing(context, 8)),
                        // Child Name
                        Text(
                          _getChildName(child),
                          style: AppDesignSystem.textTheme(context).bodySmall
                              ?.copyWith(
                                color: isSelected
                                    ? AppDesignSystem.textInverse
                                    : AppDesignSystem.textPrimary,
                                fontWeight: isSelected
                                    ? FontWeight.w600
                                    : FontWeight.w500,
                              ),
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  String _getChildInitials(Student child) {
    final firstName = child.userModel?.firstName ?? '';
    final lastName = child.userModel?.lastName ?? '';
    return (firstName.isNotEmpty ? firstName[0] : '') +
        (lastName.isNotEmpty ? lastName[0] : '');
  }

  String _getChildName(Student child) {
    final firstName = child.userModel?.firstName ?? '';
    final lastName = child.userModel?.lastName ?? '';
    if (firstName.isNotEmpty && lastName.isNotEmpty) {
      return '$firstName ${lastName[0]}.';
    }
    return firstName.isNotEmpty ? firstName : 'Enfant';
  }
}
