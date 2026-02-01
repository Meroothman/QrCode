import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../ core/constants/app_constants.dart';
import '../../../domain/entities/qr_item.dart';
import '../../../domain/usecases/add_qr_item.dart';

part 'qr_scanner_state.dart';

class QRScannerCubit extends Cubit<QRScannerState> {
  final AddQRItem addQRItem;

  QRScannerCubit(this.addQRItem) : super(const QRScannerInitial());

  Future<void> scanQRCode(String code) async {
    if (state is QRScannerProcessing) return;

    emit(const QRScannerProcessing());

    final item = QRItem(
      content: code,
      type: AppConstants.scanType,
      dateTime: DateTime.now(),
    );

    final result = await addQRItem(item);

    result.fold(
      (failure) => emit(QRScannerError(failure.message)),
      (_) => emit(QRScannerSuccess(code)),
    );
  }

  void resetScanner() {
    emit(const QRScannerInitial());
  }

  void toggleFlash() {
    // This is handled by the UI controller, but we can track state if needed
  }
}