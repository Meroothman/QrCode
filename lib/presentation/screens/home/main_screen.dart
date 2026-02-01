import 'package:flutter/material.dart';

import '../../../ core/constants/app_constants.dart';
import '../generator/qr_generator_screen.dart';
import '../history/history_screen.dart';
import '../scanner/qr_scanner_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 1; // Start with scanner (middle)
  final GlobalKey<QRGeneratorScreenState> _generatorKey = GlobalKey();

  late final List<Widget> _screens = [
    QRGeneratorScreen(key: _generatorKey),
    const QRScannerScreen(),
    const HistoryScreen(),
  ];

  void _onTabChanged(int newIndex) {
    // If leaving generator screen (index 0), clear it
    if (_currentIndex == 0 && newIndex != 0) {
      _generatorKey.currentState?.clearAll();
    }
    setState(() => _currentIndex = newIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      body: IndexedStack(index: _currentIndex, children: _screens),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      height: 80,
      decoration: BoxDecoration(
        color: const Color(0xFF2D2D2D),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildNavItem(0, Icons.qr_code, AppStrings.generate),
            _buildCenterNavItem(1, Icons.qr_code_scanner),
            _buildNavItem(2, Icons.history, AppStrings.history),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    final isSelected = _currentIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => _onTabChanged(index),
        child: Container(
          color: Colors.transparent,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: isSelected ? AppColors.primary : Colors.white70,
                size: 24,
              ),
              const SizedBox(height: 6),
              Text(
                label,
                style: TextStyle(
                  color: isSelected ? AppColors.primary : Colors.white70,
                  fontSize: 11,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCenterNavItem(int index, IconData icon) {
    final isSelected = _currentIndex == index;
    return GestureDetector(
      onTap: () => _onTabChanged(index),
      child: Transform.translate(
        offset: const Offset(0, -10), // Lift it up a bit
        child: Container(
          width: 65,
          height: 65,
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary : const Color(0xFF404040),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: isSelected
                    ? AppColors.primary.withOpacity(0.4)
                    : Colors.black.withOpacity(0.3),
                blurRadius: 12,
                spreadRadius: 2,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Icon(
            icon,
            color: isSelected ? AppColors.black : Colors.white70,
            size: 30,
          ),
        ),
      ),
    );
  }
}
