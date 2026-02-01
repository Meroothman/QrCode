import 'package:flutter/material.dart';

import '../../../ core/constants/app_constants.dart';

class FilterTabsWidget extends StatelessWidget {
  final String selectedTab;
  final Function(String) onTabChanged;

  const FilterTabsWidget({
    super.key,
    required this.selectedTab,
    required this.onTabChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
      child: Row(
        children: [
          Expanded(
            child: _buildTab(AppConstants.scanType, AppStrings.scan),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _buildTab(AppConstants.generateType, AppStrings.create),
          ),
        ],
      ),
    );
  }

  Widget _buildTab(String tabValue, String label) {
    final isSelected = selectedTab == tabValue;

    return GestureDetector(
      onTap: () => onTabChanged(tabValue),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.grey[800],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? AppColors.black : AppColors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}