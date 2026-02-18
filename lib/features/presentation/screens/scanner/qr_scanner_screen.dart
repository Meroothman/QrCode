import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../ core/constants/app_constants.dart';
import '../../../../ core/utils/toast_utils.dart';
import '../../cubits/history/history_cubit.dart';
import '../../cubits/qr_scanner/qr_scanner_cubit.dart';
import '../../widgets/scanner/scan_result_dialog.dart';

class QRScannerScreen extends StatefulWidget {
  const QRScannerScreen({super.key});

  @override
  State<QRScannerScreen> createState() => QRScannerScreenState();
}

class QRScannerScreenState extends State<QRScannerScreen>
    with AutomaticKeepAliveClientMixin {
  late MobileScannerController _controller;
  bool _isFlashOn = false;
  bool _isDialogOpen = false;
  final ImagePicker _imagePicker = ImagePicker();

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _initializeController();
  }

  void _initializeController() {
    _controller = MobileScannerController(
      detectionSpeed: DetectionSpeed.noDuplicates,
      facing: CameraFacing.back,
      torchEnabled: false,
    );
  }

  // Public methods to control camera from parent
  void stopCamera() {
    try {
      _controller.stop();
    } catch (e) {
      // Camera might already be stopped
    }
  }

  void startCamera() {
    try {
      _controller.start();
    } catch (e) {
      // Camera might already be started
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: AppColors.black,
      body: BlocListener<QRScannerCubit, QRScannerState>(
        listener: _handleScannerState,
        child: _buildScannerBody(),
      ),
    );
  }

  void _handleScannerState(BuildContext context, QRScannerState state) {
    if (state is QRScannerSuccess) {
      _controller.stop();
      if (!_isDialogOpen) {
        _isDialogOpen = true;
        _showResultDialog(state.code);
      }
      final currentState = context.read<HistoryCubit>().state;
      if (currentState is HistoryLoaded) {
        context.read<HistoryCubit>().filterHistory(
          currentState.filter ?? AppConstants.scanType,
        );
      }
    } else if (state is QRScannerError) {
      ToastUtils.showError(state.message, context: context);
      context.read<QRScannerCubit>().resetScanner();
      _controller.start();
    }
  }

  Widget _buildScannerBody() {
    return GestureDetector(
      child: Stack(
        children: [
          _buildScanner(),
          _buildTopControls(),
          _buildScanningFrame(),
          _buildCornerOverlays(),
        ],
      ),
    );
  }

  Widget _buildScanner() {
    return MobileScanner(
      controller: _controller,
      onDetect: (capture) {
        final state = context.read<QRScannerCubit>().state;
        if (state is QRScannerProcessing) return;
        if (_isDialogOpen) return;

        final barcode = capture.barcodes.firstOrNull;
        final code = barcode?.rawValue;

        if (code != null && code.isNotEmpty) {
          context.read<QRScannerCubit>().scanQRCode(code);
        }
      },
    );
  }

  Widget _buildTopControls() {
    return Positioned(
      top: 50,
      left: 20,
      right: 20,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildControlButton(Icons.photo_library, _pickImageFromGallery),
          _buildControlButton(
            _isFlashOn ? Icons.flash_on : Icons.flash_off,
            _toggleFlash,
          ),

          IconButton(
            onPressed: () {
              // Settings functionality can be added
              ToastUtils.showInfo('Settings coming soon!', context: context);
            },
            icon: const Icon(Icons.settings, color: AppColors.white, size: 28),
          ),
        ],
      ),
    );
  }

  Widget _buildControlButton(IconData icon, VoidCallback onPressed) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.5),
        shape: BoxShape.circle,
      ),
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(icon, color: AppColors.white, size: 24),
      ),
    );
  }

  Widget _buildScanningFrame() {
    return Center(
      child: Container(
        width: 250,
        height: 250,
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.primary, width: 3),
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }

  Widget _buildCornerOverlays() {
    return Center(
      child: SizedBox(
        width: 250,
        height: 250,
        child: Stack(
          children: [
            _buildCorner(top: -10, left: -10, isTopLeft: true),
            _buildCorner(top: -10, right: -10, isTopRight: true),
            _buildCorner(bottom: -10, left: -10, isBottomLeft: true),
            _buildCorner(bottom: -10, right: -10, isBottomRight: true),
          ],
        ),
      ),
    );
  }

  Widget _buildCorner({
    double? top,
    double? bottom,
    double? left,
    double? right,
    bool isTopLeft = false,
    bool isTopRight = false,
    bool isBottomLeft = false,
    bool isBottomRight = false,
  }) {
    BorderRadius borderRadius;
    if (isTopLeft) {
      borderRadius = const BorderRadius.only(topLeft: Radius.circular(20));
    } else if (isTopRight) {
      borderRadius = const BorderRadius.only(topRight: Radius.circular(20));
    } else if (isBottomLeft) {
      borderRadius = const BorderRadius.only(bottomLeft: Radius.circular(20));
    } else {
      borderRadius = const BorderRadius.only(bottomRight: Radius.circular(20));
    }

    return Positioned(
      top: top,
      bottom: bottom,
      left: left,
      right: right,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: borderRadius,
        ),
      ),
    );
  }

  Future<void> _toggleFlash() async {
    try {
      await _controller.toggleTorch();
      setState(() {
        _isFlashOn = !_isFlashOn;
      });
    } catch (e) {
      ToastUtils.showError('Failed to toggle flash', context: context);
    }
  }

  Future<void> _pickImageFromGallery() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
      );
      if (image != null) {
        final BarcodeCapture? barcodes = await _controller.analyzeImage(
          image.path,
        );
        if (barcodes != null && barcodes.barcodes.isNotEmpty) {
          final code = barcodes.barcodes.first.rawValue;
          if (code != null && code.isNotEmpty) {
            if (mounted) {
              context.read<QRScannerCubit>().scanQRCode(code);
            }
          } else {
            ToastUtils.showWarning(
              'No valid QR code found in image',
              context: context,
            );
          }
        } else {
          ToastUtils.showWarning('No QR code found in image', context: context);
        }
      }
    } catch (e) {
      ToastUtils.showError(
        'Failed to scan QR code from image',
        context: context,
      );
    }
  }

  void _showResultDialog(String code) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (dialogContext) => PopScope(
        canPop: false,
        onPopInvoked: (didPop) {
          if (!didPop) _dismissDialog(dialogContext);
        },
        child: ScanResultDialog(
          code: code,
          onDismiss: () => _dismissDialog(dialogContext),
        ),
      ),
    );
  }

  void _dismissDialog(BuildContext dialogContext) {
    if (!_isDialogOpen) return;
    _isDialogOpen = false;
    if (dialogContext.mounted) Navigator.pop(dialogContext);
    if (mounted) {
      context.read<QRScannerCubit>().resetScanner();
      _controller.start();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
