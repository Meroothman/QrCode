import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/qr_item.dart';
import '../../../domain/usecases/clear_all_history.dart';
import '../../../domain/usecases/delete_qr_item.dart';
import '../../../domain/usecases/get_keys.dart'; 

part 'history_state.dart';

class HistoryCubit extends Cubit<HistoryState> {
  final GetHistoryWithKeys getHistoryWithKeys;
  final DeleteQRItem deleteQRItem;
  final ClearAllHistory clearAllHistory;

  HistoryCubit(
    this.getHistoryWithKeys,
    this.deleteQRItem,
    this.clearAllHistory,
  ) : super(const HistoryInitial());

  Future<void> loadHistory({String? filter}) async {
    emit(const HistoryLoading());

    final result = await getHistoryWithKeys();

    result.fold(
      (failure) => emit(HistoryError(failure.message)),
      (entries) {
        // entries is List<MapEntry<dynamic, QRItem>> — key and item guaranteed paired
        List<MapEntry<dynamic, QRItem>> paired = entries;

        // Apply filter
        if (filter != null) {
          paired = paired.where((e) => e.value.type == filter).toList();
        }

        // Sort newest first
        paired.sort((a, b) => b.value.dateTime.compareTo(a.value.dateTime));

        final items = paired.map((e) => e.value).toList();
        final keys = paired.map((e) => e.key).toList();

        emit(HistoryLoaded(items, keys: keys, filter: filter));
      },
    );
  }

  Future<void> deleteItem(int listIndex) async {
    if (state is! HistoryLoaded) return;

    final currentState = state as HistoryLoaded;
    if (listIndex < 0 || listIndex >= currentState.keys.length) return;

    final hiveKey = currentState.keys[listIndex];
    final result = await deleteQRItem(hiveKey);

    result.fold(
      (failure) => emit(HistoryError(failure.message)),
      (_) => loadHistory(filter: currentState.filter),
    );
  }

  Future<void> clearAll() async {
    if (state is! HistoryLoaded) return;
    final currentState = state as HistoryLoaded;

    final result = await clearAllHistory();

    result.fold(
      (failure) => emit(HistoryError(failure.message)),
      (_) => loadHistory(filter: currentState.filter),
    );
  }

  void filterHistory(String type) {
    loadHistory(filter: type);
  }
}