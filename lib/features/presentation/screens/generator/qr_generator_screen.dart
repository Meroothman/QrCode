import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../../../ core/constants/app_constants.dart';
import '../../../../ core/utils/toast_utils.dart';
import '../../cubits/history/history_cubit.dart';
import '../../cubits/qr_generator/qr_generator_cubit.dart';

class QRGeneratorScreen extends StatefulWidget {
  const QRGeneratorScreen({super.key});

  @override
  State<QRGeneratorScreen> createState() => QRGeneratorScreenState();
}

class QRGeneratorScreenState extends State<QRGeneratorScreen>
    with AutomaticKeepAliveClientMixin, WidgetsBindingObserver {
  final TextEditingController _textController = TextEditingController();
  String _qrData = '';

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  // Public method to clear everything
  void clearAll() {
    setState(() {
      _textController.clear();
      _qrData = '';
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _buildAppBar(),
      body: BlocListener<QRGeneratorCubit, QRGeneratorState>(
        listener: _handleGeneratorState,
        child: _buildBody(),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      title: const Text(
        AppStrings.generateQRCode,
        style: TextStyle(color: AppColors.white),
      ),
      centerTitle: true,
    );
  }

  void _handleGeneratorState(BuildContext context, QRGeneratorState state) {
    if (state is QRGeneratorSuccess) {
      setState(() {
        _qrData = state.content;
        _textController.clear(); // Clear the text field
      });
      // Refresh history but maintain whatever filter is currently active
      final currentState = context.read<HistoryCubit>().state;
      if (currentState is HistoryLoaded) {
        context.read<HistoryCubit>().filterHistory(currentState.filter ?? AppConstants.scanType);
      }
      _showSuccessToast(context);
    } else if (state is QRGeneratorError) {
      _showErrorToast(context, state.message);
    }
  }

  Widget _buildBody() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _buildInputField(),
            const SizedBox(height: 20),
            _buildGenerateButton(),
            const SizedBox(height: 30),
            if (_qrData.isNotEmpty) _buildQRCodeDisplay(),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField() {
    return TextField(
      controller: _textController,
      style: const TextStyle(color: AppColors.white),
      decoration: InputDecoration(
        hintText: AppStrings.enterText,
        hintStyle: const TextStyle(color: AppColors.white54),
        filled: true,
        fillColor: Colors.grey[800],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
      maxLines: 3,
      onChanged: (value) {
        // Clear QR code when text is cleared or changed
        if (_qrData.isNotEmpty) {
          setState(() {
            _qrData = '';
          });
        }
      },
    );
  }

  Widget _buildGenerateButton() {
    return BlocBuilder<QRGeneratorCubit, QRGeneratorState>(
      builder: (context, state) {
        final isLoading = state is QRGeneratorLoading;

        return SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: isLoading ? null : _generateQRCode,
            child: isLoading
                ? const SizedBox(
                    height: 24,
                    width: 24,
                    child: CircularProgressIndicator(
                      color: AppColors.black,
                      strokeWidth: 2,
                    ),
                  )
                : const Text(
                    AppStrings.generateQRCode,
                    style: TextStyle(
                      color: AppColors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
          ),
        );
      },
    );
  }

  Widget _buildQRCodeDisplay() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: QrImageView(
        data: _qrData,
        version: QrVersions.auto,
        size: 250.0,
        backgroundColor: AppColors.white,
      ),
    );
  }

  void _generateQRCode() {
    final text = _textController.text.trim();
    context.read<QRGeneratorCubit>().generateQRCode(text);
  }

  void _showSuccessToast(BuildContext context) {
    ToastUtils.showSuccess('QR code generated successfully!', context: context);
  }

  void _showErrorToast(BuildContext context, String message) {
    ToastUtils.showError(message, context: context);
  }
}