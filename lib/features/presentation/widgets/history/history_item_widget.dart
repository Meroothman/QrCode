import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../ core/constants/app_constants.dart';
import '../../../../ core/utils/toast_utils.dart';
import '../../../../ core/utils/utils.dart';
import '../../../domain/entities/qr_item.dart';
import '../../cubits/history/history_cubit.dart';
import 'qr_code_dialog.dart';
import 'detail_dialog.dart';

class HistoryItemWidget extends StatelessWidget {
  final QRItem item;
  final int index;

  const HistoryItemWidget({
    super.key,
    required this.item,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    final isLink = ValidationUtils.isLink(item.content);
    final isGenerated = item.type == AppConstants.generateType;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: _buildLeadingIcon(),
        title: _buildTitle(isLink),
        subtitle: _buildSubtitle(),
        trailing: _buildTrailingActions(context, isLink, isGenerated),
        onTap: () => _showDetailDialog(context),
      ),
    );
  }

  Widget _buildLeadingIcon() {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(
        item.type == AppConstants.scanType
            ? Icons.qr_code_scanner
            : Icons.qr_code,
        color: AppColors.black,
        size: 20,
      ),
    );
  }

  Widget _buildTitle(bool isLink) {
    return Text(
      TextUtils.truncate(item.content),
      style: TextStyle(
        color: isLink ? AppColors.primary : AppColors.white,
        fontWeight: FontWeight.w500,
        decoration: isLink ? TextDecoration.underline : TextDecoration.none,
      ),
    );
  }

  Widget _buildSubtitle() {
    return Text(
      DateTimeUtils.formatDateTime(item.dateTime),
      style: const TextStyle(color: AppColors.white54, fontSize: 12),
    );
  }

  Widget _buildTrailingActions(
    BuildContext context,
    bool isLink,
    bool isGenerated,
  ) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (isLink && item.type == AppConstants.scanType)
          IconButton(
            onPressed: () => _openLink(context),
            icon: const Icon(
              Icons.open_in_new,
              color: AppColors.primary,
              size: 20,
            ),
          ),
        if (isGenerated)
          IconButton(
            onPressed: () => _showQRCodeDialog(context),
            icon: const Icon(
              Icons.qr_code,
              color: AppColors.primary,
              size: 20,
            ),
          ),
        IconButton(
          onPressed: () => _showDeleteDialog(context),
          icon: const Icon(
            Icons.delete_outline,
            color: AppColors.white54,
            size: 20,
          ),
        ),
      ],
    );
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

  void _showQRCodeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => QRCodeDialog(content: item.content),
    );
  }

  void _showDetailDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => DetailDialog(item: item),
    );
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: AppColors.background,
        title: const Text(
          AppStrings.deleteItem,
          style: TextStyle(color: AppColors.white),
        ),
        content: const Text(
          AppStrings.areYouSure,
          style: TextStyle(color: AppColors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text(
              AppStrings.cancel,
              style: TextStyle(color: AppColors.white54),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              context.read<HistoryCubit>().deleteItem(index);
            },
            child: const Text(
              AppStrings.delete,
              style: TextStyle(color: AppColors.red),
            ),
          ),
        ],
      ),
    );
  }
}