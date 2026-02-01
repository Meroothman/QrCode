import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';


import '../../../../ core/constants/app_constants.dart';
import '../../../../ core/utils/toast_utils.dart';
import '../../../../ core/utils/utils.dart';
import '../../../domain/entities/qr_item.dart';
import 'qr_code_dialog.dart';

class DetailDialog extends StatelessWidget {
  final QRItem item;

  const DetailDialog({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final isLink = ValidationUtils.isLink(item.content);
    final isScanned = item.type == AppConstants.scanType;

    return AlertDialog(
      backgroundColor: AppColors.background,
      title: Text(
        isScanned ? AppStrings.scannedQRCode : AppStrings.generatedQRCode,
        style: const TextStyle(color: AppColors.white),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            AppStrings.content,
            style: TextStyle(
              color: AppColors.white70,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          SelectableText(
            item.content,
            style: TextStyle(
              color: isLink ? AppColors.primary : AppColors.white,
              decoration: isLink ? TextDecoration.underline : null,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            '${AppStrings.date} ${DateTimeUtils.formatDateTime(item.dateTime)}',
            style: const TextStyle(color: AppColors.white54),
          ),
        ],
      ),
      actions: _buildActions(context, isLink, isScanned),
    );
  }

  List<Widget> _buildActions(BuildContext context, bool isLink, bool isScanned) {
    final actions = <Widget>[];

    if (isLink && isScanned) {
      actions.add(
        TextButton(
          onPressed: () => _openLink(context),
          child: const Text(
            AppStrings.openLink,
            style: TextStyle(color: AppColors.primary),
          ),
        ),
      );
    }

    if (!isScanned) {
      actions.add(
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            showDialog(
              context: context,
              builder: (_) => QRCodeDialog(content: item.content),
            );
          },
          child: const Text(
            AppStrings.showQRCode,
            style: TextStyle(color: AppColors.primary),
          ),
        ),
      );
    }

    actions.add(
      TextButton(
        onPressed: () => Navigator.pop(context),
        child: const Text(
          AppStrings.ok,
          style: TextStyle(color: AppColors.primary),
        ),
      ),
    );

    return actions;
  }

  Future<void> _openLink(BuildContext context) async {
    try {
      final url = item.content.startsWith('http')
          ? item.content
          : 'https://${item.content}';
      final uri = Uri.parse(url);

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