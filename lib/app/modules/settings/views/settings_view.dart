import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';

import '../controllers/settings_controller.dart';

class SettingsView extends GetView<SettingsController> {
  const SettingsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Paramètres',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
      body: Obx(
        () => controller.isLoading.value
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    // Profile Section
                    _buildProfileSection()
                        .animate()
                        .fadeIn(duration: 600.ms)
                        .slideY(begin: 0.3),

                    const SizedBox(height: 24),

                    // Account Settings
                    _buildAccountSettings()
                        .animate()
                        .fadeIn(delay: 200.ms)
                        .slideY(begin: 0.3),

                    const SizedBox(height: 24),

                    // Notifications Settings
                    _buildNotificationSettings()
                        .animate()
                        .fadeIn(delay: 400.ms)
                        .slideY(begin: 0.3),

                    const SizedBox(height: 24),

                    // App Settings
                    _buildAppSettings()
                        .animate()
                        .fadeIn(delay: 600.ms)
                        .slideY(begin: 0.3),

                    const SizedBox(height: 24),

                    // Help & Support
                    _buildHelpSection()
                        .animate()
                        .fadeIn(delay: 800.ms)
                        .slideY(begin: 0.3),

                    const SizedBox(height: 24),

                    // Logout Button
                    _buildLogoutButton()
                        .animate()
                        .fadeIn(delay: 1000.ms)
                        .slideY(begin: 0.3),

                    const SizedBox(height: 40),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildProfileSection() {
    final profile = controller.userProfile;
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Profile Header
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.white,
                  child: Text(
                    profile['name']?.split(' ').map((e) => e[0]).join() ?? 'JD',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF6366F1),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        profile['name'] ?? 'John Doe',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        profile['class'] ?? 'Terminale S',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white.withOpacity(0.9),
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: controller.editProfile,
                  icon: const Icon(Icons.edit, color: Colors.white),
                ),
              ],
            ),
          ),

          // Profile Info
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                _buildProfileInfoRow(
                  'Email',
                  profile['email'] ?? 'john.doe@example.com',
                ),
                _buildProfileInfoRow(
                  'ID Étudiant',
                  profile['studentId'] ?? '2024001',
                ),
                _buildProfileInfoRow(
                  'Téléphone',
                  profile['phone'] ?? '+33 6 12 34 56 78',
                ),
                _buildProfileInfoRow(
                  'Date de naissance',
                  profile['birthDate'] ?? '15/03/2007',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 14, color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAccountSettings() {
    return _buildSettingsGroup('Compte', [
      _buildSettingsItem(
        Icons.person,
        'Informations personnelles',
        'Modifier vos informations',
        controller.editProfile,
      ),
      _buildSettingsItem(
        Icons.lock,
        'Changer le mot de passe',
        'Sécurité du compte',
        controller.changePassword,
      ),
    ]);
  }

  Widget _buildNotificationSettings() {
    return _buildSettingsGroup('Notifications', [
      _buildSwitchItem(
        Icons.notifications,
        'Notifications push',
        'Recevoir des notifications',
        controller.pushNotifications,
        controller.togglePushNotifications,
      ),
      _buildSwitchItem(
        Icons.email,
        'Notifications email',
        'Recevoir par email',
        controller.emailNotifications,
        controller.toggleEmailNotifications,
      ),
    ]);
  }

  Widget _buildAppSettings() {
    return _buildSettingsGroup('Application', [
      _buildSwitchItem(
        Icons.dark_mode,
        'Mode sombre',
        'Thème sombre',
        controller.darkMode,
        controller.toggleDarkMode,
      ),
      _buildSwitchItem(
        Icons.fingerprint,
        'Authentification biométrique',
        'Connexion par empreinte',
        controller.biometricLogin,
        controller.toggleBiometricLogin,
      ),
      _buildLanguageItem(),
      _buildSettingsItem(
        Icons.cleaning_services,
        'Vider le cache',
        'Libérer l\'espace de stockage',
        controller.clearCache,
      ),
    ]);
  }

  Widget _buildHelpSection() {
    return _buildSettingsGroup('Aide & Support', [
      _buildSettingsItem(
        Icons.help,
        'Centre d\'aide',
        'FAQ et support',
        controller.showHelp,
      ),
      _buildSettingsItem(
        Icons.info,
        'À propos',
        'Version de l\'application',
        controller.showAbout,
      ),
    ]);
  }

  Widget _buildSettingsGroup(String title, List<Widget> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 12),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.grey[700],
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(children: items),
        ),
      ],
    );
  }

  Widget _buildSettingsItem(
    IconData icon,
    String title,
    String subtitle,
    VoidCallback onTap, {
    bool isDestructive = false,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: (isDestructive ? Colors.red : Colors.blue).withOpacity(
                    0.1,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  color: isDestructive ? Colors.red : Colors.blue,
                  size: 20,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: isDestructive ? Colors.red : Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right, color: Colors.grey[400]),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSwitchItem(
    IconData icon,
    String title,
    String subtitle,
    RxBool value,
    Function(bool) onChanged,
  ) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: Colors.blue, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
          Obx(
            () => Switch(
              value: value.value,
              onChanged: onChanged,
              activeColor: const Color(0xFF6366F1),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageItem() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.language, color: Colors.blue, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Langue',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 2),
                Obx(
                  () => Text(
                    controller.language.value,
                    style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                  ),
                ),
              ],
            ),
          ),
          PopupMenuButton<String>(
            onSelected: controller.changeLanguage,
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'français', child: Text('Français')),
              const PopupMenuItem(value: 'english', child: Text('English')),
              const PopupMenuItem(value: 'العربية', child: Text('العربية')),
            ],
            child: Icon(Icons.arrow_drop_down, color: Colors.grey[400]),
          ),
        ],
      ),
    );
  }

  Widget _buildLogoutButton() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: controller.logout,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.logout, color: Colors.red, size: 20),
                ),
                const SizedBox(width: 16),
                const Text(
                  'Déconnexion',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.red,
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
