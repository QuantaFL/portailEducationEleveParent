import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:portail_eleve/app/modules/auth/controllers/change_password_controller.dart';
import 'package:portail_eleve/app/themes/palette_system.dart';

class ChangePasswordView extends GetView<ChangePasswordController> {
  const ChangePasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Column(
                    children: [
                      _buildAnimatedHeader(context),
                      Expanded(child: _buildChangePasswordForm(context)),
                      _buildFooter(context),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildAnimatedHeader(BuildContext context) {
    return Container(
      padding: AppDesignSystem.responsivePadding(context, horizontal: 24, vertical: 32),
      child: Column(
        children: [
          Container(
            width: AppDesignSystem.responsiveSize(context, 160),
            height: AppDesignSystem.responsiveSize(context, 160),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [BoxShadow(color: AppDesignSystem.primary.withOpacity(0.1), blurRadius: 30, offset: const Offset(0, 15))],
            ),
            child: Image.asset('assets/icons/lock.png', scale: 4.0),
          ).animate().scale(duration: 1200.ms, curve: Curves.elasticOut).fadeIn(duration: 800.ms),
          SizedBox(height: AppDesignSystem.spacing(context, 32)),
          Text(
            'Nouveau mot de passe',
            style: AppDesignSystem.textTheme(context).displayLarge?.copyWith(
                  fontWeight: FontWeight.w900,
                  color: AppDesignSystem.textPrimary,
                  letterSpacing: -1.0,
                ),
          ).animate().fadeIn(duration: 800.ms, delay: 400.ms).slideY(begin: 0.3, end: 0),
          SizedBox(height: AppDesignSystem.spacing(context, 12)),
          Text(
            'Veuillez créer un nouveau mot de passe sécurisé.',
            style: AppDesignSystem.textTheme(context).bodyLarge?.copyWith(
                  color: AppDesignSystem.textSecondary,
                  fontWeight: FontWeight.w400,
                  height: 1.5,
                ),
            textAlign: TextAlign.center,
          ).animate().fadeIn(duration: 800.ms, delay: 600.ms).slideY(begin: 0.2, end: 0),
        ],
      ),
    );
  }

  Widget _buildChangePasswordForm(BuildContext context) {
    return Container(
      margin: AppDesignSystem.responsivePadding(context, horizontal: 24),
      padding: AppDesignSystem.responsivePadding(context, horizontal: 28, vertical: 28),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppDesignSystem.responsiveRadius(context, 24)),
        boxShadow: [
          BoxShadow(color: AppDesignSystem.primary.withOpacity(0.08), blurRadius: 30, offset: const Offset(0, 15)),
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 5)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildPasswordField(context, controller.oldPasswordController, controller.oldPasswordFocusNode, 'Ancien mot de passe', controller.isOldPasswordObscured, controller.isOldPasswordValid, false),
          SizedBox(height: AppDesignSystem.spacing(context, 20)),
          _buildPasswordField(context, controller.newPasswordController, controller.newPasswordFocusNode, 'Nouveau mot de passe', controller.isNewPasswordObscured, controller.isNewPasswordValid, false),
          SizedBox(height: AppDesignSystem.spacing(context, 20)),
          _buildPasswordField(context, controller.confirmPasswordController, controller.confirmPasswordFocusNode, 'Confirmer le mot de passe', controller.isConfirmPasswordObscured, controller.isConfirmPasswordValid, true),
          SizedBox(height: AppDesignSystem.spacing(context, 28)),
          _buildChangePasswordButton(context),
        ],
      ),
    ).animate().fadeIn(duration: 800.ms, delay: 800.ms).slideY(begin: 0.3, end: 0);
  }

  Widget _buildPasswordField(BuildContext context, TextEditingController textController, FocusNode focusNode, String label, RxBool isObscured, RxBool isValid, bool isConfirmField) {
    return GetBuilder<ChangePasswordController>(
      builder: (_) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: AppDesignSystem.textTheme(context).labelLarge?.copyWith(fontWeight: FontWeight.w600, color: AppDesignSystem.textPrimary)),
          SizedBox(height: AppDesignSystem.spacing(context, 8)),
          Container(
            decoration: AppDesignSystem.inputDecoration(context, focused: focusNode.hasFocus),
            child: TextFormField(
              controller: textController,
              focusNode: focusNode,
              obscureText: isObscured.value,
              decoration: InputDecoration(
                hintText: '••••••••',
                hintStyle: AppDesignSystem.textTheme(context).bodyMedium?.copyWith(color: AppDesignSystem.textTertiary),
                prefixIcon: Container(
                  margin: EdgeInsets.all(AppDesignSystem.spacing(context, 12)),
                  padding: EdgeInsets.all(AppDesignSystem.spacing(context, 8)),
                  decoration: BoxDecoration(color: AppDesignSystem.primarySoft, borderRadius: BorderRadius.circular(AppDesignSystem.responsiveRadius(context, 8))),
                  child: Icon(Icons.lock_outline, color: AppDesignSystem.primary, size: AppDesignSystem.responsiveSize(context, 20)),
                ),
                suffixIcon: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Obx(() => isValid.value ? Icon(Icons.check_circle, color: AppDesignSystem.success, size: AppDesignSystem.responsiveSize(context, 20)) : const SizedBox.shrink()),
                    IconButton(
                      onPressed: () => isObscured.value = !isObscured.value,
                      icon: Icon(isObscured.value ? Icons.visibility_off : Icons.visibility, color: AppDesignSystem.textSecondary, size: AppDesignSystem.responsiveSize(context, 20)),
                    ),
                  ],
                ),
                border: InputBorder.none,
                contentPadding: AppDesignSystem.responsivePadding(context, horizontal: 16, vertical: 16),
                errorText: isConfirmField && controller.passwordsDoNotMatch.value ? 'Les mots de passe ne correspondent pas' : null,
              ),
              style: AppDesignSystem.textTheme(context).bodyMedium,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChangePasswordButton(BuildContext context) {
    return Obx(() => GestureDetector(
          onTap: controller.isFormValid.value && !controller.isLoading.value
              ? () {
                  HapticFeedback.lightImpact();
                  controller.changePassword();
                }
              : null,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            padding: AppDesignSystem.responsivePadding(context, vertical: 24),
            decoration: BoxDecoration(
              color: controller.isFormValid.value ? AppDesignSystem.primary : AppDesignSystem.surfaceVariant,
              borderRadius: BorderRadius.circular(AppDesignSystem.responsiveRadius(context, 20)),
              boxShadow: controller.isFormValid.value
                  ? [BoxShadow(color: AppDesignSystem.primary.withOpacity(0.4), blurRadius: 20, offset: const Offset(0, 10)), BoxShadow(color: AppDesignSystem.primary.withOpacity(0.2), blurRadius: 40, offset: const Offset(0, 20))]
                  : [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4, offset: const Offset(0, 2))],
            ),
            child: controller.isLoading.value
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: AppDesignSystem.responsiveSize(context, 24),
                        width: AppDesignSystem.responsiveSize(context, 24),
                        child: CircularProgressIndicator(strokeWidth: 2.5, valueColor: AlwaysStoppedAnimation<Color>(AppDesignSystem.textInverse)),
                      ),
                      SizedBox(width: AppDesignSystem.spacing(context, 16)),
                      Text('Changement en cours...', style: AppDesignSystem.textTheme(context).titleMedium?.copyWith(color: AppDesignSystem.textInverse, fontWeight: FontWeight.w600)),
                    ],
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.lock_reset, color: controller.isFormValid.value ? AppDesignSystem.textInverse : AppDesignSystem.textTertiary, size: AppDesignSystem.responsiveSize(context, 24)),
                      SizedBox(width: AppDesignSystem.spacing(context, 12)),
                      Text('Changer le mot de passe', style: AppDesignSystem.textTheme(context).titleMedium?.copyWith(color: controller.isFormValid.value ? AppDesignSystem.textInverse : AppDesignSystem.textTertiary, fontWeight: FontWeight.w700)),
                    ],
                  ),
          ),
        ));
  }

  Widget _buildFooter(BuildContext context) {
    return Padding(
      padding: AppDesignSystem.responsivePadding(context, horizontal: 24, vertical: 16),
      child: Text(
        '© 2025 Espace Scolaire - Tous droits réservés',
        style: AppDesignSystem.textTheme(context).bodySmall?.copyWith(color: AppDesignSystem.textTertiary),
        textAlign: TextAlign.center,
      ).animate().fadeIn(duration: 600.ms, delay: 1000.ms),
    );
  }
}