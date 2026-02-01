import 'package:flutter/material.dart';
import 'package:qrcode/%20core/di/injection.dart' show getIt;

import '../../../../ core/constants/app_constants.dart';
import '../../../../ core/prefs/preferences_service.dart';
import '../home/main_screen.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            children: [
              const Spacer(),
              _buildQRImage(),
              const SizedBox(height: 60),
              _buildWelcomeText(),
              const SizedBox(height: 40),
              _buildStartButton(context),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQRImage() {
    return SizedBox(
      width: 160,
      height: 160,

      child: Image.asset("assets/images/qr_code_image.png"),
    );
  }

  Widget _buildWelcomeText() {
    return const Text(
      AppStrings.onboardingMessage,
      textAlign: TextAlign.center,
      style: TextStyle(fontSize: 15, color: AppColors.white, height: 1.4),
    );
  }

  Widget _buildStartButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          elevation: 3,
          shadowColor: Colors.black54,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: () async {
          // Mark onboarding as seen
          final preferencesService = getIt<PreferencesService>();
          await preferencesService.setOnboardingSeen();

          // Navigate to main screen
          if (context.mounted) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const MainScreen()),
            );
          }
        },
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              AppStrings.letsStart,
              style: TextStyle(
                fontSize: 18,
                color: AppColors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(width: 8),
            Icon(Icons.arrow_forward, color: AppColors.black),
          ],
        ),
      ),
    );
  }
}
