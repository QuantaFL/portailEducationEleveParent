import 'package:flutter/material.dart';
import 'package:portail_eleve/app/themes/palette_system.dart';

/// Generic dashboard layout that can be used by both students and parents
/// Provides consistent spacing, scrolling, and layout patterns
class DashboardLayout extends StatelessWidget {
  final Widget header;
  final Widget? selector;
  final List<Widget> cards;
  final Future<void> Function()? onRefresh;
  final bool isLoading;

  const DashboardLayout({
    Key? key,
    required this.header,
    this.selector,
    required this.cards,
    this.onRefresh,
    this.isLoading = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: RefreshIndicator(
        onRefresh: onRefresh ?? () async {},
        color: AppDesignSystem.primary,
        backgroundColor: AppDesignSystem.surface,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: AppDesignSystem.responsivePadding(context, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Section
                Padding(
                  padding: AppDesignSystem.responsivePadding(
                    context,
                    horizontal: 16,
                  ),
                  child: header,
                ),

                SizedBox(height: AppDesignSystem.spacing(context, 16)),

                // Optional Selector (e.g., child selector for parents)
                if (selector != null) ...[
                  selector!,
                  SizedBox(height: AppDesignSystem.spacing(context, 16)),
                ],

                // Loading State
                if (isLoading)
                  Center(
                    child: Padding(
                      padding: AppDesignSystem.responsivePadding(
                        context,
                        all: 32,
                      ),
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                          AppDesignSystem.primary,
                        ),
                      ),
                    ),
                  )
                else
                  // Dashboard Cards
                  Padding(
                    padding: AppDesignSystem.responsivePadding(
                      context,
                      horizontal: 16,
                    ),
                    child: Column(
                      children: cards
                          .map(
                            (card) => Padding(
                              padding: EdgeInsets.only(
                                bottom: AppDesignSystem.spacing(context, 16),
                              ),
                              child: card,
                            ),
                          )
                          .toList(),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
