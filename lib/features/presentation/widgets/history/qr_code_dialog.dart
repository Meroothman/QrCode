import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';
import '../../../../ core/constants/app_constants.dart';


class QRCodeDialog extends StatelessWidget {
  final String content;

  const QRCodeDialog({super.key, required this.content});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.background,
      title: const Text(
        AppStrings.generatedQRCode,
        style: TextStyle(color: AppColors.white),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: QrImageView(
              data: content,
              version: QrVersions.auto,
              size: 200.0,
              backgroundColor: AppColors.white,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
              ),
              onPressed: () => _shareContent(context),
              child: const Text(
                AppStrings.share,
                style: TextStyle(color: AppColors.black),
              ),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text(
            AppStrings.close,
            style: TextStyle(color: AppColors.primary),
          ),
        ),
      ],
    );
  }

  void _shareContent(BuildContext context) {
    Share.share(content);
  }
}