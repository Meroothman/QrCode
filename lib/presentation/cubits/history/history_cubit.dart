import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/qr_item.dart';
import '../../../domain/usecases/clear_all_history.dart';
import '../../../domain/usecases/delete_qr_item.dart';
import '../../../domain/usecases/get_history.dart';

part 'history_state.dart';

class HistoryCubit extends Cubit<HistoryState> {
  final GetHistory getHistory;
  final DeleteQRItem deleteQRItem;
  final ClearAllHistory clearAllHistory;

  HistoryCubit(
    this.getHistory,
    this.deleteQRItem,
    this.clearAllHistory,
  ) : super(const HistoryInitial());

  Future<void> loadHistory({String? filter}) async {
    emit(const HistoryLoading());

    final result = await getHistory();

    result.fold(
      (failure) => emit(HistoryError(failure.message)),
      (items) {
        List<QRItem> filteredItems = items;
        
        if (filter != null) {
          filteredItems = items
              .where((item) => item.type == filter)
              .toList();
        }
        
        // Sort by date (newest first)
        filteredItems.sort((a, b) => b.dateTime.compareTo(a.dateTime));
        
        emit(HistoryLoaded(filteredItems, filter: filter));
      },
    );
  }

  Future<void> deleteItem(int index) async {
    if (state is! HistoryLoaded) return;

    final currentState = state as HistoryLoaded;
    emit(const HistoryLoading());

    final result = await deleteQRItem(index);

    result.fold(
      (failure) {
        emit(HistoryError(failure.message));
        // Reload history after error
        loadHistory(filter: currentState.filter);
      },
      (_) => loadHistory(filter: currentState.filter),
    );
  }

  Future<void> clearAll() async {
    if (state is! HistoryLoaded) return;

    final currentState = state as HistoryLoaded;
    emit(const HistoryLoading());

    final result = await clearAllHistory();

    result.fold(
      (failure) {
        emit(HistoryError(failure.message));
        // Reload history after error
        loadHistory(filter: currentState.filter);
      },
      (_) => loadHistory(filter: currentState.filter),
    );
  }

  void filterHistory(String type) {
    loadHistory(filter: type);
  }
}