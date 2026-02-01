import 'package:hive/hive.dart';
import '../models/qr_item_model.dart';

abstract class QRLocalDataSource {
  Future<List<QRItemModel>> getHistory();
  Future<void> addQRItem(QRItemModel item);
  Future<void> deleteQRItem(int index);
  Future<void> clearAllHistory();
}

class QRLocalDataSourceImpl implements QRLocalDataSource {
  final Box<QRItemModel> box;

  QRLocalDataSourceImpl(this.box);

  @override
  Future<List<QRItemModel>> getHistory() async {
    try {
      return box.values.toList();
    } catch (e) {
      throw Exception('Failed to load history: $e');
    }
  }

  @override
  Future<void> addQRItem(QRItemModel item) async {
    try {
      await box.add(item);
    } catch (e) {
      throw Exception('Failed to add QR item: $e');
    }
  }

  @override
  Future<void> deleteQRItem(int index) async {
    try {
      await box.deleteAt(index);
    } catch (e) {
      throw Exception('Failed to delete QR item: $e');
    }
  }

  @override
  Future<void> clearAllHistory() async {
    try {
      await box.clear();
    } catch (e) {
      throw Exception('Failed to clear history: $e');
    }
  }
}