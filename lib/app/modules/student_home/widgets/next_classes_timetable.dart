import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:portail_eleve/app/core/data/models/next_class.dart';

import '../../../themes/palette_system.dart';

/// A beautiful, modern timetable widget that displays upcoming classes
/// with glassmorphism design, animations, and time-based visual indicators.
class NextClassesTimetable extends StatefulWidget {
  final Future<List<NextClass>> Function() getNextClasses;

  const NextClassesTimetable({Key? key, required this.getNextClasses})
    : super(key: key);

  @override
  State<NextClassesTimetable> createState() => _NextClassesTimetableState();
}

class _NextClassesTimetableState extends State<NextClassesTimetable>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutQuad),
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Curves.easeOutQuad,
          ),
        );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.white.withOpacity(0.1),
                    Colors.white.withOpacity(0.05),
                  ],
                ),
                border: Border.all(
                  color: Colors.white.withOpacity(0.2),
                  width: 1,
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.white.withOpacity(0.15),
                        Colors.white.withOpacity(0.05),
                      ],
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHeader(),
                      const SizedBox(height: 20),
                      Expanded(
                        child: FutureBuilder<List<NextClass>>(
                          future: widget.getNextClasses(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return _buildLoadingState();
                            }

                            if (snapshot.hasError) {
                              return _buildErrorState();
                            }

                            final nextClasses = snapshot.data ?? [];

                            if (nextClasses.isEmpty) {
                              return _buildEmptyState();
                            }

                            return _buildClassesList(nextClasses);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF6366F1).withOpacity(0.3),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: const Icon(
            Icons.schedule_rounded,
            color: Colors.white,
            size: 24,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Prochains Cours',
                style: GoogleFonts.inter(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppDesignSystem.textPrimary,
                ),
              ),
              Text(
                'Vos 3 prochaines classes',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppDesignSystem.textSecondary,
                ),
              ),
            ],
          ),
        ),
        _buildTimeIndicator(),
      ],
    );
  }

  Widget _buildTimeIndicator() {
    final now = DateTime.now();
    final timeString =
        '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.3), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: const Color(0xFF10B981),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF10B981).withOpacity(0.4),
                  blurRadius: 4,
                  spreadRadius: 1,
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text(
            timeString,
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppDesignSystem.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildClassesList(List<NextClass> classes) {
    return Column(
      children: classes.asMap().entries.map((entry) {
        final index = entry.key;
        final nextClass = entry.value;

        return TweenAnimationBuilder<double>(
          duration: Duration(milliseconds: 400 + (index * 100)),
          tween: Tween(begin: 0.0, end: 1.0),
          curve: Curves.easeOutBack,
          builder: (context, value, child) {
            return Container(
              margin: EdgeInsets.only(
                bottom: index < classes.length - 1 ? 12 : 0,
              ),
              child: Transform.scale(
                scale: value,
                child: _buildClassCard(nextClass, index),
              ),
            );
          },
        );
      }).toList(),
    );
  }

  Widget _buildClassCard(NextClass nextClass, int index) {
    final isFirst = index == 0;
    final cardColor = nextClass.colorValue;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [cardColor.withOpacity(0.15), cardColor.withOpacity(0.08)],
        ),
        border: Border.all(
          color: isFirst
              ? cardColor.withOpacity(0.4)
              : cardColor.withOpacity(0.2),
          width: isFirst ? 2 : 1,
        ),
        boxShadow: [
          if (isFirst)
            BoxShadow(
              color: cardColor.withOpacity(0.2),
              blurRadius: 16,
              offset: const Offset(0, 8),
            ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () {
            // Add haptic feedback and potential navigation
            _showClassDetails(nextClass);
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                _buildTimeChip(nextClass.time, cardColor, isFirst),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        nextClass.subject,
                        style: GoogleFonts.inter(
                          fontSize: isFirst ? 18 : 16,
                          fontWeight: isFirst
                              ? FontWeight.bold
                              : FontWeight.w600,
                          color: AppDesignSystem.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        nextClass.teacher,
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: AppDesignSystem.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _getTimeUntilClass(nextClass.time),
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: AppDesignSystem.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                if (isFirst) _buildNextIndicator(cardColor),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTimeChip(String time, Color color, bool isFirst) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            color.withOpacity(isFirst ? 0.9 : 0.7),
            color.withOpacity(isFirst ? 0.7 : 0.5),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Text(
        time,
        style: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildNextIndicator(Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        'Suivant',
        style: GoogleFonts.inter(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return Column(
      children: List.generate(3, (index) {
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          height: 72,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              colors: [Colors.grey.shade200, Colors.grey.shade100],
            ),
          ),
          child: const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF6366F1)),
              strokeWidth: 2,
            ),
          ),
        );
      }),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.event_available_rounded,
              size: 48,
              color: Colors.grey.shade400,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Aucun cours prévu',
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppDesignSystem.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Profitez de votre temps libre !',
            style: GoogleFonts.inter(fontSize: 14, color: Colors.grey.shade500),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline_rounded,
            size: 48,
            color: Colors.red.shade400,
          ),
          const SizedBox(height: 16),
          Text(
            'Erreur de chargement',
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppDesignSystem.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Impossible de charger l\'emploi du temps',
            style: GoogleFonts.inter(fontSize: 14, color: Colors.grey.shade500),
          ),
        ],
      ),
    );
  }

  String _getTimeUntilClass(String classTime) {
    try {
      final now = DateTime.now();
      final timeParts = classTime.split(':');
      final classHour = int.parse(timeParts[0]);
      final classMinute = int.parse(timeParts[1]);

      final classDateTime = DateTime(
        now.year,
        now.month,
        now.day,
        classHour,
        classMinute,
      );

      if (classDateTime.isBefore(now)) {
        // If class time has passed today, assume it's tomorrow
        final tomorrowClass = classDateTime.add(const Duration(days: 1));
        final difference = tomorrowClass.difference(now);
        return _formatDuration(difference);
      } else {
        final difference = classDateTime.difference(now);
        return _formatDuration(difference);
      }
    } catch (e) {
      return 'Horaire non disponible';
    }
  }

  String _formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes % 60;

    if (hours > 24) {
      final days = (hours / 24).floor();
      return 'Dans $days jour${days > 1 ? 's' : ''}';
    } else if (hours > 0) {
      return 'Dans ${hours}h${minutes > 0 ? ' ${minutes}min' : ''}';
    } else {
      return 'Dans ${minutes}min';
    }
  }

  void _showClassDetails(NextClass nextClass) {
    HapticFeedback.lightImpact();

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => _buildClassDetailsSheet(nextClass),
    );
  }

  Widget _buildClassDetailsSheet(NextClass nextClass) {
    final cardColor = nextClass.colorValue;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Handle bar
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Header with subject and time
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          cardColor.withOpacity(0.9),
                          cardColor.withOpacity(0.7),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: cardColor.withOpacity(0.3),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.school_rounded,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          nextClass.subject,
                          style: GoogleFonts.inter(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: AppDesignSystem.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          nextClass.teacher,
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: cardColor,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Cours à ${nextClass.time}',
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: AppDesignSystem.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Teacher info card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      cardColor.withOpacity(0.1),
                      cardColor.withOpacity(0.05),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: cardColor.withOpacity(0.2),
                    width: 1,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.person_rounded, color: cardColor, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          'Professeur',
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppDesignSystem.textSecondary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      nextClass.teacher,
                      style: GoogleFonts.inter(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: cardColor,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Time until class card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      cardColor.withOpacity(0.1),
                      cardColor.withOpacity(0.05),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: cardColor.withOpacity(0.2),
                    width: 1,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.access_time_rounded,
                          color: cardColor,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Temps restant',
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppDesignSystem.textSecondary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _getTimeUntilClass(nextClass.time),
                      style: GoogleFonts.inter(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: cardColor,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Close button only
              Container(
                width: double.infinity,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () => Navigator.pop(context),
                    child: Center(
                      child: Text(
                        'Fermer',
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
