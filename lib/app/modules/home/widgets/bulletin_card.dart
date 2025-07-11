import 'package:flutter/material.dart';

class BulletinCard extends StatelessWidget {
  final Map<String, dynamic> bulletin;
  final VoidCallback? onTap;
  final VoidCallback? onDownload;

  const BulletinCard({
    Key? key,
    required this.bulletin,
    this.onTap,
    this.onDownload,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade100, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Minimal Icon
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: const Color(0xFF6366F1).withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.description_rounded,
                    color: Color(0xFF6366F1),
                    size: 20,
                  ),
                ),

                const SizedBox(width: 12),

                // Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title
                      Text(
                        bulletin['title'] ?? 'Bulletin',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1E293B),
                        ),
                      ),
                      const SizedBox(height: 4),

                      // Details row
                      Row(
                        children: [
                          Text(
                            bulletin['periode'] ?? '2023-2024',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: Colors.grey.shade600,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            width: 3,
                            height: 3,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade400,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            _formatDate(bulletin['date']),
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),

                      // Status and average
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: _getStatusColor().withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              bulletin['status'] ?? 'Disponible',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w500,
                                color: _getStatusColor(),
                              ),
                            ),
                          ),
                          if (bulletin['moyenne'] != null) ...[
                            const SizedBox(width: 8),
                            Text(
                              'Moy: ${bulletin['moyenne']}/20',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey.shade700,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),

                // Actions
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: IconButton(
                        onPressed: onTap,
                        icon: Icon(
                          Icons.visibility_rounded,
                          size: 16,
                          color: Colors.grey.shade600,
                        ),
                        padding: EdgeInsets.zero,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: const Color(0xFF6366F1).withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: IconButton(
                        onPressed: onDownload,
                        icon: const Icon(
                          Icons.download_rounded,
                          size: 16,
                          color: Color(0xFF6366F1),
                        ),
                        padding: EdgeInsets.zero,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _getStatusColor() {
    final status = bulletin['status']?.toString().toLowerCase() ?? '';
    switch (status) {
      case 'consulté':
        return const Color(0xFF10B981);
      case 'nouveau':
        return const Color(0xFFF59E0B);
      case 'téléchargé':
        return const Color(0xFF3B82F6);
      default:
        return Colors.grey.shade600;
    }
  }

  String _formatDate(dynamic date) {
    if (date is DateTime) {
      return '${date.day}/${date.month}/${date.year}';
    } else if (date is String) {
      try {
        final parsedDate = DateTime.parse(date);
        return '${parsedDate.day}/${parsedDate.month}/${parsedDate.year}';
      } catch (e) {
        return date;
      }
    }
    return '';
  }
}
