import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../../../themes/palette_system.dart';
import '../controllers/auth_controller.dart';

class LoginView extends GetView<AuthController> {
  const LoginView({Key? key}) : super(key: key);

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

                      Expanded(child: _buildLoginForm(context)),

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
      padding: AppDesignSystem.responsivePadding(
        context,
        horizontal: 24,
        vertical: 32,
      ),
      child: Column(
        children: [
          Container(
                width: AppDesignSystem.responsiveSize(context, 160),
                height: AppDesignSystem.responsiveSize(context, 160),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppDesignSystem.primary.withOpacity(0.1),
                      blurRadius: 30,
                      offset: const Offset(0, 15),
                    ),
                  ],
                ),
                child: Lottie.asset(
                  'assets/animations/student_background.json',
                  fit: BoxFit.cover,
                ),
              )
              .animate()
              .scale(duration: 1200.ms, curve: Curves.elasticOut)
              .fadeIn(duration: 800.ms),

          SizedBox(height: AppDesignSystem.spacing(context, 32)),

          Text(
                'Espace Scolaire',
                style: AppDesignSystem.textTheme(context).displayLarge
                    ?.copyWith(
                      fontWeight: FontWeight.w900,
                      color: AppDesignSystem.textPrimary,
                      letterSpacing: -1.0,
                    ),
              )
              .animate()
              .fadeIn(duration: 800.ms, delay: 400.ms)
              .slideY(begin: 0.3, end: 0),

          SizedBox(height: AppDesignSystem.spacing(context, 12)),

          Text(
                'Accédez à vos bulletins scolaires\nen toute sécurité',
                style: AppDesignSystem.textTheme(context).bodyLarge?.copyWith(
                  color: AppDesignSystem.textSecondary,
                  fontWeight: FontWeight.w400,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              )
              .animate()
              .fadeIn(duration: 800.ms, delay: 600.ms)
              .slideY(begin: 0.2, end: 0),
        ],
      ),
    );
  }

  Widget _buildLoginForm(BuildContext context) {
    return Container(
          margin: AppDesignSystem.responsivePadding(context, horizontal: 24),
          padding: AppDesignSystem.responsivePadding(
            context,
            horizontal: 28,
            vertical: 28,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(
              AppDesignSystem.responsiveRadius(context, 24),
            ),
            boxShadow: [
              BoxShadow(
                color: AppDesignSystem.primary.withOpacity(0.08),
                blurRadius: 30,
                offset: const Offset(0, 15),
              ),
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                    'Bienvenue',
                    style: AppDesignSystem.textTheme(context).headlineLarge
                        ?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: AppDesignSystem.textPrimary,
                          letterSpacing: -0.5,
                        ),
                    textAlign: TextAlign.center,
                  )
                  .animate()
                  .fadeIn(duration: 600.ms, delay: 600.ms)
                  .slideX(begin: -0.3, end: 0),

              SizedBox(height: AppDesignSystem.spacing(context, 6)),

              Text(
                    'Connectez-vous à votre espace personnel',
                    style: AppDesignSystem.textTheme(context).bodyLarge
                        ?.copyWith(
                          color: AppDesignSystem.textSecondary,
                          fontWeight: FontWeight.w400,
                        ),
                    textAlign: TextAlign.center,
                  )
                  .animate()
                  .fadeIn(duration: 600.ms, delay: 700.ms)
                  .slideX(begin: 0.3, end: 0),

              SizedBox(
                height: AppDesignSystem.spacing(context, 28),
              ), // Reduced from 40
              // Email Field
              _buildEmailField(context)
                  .animate()
                  .fadeIn(duration: 600.ms, delay: 800.ms)
                  .slideY(begin: 0.2, end: 0),

              SizedBox(
                height: AppDesignSystem.spacing(context, 20),
              ), // Reduced from 24
              _buildPasswordField(context)
                  .animate()
                  .fadeIn(duration: 600.ms, delay: 900.ms)
                  .slideY(begin: 0.2, end: 0),

              SizedBox(
                height: AppDesignSystem.spacing(context, 28),
              ), // Reduced from
              _buildLoginButton(context)
                  .animate()
                  .fadeIn(duration: 600.ms, delay: 1000.ms)
                  .slideY(begin: 0.2, end: 0),

              SizedBox(
                height: AppDesignSystem.spacing(context, 18),
              ), // Reduced from 24
              _buildForgotPasswordButton(context)
                  .animate()
                  .fadeIn(duration: 600.ms, delay: 1100.ms)
                  .slideY(begin: 0.2, end: 0),
            ],
          ),
        )
        .animate()
        .fadeIn(duration: 800.ms, delay: 800.ms)
        .slideY(begin: 0.3, end: 0);
  }

  Widget _buildEmailField(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Adresse email',
          style: AppDesignSystem.textTheme(context).labelLarge?.copyWith(
            fontWeight: FontWeight.w600,
            color: AppDesignSystem.textPrimary,
          ),
        ),
        SizedBox(height: AppDesignSystem.spacing(context, 8)),
        Obx(
          () => Container(
            decoration: AppDesignSystem.inputDecoration(
              context,
              focused: controller.isEmailFocused.value,
            ),
            child: TextFormField(
              controller: controller.emailController,
              focusNode: controller.emailFocusNode,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              onFieldSubmitted: (_) =>
                  controller.passwordFocusNode.requestFocus(),
              decoration: InputDecoration(
                hintText: 'votre.email@exemple.com',
                hintStyle: AppDesignSystem.textTheme(
                  context,
                ).bodyMedium?.copyWith(color: AppDesignSystem.textTertiary),
                prefixIcon: Container(
                  margin: EdgeInsets.all(AppDesignSystem.spacing(context, 12)),
                  padding: EdgeInsets.all(AppDesignSystem.spacing(context, 8)),
                  decoration: BoxDecoration(
                    color: AppDesignSystem.primarySoft,
                    borderRadius: BorderRadius.circular(
                      AppDesignSystem.responsiveRadius(context, 8),
                    ),
                  ),
                  child: Icon(
                    Icons.email_outlined,
                    color: AppDesignSystem.primary,
                    size: AppDesignSystem.responsiveSize(context, 20),
                  ),
                ),
                suffixIcon: Obx(
                  () => controller.isEmailValid.value
                      ? Icon(
                          Icons.check_circle,
                          color: AppDesignSystem.success,
                          size: AppDesignSystem.responsiveSize(context, 20),
                        )
                      : const SizedBox.shrink(),
                ),
                border: InputBorder.none,
                contentPadding: AppDesignSystem.responsivePadding(
                  context,
                  horizontal: 16,
                  vertical: 16,
                ),
              ),
              style: AppDesignSystem.textTheme(context).bodyMedium,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordField(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Mot de passe',
          style: AppDesignSystem.textTheme(context).labelLarge?.copyWith(
            fontWeight: FontWeight.w600,
            color: AppDesignSystem.textPrimary,
          ),
        ),
        SizedBox(height: AppDesignSystem.spacing(context, 8)),
        Obx(
          () => Container(
            decoration: AppDesignSystem.inputDecoration(
              context,
              focused: controller.isPasswordFocused.value,
            ),
            child: TextFormField(
              controller: controller.passwordController,
              focusNode: controller.passwordFocusNode,
              obscureText: !controller.isPasswordVisible.value,
              textInputAction: TextInputAction.done,
              onChanged: (value) {
                // Validation is already handled by the controller listeners
              },
              onFieldSubmitted: (_) => controller.login(),
              decoration: InputDecoration(
                hintText: '••••••••',
                hintStyle: AppDesignSystem.textTheme(
                  context,
                ).bodyMedium?.copyWith(color: AppDesignSystem.textTertiary),
                prefixIcon: Container(
                  margin: EdgeInsets.all(AppDesignSystem.spacing(context, 12)),
                  padding: EdgeInsets.all(AppDesignSystem.spacing(context, 8)),
                  decoration: BoxDecoration(
                    color: AppDesignSystem.primarySoft,
                    borderRadius: BorderRadius.circular(
                      AppDesignSystem.responsiveRadius(context, 8),
                    ),
                  ),
                  child: Icon(
                    Icons.lock_outline,
                    color: AppDesignSystem.primary,
                    size: AppDesignSystem.responsiveSize(context, 20),
                  ),
                ),
                suffixIcon: IconButton(
                  onPressed: controller.togglePasswordVisibility,
                  icon: Icon(
                    controller.isPasswordVisible.value
                        ? Icons.visibility_off
                        : Icons.visibility,
                    color: AppDesignSystem.textSecondary,
                    size: AppDesignSystem.responsiveSize(context, 20),
                  ),
                ),
                border: InputBorder.none,
                contentPadding: AppDesignSystem.responsivePadding(
                  context,
                  horizontal: 16,
                  vertical: 16,
                ),
              ),
              style: AppDesignSystem.textTheme(context).bodyMedium,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLoginButton(BuildContext context) {
    return Obx(
      () => GestureDetector(
        onTap: controller.isFormValid.value && !controller.isLoading.value
            ? () {
                HapticFeedback.lightImpact();
                controller.login();
              }
            : null,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: AppDesignSystem.responsivePadding(context, vertical: 24),
          decoration: BoxDecoration(
            color: controller.isFormValid.value
                ? AppDesignSystem.primary
                : AppDesignSystem.surfaceVariant,
            borderRadius: BorderRadius.circular(
              AppDesignSystem.responsiveRadius(context, 20),
            ),
            boxShadow: controller.isFormValid.value
                ? [
                    BoxShadow(
                      color: AppDesignSystem.primary.withOpacity(0.4),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                    BoxShadow(
                      color: AppDesignSystem.primary.withOpacity(0.2),
                      blurRadius: 40,
                      offset: const Offset(0, 20),
                    ),
                  ]
                : [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
          ),
          child: controller.isLoading.value
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: AppDesignSystem.responsiveSize(context, 24),
                      width: AppDesignSystem.responsiveSize(context, 24),
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          AppDesignSystem.textInverse,
                        ),
                      ),
                    ),
                    SizedBox(width: AppDesignSystem.spacing(context, 16)),
                    Text(
                      'Connexion en cours...',
                      style: AppDesignSystem.textTheme(context).titleMedium
                          ?.copyWith(
                            color: AppDesignSystem.textInverse,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ],
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.login_rounded,
                      color: controller.isFormValid.value
                          ? AppDesignSystem.textInverse
                          : AppDesignSystem.textTertiary,
                      size: AppDesignSystem.responsiveSize(context, 24),
                    ),
                    SizedBox(width: AppDesignSystem.spacing(context, 12)),
                    Text(
                      'Se connecter',
                      style: AppDesignSystem.textTheme(context).titleMedium
                          ?.copyWith(
                            color: controller.isFormValid.value
                                ? AppDesignSystem.textInverse
                                : AppDesignSystem.textTertiary,
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  Widget _buildForgotPasswordButton(BuildContext context) {
    return TextButton(
      onPressed: controller.forgotPassword,
      style: TextButton.styleFrom(
        foregroundColor: AppDesignSystem.primary,
        padding: AppDesignSystem.responsivePadding(context, vertical: 12),
      ),
      child: Text(
        'Mot de passe oublié ?',
        style: AppDesignSystem.textTheme(context).bodyMedium?.copyWith(
          color: AppDesignSystem.primary,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildFooter(BuildContext context) {
    return Padding(
      padding: AppDesignSystem.responsivePadding(
        context,
        horizontal: 24,
        vertical: 16,
      ),
      child: Text(
        '© 2025 Espace Scolaire - Tous droits réservés',
        style: AppDesignSystem.textTheme(
          context,
        ).bodySmall?.copyWith(color: AppDesignSystem.textTertiary),
        textAlign: TextAlign.center,
      ).animate().fadeIn(duration: 600.ms, delay: 1000.ms),
    );
  }
}
