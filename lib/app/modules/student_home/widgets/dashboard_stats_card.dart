import 'package:flutter/material.dart';

class DashboardStatsCard extends StatelessWidget {
  final String title;
  final String value;
  final String subtitle;
  final IconData icon;
  final LinearGradient gradient;
  final String? trend;
  final bool? trendPositive;

  const DashboardStatsCard({
    Key? key,
    required this.title,
    required this.value,
    required this.subtitle,
    required this.icon,
    required this.gradient,
    this.trend,
    this.trendPositive,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 20,
            offset: const Offset(0, 8),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    gradient.colors.first.withValues(alpha: 0.05),
                    gradient.colors.last.withValues(alpha: 0.02),
                  ],
                ),
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        gradient: gradient,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: gradient.colors.first.withValues(alpha: 0.3),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Icon(icon, color: Colors.white, size: 24),
                    ),
                    if (trend != null)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: (trendPositive ?? true)
                              ? Colors.green.shade50
                              : Colors.red.shade50,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: (trendPositive ?? true)
                                ? Colors.green.shade200
                                : Colors.red.shade200,
                            width: 1,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              trendPositive ?? true
                                  ? Icons.trending_up
                                  : Icons.trending_down,
                              size: 14,
                              color: (trendPositive ?? true)
                                  ? Colors.green.shade600
                                  : Colors.red.shade600,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              trend!,
                              style: TextStyle(
                                color: (trendPositive ?? true)
                                    ? Colors.green.shade600
                                    : Colors.red.shade600,
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),

                const SizedBox(height: 16),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          value,
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF1A1D29),
                            height: 1,
                          ),
                        ),
                        if (subtitle.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(left: 4, bottom: 2),
                            child: Text(
                              subtitle,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey.shade500,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey.shade700,
                        letterSpacing: 0.2,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          Positioned(
            right: -20,
            bottom: -20,
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: gradient.colors.first.withValues(alpha: 0.05),
              ),
            ),
          ),
          Positioned(
            right: -10,
            bottom: -10,
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: gradient.colors.last.withValues(alpha: 0.08),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
