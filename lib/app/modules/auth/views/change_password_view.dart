
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:portail_eleve/app/modules/auth/controllers/change_password_controller.dart';

class ChangePasswordView extends GetView<ChangePasswordController> {
  const ChangePasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Changer le mot de passe'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: controller.oldPasswordController,
              decoration: const InputDecoration(
                labelText: 'Ancien mot de passe',
              ),
              obscureText: true,
            ),
            TextField(
              controller: controller.newPasswordController,
              decoration: const InputDecoration(
                labelText: 'Nouveau mot de passe',
              ),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            Obx(
              () => ElevatedButton(
                onPressed: controller.isLoading.value ? null : controller.changePassword,
                child: controller.isLoading.value
                    ? const CircularProgressIndicator()
                    : const Text('Changer le mot de passe'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
