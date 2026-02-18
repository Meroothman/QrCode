import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:share_plus/share_plus.dart';

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
  bool _isSelectionMode = false;
  final Set<int> _selectedIndices = {};

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HistoryCubit>().filterHistory(AppConstants.scanType);
    });
  }

  void _exitSelectionMode() {
    setState(() {
      _isSelectionMode = false;
      _selectedIndices.clear();
    });
  }

  void _toggleSelection(int index) {
    setState(() {
      if (_selectedIndices.contains(index)) {
        _selectedIndices.remove(index);
        if (_selectedIndices.isEmpty) {
          _isSelectionMode = false;
        }
      } else {
        _selectedIndices.add(index);
      }
    });
  }

  void _selectAll() {
    final state = context.read<HistoryCubit>().state;
    if (state is HistoryLoaded) {
      setState(() {
        _selectedIndices.clear();
        _selectedIndices.addAll(List.generate(state.items.length, (i) => i));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return WillPopScope(
      onWillPop: () async {
        if (_isSelectionMode) {
          _exitSelectionMode();
          return false;
        }
        return true;
      },
      child: Scaffold(
        backgroundColor: AppColors.darkBackground,
        appBar: _buildAppBar(),
        body: Column(
          children: [
            if (!_isSelectionMode)
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
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    if (_isSelectionMode) {
      return AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: AppColors.black),
          onPressed: _exitSelectionMode,
        ),
        title: Text(
          '${_selectedIndices.length} selected',
          style: const TextStyle(color: AppColors.black),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.select_all, color: AppColors.black),
            onPressed: _selectAll,
            tooltip: 'Select All',
          ),
          IconButton(
            icon: const Icon(Icons.share, color: AppColors.black),
            onPressed: _selectedIndices.isEmpty ? null : _shareSelected,
            tooltip: 'Share Selected',
          ),
          IconButton(
            icon: const Icon(Icons.delete, color: AppColors.black),
            onPressed: _selectedIndices.isEmpty ? null : _deleteSelected,
            tooltip: 'Delete Selected',
          ),
        ],
      );
    }

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
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'share_all',
              child: Row(
                children: [
                  Icon(Icons.share, color: AppColors.primary, size: 20),
                  SizedBox(width: 12),
                  Text(
                    'Share All Scanned',
                    style: TextStyle(color: AppColors.white),
                  ),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'clear_all',
              child: Row(
                children: [
                  Icon(Icons.delete_sweep, color: AppColors.red, size: 20),
                  SizedBox(width: 12),
                  Text(
                    AppStrings.clearAllHistory,
                    style: TextStyle(color: AppColors.white),
                  ),
                ],
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
          final isSelected = _selectedIndices.contains(index);
          
          return GestureDetector(
            onLongPress: () {
              if (!_isSelectionMode) {
                setState(() {
                  _isSelectionMode = true;
                  _selectedIndices.add(index);
                });
              }
            },
            onTap: _isSelectionMode
                ? () => _toggleSelection(index)
                : null,
            child: Container(
              color: isSelected 
                  ? AppColors.primary.withOpacity(0.2) 
                  : Colors.transparent,
              child: Row(
                children: [
                  if (_isSelectionMode)
                    Padding(
                      padding: const EdgeInsets.only(left: 16),
                      child: Checkbox(
                        value: isSelected,
                        onChanged: (_) => _toggleSelection(index),
                        activeColor: AppColors.primary,
                      ),
                    ),
                  Expanded(
                    child: HistoryItemWidget(
                      item: state.items[index],
                      index: index,
                      isSelectionMode: _isSelectionMode,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    }

    return const SizedBox.shrink();
  }

  void _onTabChanged(String tab) {
    setState(() {
      _selectedTab = tab;
      _isSelectionMode = false;
      _selectedIndices.clear();
    });
    context.read<HistoryCubit>().filterHistory(tab);
  }

  void _handleMenuAction(String value) {
    if (value == 'share_all') {
      _shareAllScanned();
    } else if (value == 'clear_all') {
      _showClearAllDialog();
    }
  }

  void _shareSelected() {
    final state = context.read<HistoryCubit>().state;
    if (state is! HistoryLoaded) return;

    final selectedItems = _selectedIndices
        .map((index) => state.items[index])
        .toList();

    if (selectedItems.isEmpty) return;

    final StringBuffer buffer = StringBuffer();
    
    for (int i = 0; i < selectedItems.length; i++) {
      final item = selectedItems[i];
      buffer.writeln('${i + 1}. ${item.content}');
    }

    Share.share(buffer.toString().trim());
    _exitSelectionMode();
  }

  void _deleteSelected() {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: AppColors.background,
        title: const Text(
          'Delete Selected',
          style: TextStyle(color: AppColors.white),
        ),
        content: Text(
          'Delete ${_selectedIndices.length} selected items?',
          style: const TextStyle(color: AppColors.white70),
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
              
              // Delete in reverse order to maintain correct indices
              final sortedIndices = _selectedIndices.toList()..sort((a, b) => b.compareTo(a));
              for (final index in sortedIndices) {
                context.read<HistoryCubit>().deleteItem(index);
              }
              
              _exitSelectionMode();
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

  void _shareAllScanned() {
    final state = context.read<HistoryCubit>().state;
    if (state is! HistoryLoaded) return;

    final scannedItems = state.items
        .where((item) => item.type == AppConstants.scanType)
        .toList();

    if (scannedItems.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No scanned QR codes to share'),
          backgroundColor: AppColors.red,
        ),
      );
      return;
    }

    final StringBuffer buffer = StringBuffer();
    
    for (int i = 0; i < scannedItems.length; i++) {
      final item = scannedItems[i];
      buffer.writeln('${i + 1}. ${item.content}');
    }

    Share.share(buffer.toString().trim());
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