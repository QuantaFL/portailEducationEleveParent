import 'package:flutter/material.dart';

import '../../core/data/models/student.dart';
import '../../core/data/models/user_model.dart';
import '../../themes/palette_system.dart';

/// Clean child info card showing essential child details
class ChildInfoCard extends StatelessWidget {
  final UserModel child;
  final Student studentData;

  const ChildInfoCard({
    Key? key,
    required this.child,
    required this.studentData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
              CircleAvatar(
                radius: 24,
                backgroundColor: AppDesignSystem.primary.withValues(alpha: 0.1),
                child: Text(
                  _getInitials(child.firstName, child.lastName),
                  style: TextStyle(
                    color: AppDesignSystem.primary,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
              ),
              SizedBox(width: AppDesignSystem.spacing(context, 12)),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${child.firstName ?? ''} ${child.lastName ?? ''}'.trim(),
                      style: AppDesignSystem.textTheme(context).titleMedium
                          ?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: AppDesignSystem.textPrimary,
                          ),
                    ),
                    if (studentData.matricule != null)
                      Text(
                        'Matricule: ${studentData.matricule}',
                        style: AppDesignSystem.textTheme(context).bodySmall
                            ?.copyWith(color: AppDesignSystem.textSecondary),
                      ),
                  ],
                ),
              ),
              Container(
                padding: AppDesignSystem.responsivePadding(
                  context,
                  horizontal: 8,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: _getGenderColor(child.gender).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      _getGenderIcon(child.gender),
                      size: 14,
                      color: _getGenderColor(child.gender),
                    ),
                    SizedBox(width: AppDesignSystem.spacing(context, 4)),
                    Text(
                      child.gender == 'M' ? 'Garçon' : 'Fille',
                      style: TextStyle(
                        color: _getGenderColor(child.gender),
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: AppDesignSystem.spacing(context, 16)),
          Row(
            children: [
              Expanded(
                child: _buildInfoItem(
                  context,
                  Icons.cake,
                  'Naissance',
                  _formatBirthday(child.birthday?.toIso8601String()),
                ),
              ),
              SizedBox(width: AppDesignSystem.spacing(context, 16)),
              Expanded(
                child: _buildInfoItem(
                  context,
                  Icons.email,
                  'Email',
                  child.email ?? 'Non renseigné',
                ),
              ),
            ],
          ),
          if (child.phone != null)
            Padding(
              padding: EdgeInsets.only(
                top: AppDesignSystem.spacing(context, 12),
              ),
              child: _buildInfoItem(
                context,
                Icons.phone,
                'Téléphone',
                child.phone!,
              ),
            ),
        ],
      ),
    );
  }

  /// Build info item with icon and text
  Widget _buildInfoItem(
    BuildContext context,
    IconData icon,
    String label,
    String value,
  ) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppDesignSystem.primary),
        SizedBox(width: AppDesignSystem.spacing(context, 6)),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  color: AppDesignSystem.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                value,
                style: TextStyle(
                  fontSize: 13,
                  color: AppDesignSystem.textPrimary,
                  fontWeight: FontWeight.w500,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Get initials from first and last name
  String _getInitials(String? firstName, String? lastName) {
    final first = firstName?.isNotEmpty == true
        ? firstName![0].toUpperCase()
        : '';
    final last = lastName?.isNotEmpty == true ? lastName![0].toUpperCase() : '';
    return '$first$last'.isEmpty ? '?' : '$first$last';
  }

  /// Get gender icon
  IconData _getGenderIcon(String? gender) {
    return gender == 'M' ? Icons.boy : Icons.girl;
  }

  /// Get gender color
  Color _getGenderColor(String? gender) {
    return gender == 'M' ? Colors.blue : Colors.pink;
  }

  /// Format birthday string
  String _formatBirthday(String? birthday) {
    if (birthday == null || birthday.isEmpty) return 'Non renseigné';

    try {
      final date = DateTime.parse(birthday);
      final months = [
        'Jan',
        'Fév',
        'Mar',
        'Avr',
        'Mai',
        'Jun',
        'Jul',
        'Aoû',
        'Sep',
        'Oct',
        'Nov',
        'Déc',
      ];
      return '${date.day} ${months[date.month - 1]} ${date.year}';
    } catch (e) {
      return birthday;
    }
  }
}
