import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../ core/constants/app_constants.dart';
import '../../../domain/entities/qr_item.dart';
import '../../../domain/usecases/add_qr_item.dart';
import '../../../domain/usecases/get_history.dart';

part 'qr_generator_state.dart';

class QRGeneratorCubit extends Cubit<QRGeneratorState> {
  final AddQRItem addQRItem;
  final GetHistory getHistory;

  QRGeneratorCubit(this.addQRItem, this.getHistory)
    : super(const QRGeneratorInitial());

  Future<void> generateQRCode(String content) async {
    if (content.trim().isEmpty) {
      emit(const QRGeneratorError('Please enter some text'));
      return;
    }

    emit(const QRGeneratorLoading());

    // Check for duplicate before adding
    final historyResult = await getHistory();
    final isDuplicate = historyResult.fold(
      (_) => false,
      (items) => items.any(
        (item) =>
            item.content == content && item.type == AppConstants.generateType,
      ),
    );

    // If duplicate, still show QR but skip adding to history
    if (isDuplicate) {
      emit(QRGeneratorSuccess(content));
      return;
    }

    final item = QRItem(
      content: content,
      type: AppConstants.generateType,
      dateTime: DateTime.now(),
    );

    final result = await addQRItem(item);

    result.fold(
      (failure) => emit(QRGeneratorError(failure.message)),
      (_) => emit(QRGeneratorSuccess(content)),
    );
  }

  void resetGenerator() {
    emit(const QRGeneratorInitial());
  }
}
