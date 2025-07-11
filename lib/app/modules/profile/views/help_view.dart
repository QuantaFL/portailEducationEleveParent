import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HelpView extends StatelessWidget {
  const HelpView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              margin: const EdgeInsets.all(20),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.06),
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Get.back(),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.arrow_back_rounded,
                        color: Color(0xFF1E293B),
                        size: 20,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Text(
                    'Aide & Support',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                ],
              ),
            ),

            // Quick Actions
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  const Text(
                    'Besoin d\'aide ?',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Notre équipe est là pour vous aider',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white.withValues(alpha: 0.9),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _buildQuickActionButton(
                          'Chat en direct',
                          Icons.chat_rounded,
                          () => _showChatDialog(context),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildQuickActionButton(
                          'Appeler',
                          Icons.phone_rounded,
                          () => _showCallDialog(context),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Help Categories
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                children: [
                  _buildHelpCategory(
                    'Questions fréquentes',
                    'Trouvez des réponses aux questions les plus courantes',
                    Icons.quiz_rounded,
                    Colors.blue,
                    _faqItems,
                  ),
                  _buildHelpCategory(
                    'Tutoriels',
                    'Guides pas à pas pour utiliser l\'application',
                    Icons.school_rounded,
                    Colors.green,
                    _tutorialItems,
                  ),
                  _buildHelpCategory(
                    'Problèmes techniques',
                    'Résolvez les problèmes techniques courants',
                    Icons.build_rounded,
                    Colors.orange,
                    _technicalItems,
                  ),
                  _buildHelpCategory(
                    'Contact',
                    'Différentes façons de nous contacter',
                    Icons.contact_support_rounded,
                    Colors.purple,
                    _contactItems,
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActionButton(
    String label,
    IconData icon,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(icon, color: Colors.white, size: 24),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHelpCategory(
    String title,
    String subtitle,
    IconData icon,
    Color color,
    List<Map<String, String>> items,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: ExpansionTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1E293B),
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
        ),
        children: items
            .map(
              (item) => ListTile(
                title: Text(
                  item['title']!,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                subtitle: Text(
                  item['subtitle']!,
                  style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                ),
                onTap: () => _showHelpDetail(item['title']!, item['content']!),
              ),
            )
            .toList(),
      ),
    );
  }

  void _showChatDialog(BuildContext context) {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Chat en direct'),
        content: const Text(
          'Le chat en direct sera bientôt disponible.\nEn attendant, vous pouvez nous contacter par email.',
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('OK')),
        ],
      ),
    );
  }

  void _showCallDialog(BuildContext context) {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Support téléphonique'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('📞 01 23 45 67 89'),
            SizedBox(height: 8),
            Text('Horaires: Lun-Ven 9h-18h', style: TextStyle(fontSize: 12)),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('OK')),
        ],
      ),
    );
  }

  void _showHelpDetail(String title, String content) {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('OK')),
        ],
      ),
    );
  }

  static final List<Map<String, String>> _faqItems = [
    {
      'title': 'Comment consulter mes notes ?',
      'subtitle': 'Accès aux notes et bulletins',
      'content':
          'Vos notes sont disponibles dans l\'onglet "Bulletins récents" sur la page d\'accueil.',
    },
    {
      'title': 'Mot de passe oublié ?',
      'subtitle': 'Récupération de compte',
      'content':
          'Utilisez le lien "Mot de passe oublié" sur la page de connexion.',
    },
    {
      'title': 'Comment télécharger un bulletin ?',
      'subtitle': 'Téléchargement de documents',
      'content':
          'Cliquez sur l\'icône de téléchargement à côté de chaque bulletin.',
    },
  ];

  static final List<Map<String, String>> _tutorialItems = [
    {
      'title': 'Premier pas avec l\'app',
      'subtitle': 'Guide de démarrage',
      'content': 'Découvrez les fonctionnalités principales de l\'application.',
    },
    {
      'title': 'Navigation dans l\'interface',
      'subtitle': 'Comment naviguer',
      'content': 'Apprenez à utiliser les différents menus et sections.',
    },
  ];

  static final List<Map<String, String>> _technicalItems = [
    {
      'title': 'L\'app ne se lance pas',
      'subtitle': 'Problème de démarrage',
      'content': 'Redémarrez votre appareil et réessayez.',
    },
    {
      'title': 'Problème de connexion',
      'subtitle': 'Erreur de réseau',
      'content': 'Vérifiez votre connexion internet et réessayez.',
    },
  ];

  static final List<Map<String, String>> _contactItems = [
    {
      'title': 'Email support',
      'subtitle': 'support@portail-eleve.fr',
      'content': 'Envoyez-nous un email avec votre question.',
    },
    {
      'title': 'Téléphone',
      'subtitle': '01 23 45 67 89',
      'content': 'Appelez-nous aux heures d\'ouverture.',
    },
  ];
}
