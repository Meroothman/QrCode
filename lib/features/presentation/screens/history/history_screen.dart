import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


import '../../../../ core/constants/app_constants.dart';
import '../../cubits/history/history_cubit.dart';
import '../../widgets/history/history_item_widget.dart';
import '../../widgets/history/filter_tabs_widget.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen>
    with AutomaticKeepAliveClientMixin {
  String _selectedTab = AppConstants.scanType;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    // Load history with scan filter on first load
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HistoryCubit>().filterHistory(AppConstants.scanType);
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      appBar: _buildAppBar(),
      body: Column(
        children: [
          FilterTabsWidget(
            selectedTab: _selectedTab,
            onTabChanged: _onTabChanged,
          ),
          Expanded(
            child: BlocBuilder<HistoryCubit, HistoryState>(
              builder: _buildHistoryContent,
            ),
          ),
        ],
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      title: const Text(
        AppStrings.history,
        style: TextStyle(color: AppColors.white),
      ),
      actions: [
        PopupMenuButton<String>(
          icon: const Icon(Icons.more_vert, color: AppColors.white),
          color: AppColors.background,
          onSelected: _handleMenuAction,
          itemBuilder: (context) => const [
            PopupMenuItem(
              value: 'clear_all',
              child: Text(
                AppStrings.clearAllHistory,
                style: TextStyle(color: AppColors.white),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildHistoryContent(BuildContext context, HistoryState state) {
    if (state is HistoryLoading) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      );
    }

    if (state is HistoryError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, color: AppColors.red, size: 48),
            const SizedBox(height: 16),
            Text(
              state.message,
              style: const TextStyle(color: AppColors.white70),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.read<HistoryCubit>().loadHistory(),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
              ),
              child: const Text(
                'Retry',
                style: TextStyle(color: AppColors.black),
              ),
            ),
          ],
        ),
      );
    }

    if (state is HistoryLoaded) {
      if (state.items.isEmpty) {
        return const Center(
          child: Text(
            AppStrings.noHistoryFound,
            style: TextStyle(color: AppColors.white54, fontSize: 16),
          ),
        );
      }

      return ListView.builder(
        itemCount: state.items.length,
        padding: const EdgeInsets.only(bottom: 16),
        itemBuilder: (context, index) {
          return HistoryItemWidget(
            item: state.items[index],
            index: index,
          );
        },
      );
    }

    return const SizedBox.shrink();
  }

  void _onTabChanged(String tab) {
    setState(() {
      _selectedTab = tab;
    });
    context.read<HistoryCubit>().filterHistory(tab);
  }

  void _handleMenuAction(String value) {
    if (value == 'clear_all') {
      _showClearAllDialog();
    }
  }

  void _showClearAllDialog() {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: AppColors.background,
        title: const Text(
          AppStrings.clearAllHistory,
          style: TextStyle(color: AppColors.white),
        ),
        content: const Text(
          AppStrings.areYouSureClearAll,
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
              context.read<HistoryCubit>().clearAll();
            },
            child: const Text(
              AppStrings.clearAll,
              style: TextStyle(color: AppColors.red),
            ),
          ),
        ],
      ),
    );
  }
}