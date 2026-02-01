import 'package:hive/hive.dart';
import '../../domain/entities/qr_item.dart';

part 'qr_item_model.g.dart';

@HiveType(typeId: 0)
class QRItemModel extends HiveObject {
  @HiveField(0)
  final String content;

  @HiveField(1)
  final String type;

  @HiveField(2)
  final DateTime dateTime;

  QRItemModel({
    required this.content,
    required this.type,
    required this.dateTime,
  });

  /// Convert to domain entity
  QRItem toEntity() {
    return QRItem(
      content: content,
      type: type,
      dateTime: dateTime,
    );
  }

  /// Create from domain entity
  factory QRItemModel.fromEntity(QRItem entity) {
    return QRItemModel(
      content: entity.content,
      type: entity.type,
      dateTime: entity.dateTime,
    );
  }
}