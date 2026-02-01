// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'qr_item_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class QRItemModelAdapter extends TypeAdapter<QRItemModel> {
  @override
  final int typeId = 0;

  @override
  QRItemModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return QRItemModel(
      content: fields[0] as String,
      type: fields[1] as String,
      dateTime: fields[2] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, QRItemModel obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.content)
      ..writeByte(1)
      ..write(obj.type)
      ..writeByte(2)
      ..write(obj.dateTime);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is QRItemModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
