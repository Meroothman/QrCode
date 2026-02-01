import 'package:equatable/equatable.dart';

class QRItem extends Equatable {
  final String content;
  final String type; // 'scan' or 'generate'
  final DateTime dateTime;

  const QRItem({
    required this.content,
    required this.type,
    required this.dateTime,
  });

  @override
  List<Object?> get props => [content, type, dateTime];

  QRItem copyWith({
    String? content,
    String? type,
    DateTime? dateTime,
  }) {
    return QRItem(
      content: content ?? this.content,
      type: type ?? this.type,
      dateTime: dateTime ?? this.dateTime,
    );
  }
}