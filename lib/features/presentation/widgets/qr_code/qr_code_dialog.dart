import 'dart:io';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';

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
              onPressed: () async {
                print('🔥🔥🔥 BUTTON PRESSED! 🔥🔥🔥');
                await _shareQRCode(context);
              },
              child: const Text(
                'Share QR Code',
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

  Future<void> _shareQRCode(BuildContext context) async {
    try {
      print('📱 Step 1: Starting share...');

      // Generate QR code
      final qrValidationResult = QrValidator.validate(
        data: content,
        version: QrVersions.auto,
        errorCorrectionLevel: QrErrorCorrectLevel.H,
      );

      print('📱 Step 2: Validation done');

      if (qrValidationResult.status != QrValidationStatus.valid) {
        print('❌ Invalid QR data');
        throw Exception('Invalid QR code data');
      }

      final qrCode = qrValidationResult.qrCode!;
      final painter = QrPainter.withQr(
        qr: qrCode,
        color: const Color(0xFF000000),
        emptyColor: const Color(0xFFFFFFFF),
        gapless: true,
      );

      print('📱 Step 3: Painter created');

      // Convert to image
      final picData = await painter.toImageData(512);
      if (picData == null) {
        print('❌ Failed to generate image');
        throw Exception('Failed to generate image');
      }

      print(
        '📱 Step 4: Image generated, size: ${picData.buffer.lengthInBytes} bytes',
      );

      // Get temporary directory
      final tempDir = await getTemporaryDirectory();
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final filePath = '${tempDir.path}/qr_$timestamp.png';
      final file = File(filePath);

      print('📱 Step 5: Writing to: $filePath');

      // Write bytes
      await file.writeAsBytes(picData.buffer.asUint8List());

      print('✅ File written successfully');
      print('✅ File exists: ${await file.exists()}');
      print('✅ File size: ${await file.length()} bytes');

      // Share
      print('📱 Step 6: Calling Share.shareXFiles...');
      final result = await Share.shareXFiles([XFile(filePath)]);

      print('✅ Share completed with status: ${result.status}');

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('QR Code shared successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e, stack) {
      print('❌❌❌ ERROR: $e');
      print('Stack trace: $stack');

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to share: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
