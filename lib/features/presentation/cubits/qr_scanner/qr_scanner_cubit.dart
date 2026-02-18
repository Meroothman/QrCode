import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../ core/constants/app_constants.dart';
import '../../../domain/entities/qr_item.dart';
import '../../../domain/usecases/add_qr_item.dart';
import '../../../domain/usecases/get_history.dart';

part 'qr_scanner_state.dart';

class QRScannerCubit extends Cubit<QRScannerState> {
  final AddQRItem addQRItem;
  final GetHistory getHistory;

  QRScannerCubit(this.addQRItem, this.getHistory) : super(const QRScannerInitial());

  Future<void> scanQRCode(String code) async {
    if (state is QRScannerProcessing) return;

    emit(const QRScannerProcessing());

    // Check for duplicate before adding
    final historyResult = await getHistory();
    final isDuplicate = historyResult.fold(
      (_) => false,
      (items) => items.any(
        (item) => item.content == code && item.type == AppConstants.scanType,
      ),
    );

    // If duplicate exists, still emit success (show result) but don't add again
    if (isDuplicate) {
      emit(QRScannerSuccess(code));
      return;
    }

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
}