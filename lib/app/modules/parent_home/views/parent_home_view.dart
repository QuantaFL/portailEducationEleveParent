import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../themes/palette_system.dart';
import '../controllers/parent_home_controller.dart';
import '../widgets/bulletins_section.dart';
import '../widgets/child_dashboard_content.dart';
import '../widgets/child_selector_tabs.dart';
import '../widgets/notifications_section.dart';
import '../widgets/parent_bottom_nav_bar.dart';
import '../widgets/parent_profile_header.dart';
import '../widgets/parent_profile_section.dart';

class ParentHomeView extends GetView<ParentHomeController> {
  const ParentHomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppDesignSystem.surface,
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppDesignSystem.surfaceGradient,
        ),
        child: Obx(
          () => IndexedStack(
            index: controller.currentIndex.value,
            children: [
              _buildParentDashboard(),
              const NotificationsSection(),
              const ParentProfileSection(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const ParentBottomNavBar(),
    );
  }

  Widget _buildParentDashboard() {
    return SafeArea(
      child: RefreshIndicator(
        onRefresh: controller.refreshData,
        color: AppDesignSystem.primary,
        backgroundColor: Colors.white,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const ParentProfileHeader(),

              const SizedBox(height: 24),

              const ChildSelectorTabs(),

              const SizedBox(height: 24),

              const ChildDashboardContent(),

              const SizedBox(height: 20),

              const BulletinsSection(),

              const SizedBox(height: 20),

              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }
}
