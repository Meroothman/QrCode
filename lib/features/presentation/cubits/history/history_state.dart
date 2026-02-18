part of 'history_cubit.dart';

abstract class HistoryState extends Equatable {
  const HistoryState();

  @override
  List<Object?> get props => [];
}

class HistoryInitial extends HistoryState {
  const HistoryInitial();
}

class HistoryLoading extends HistoryState {
  const HistoryLoading();
}

class HistoryLoaded extends HistoryState {
  final List<QRItem> items;
  final List<dynamic> keys; // actual Hive keys matching items order
  final String? filter;

  const HistoryLoaded(this.items, {required this.keys, this.filter});

  @override
  List<Object?> get props => [items, keys, filter];
}

class HistoryError extends HistoryState {
  final String message;

  const HistoryError(this.message);

  @override
  List<Object?> get props => [message];
}