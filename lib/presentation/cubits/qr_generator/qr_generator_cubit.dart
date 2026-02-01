import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../ core/constants/app_constants.dart';
import '../../../domain/entities/qr_item.dart';
import '../../../domain/usecases/add_qr_item.dart';

part 'qr_generator_state.dart';

class QRGeneratorCubit extends Cubit<QRGeneratorState> {
  final AddQRItem addQRItem;

  QRGeneratorCubit(this.addQRItem) : super(const QRGeneratorInitial());

  Future<void> generateQRCode(String content) async {
    if (content.trim().isEmpty) {
      emit(const QRGeneratorError('Please enter some text'));
      return;
    }

    emit(const QRGeneratorLoading());

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