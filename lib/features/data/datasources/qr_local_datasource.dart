import 'package:hive/hive.dart';
import '../models/qr_item_model.dart';

abstract class QRLocalDataSource {
  Future<List<QRItemModel>> getHistory();
  Future<void> addQRItem(QRItemModel item);
  Future<void> deleteQRItem(dynamic key);
  Future<void> clearAllHistory();

  /// Returns items paired with their actual Hive keys — guaranteed same order.
  Future<List<MapEntry<dynamic, QRItemModel>>> getHistoryWithKeys();
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
  Future<void> deleteQRItem(dynamic key) async {
    try {
      await box.delete(key);
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

  /// Uses box.toMap() so key and value are guaranteed paired correctly.
  @override
  Future<List<MapEntry<dynamic, QRItemModel>>> getHistoryWithKeys() async {
    try {
      return box.toMap().entries.toList();
    } catch (e) {
      throw Exception('Failed to load history with keys: $e');
    }
  }
}