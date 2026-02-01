import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../ core/constants/app_constants.dart' ;
import '../../../../ core/utils/toast_utils.dart';
import '../../../../ core/utils/utils.dart';



class ScanResultDialog extends StatelessWidget {
  final String code;
  final VoidCallback onDismiss;

  const ScanResultDialog({
    super.key,
    required this.code,
    required this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    final isLink = ValidationUtils.isLink(code);

    return AlertDialog(
      backgroundColor: AppColors.background,
      title: const Text(
        AppStrings.qrCodeScanned,
        style: TextStyle(color: AppColors.white),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SelectableText(
            code,
            style: TextStyle(
              color: isLink ? AppColors.primary : AppColors.white70,
              decoration: isLink ? TextDecoration.underline : null,
            ),
          ),
        ],
      ),
      actions: [
        if (isLink)
          TextButton(
            onPressed: () => _openLink(code, context),
            child: const Text(
              AppStrings.openLink,
              style: TextStyle(color: AppColors.primary),
            ),
          ),
        TextButton(
          onPressed: onDismiss,
          child: const Text(
            AppStrings.ok,
            style: TextStyle(color: AppColors.primary),
          ),
        ),
      ],
    );
  }

  Future<void> _openLink(String url, BuildContext context) async {
    try {
      // Add https:// if no protocol specified
      final formattedUrl = url.startsWith('http') ? url : 'https://$url';
      final uri = Uri.parse(formattedUrl);

      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        if (context.mounted) {
          ToastUtils.showError('Could not open link', context: context);
        }
      }
    } catch (e) {
      if (context.mounted) {
        ToastUtils.showError('Failed to open link', context: context);
      }
    }
  }
}