import 'package:dartz/dartz.dart';

import '../../../ core/error/failures.dart';
import '../entities/qr_item.dart';

abstract class QRRepository {
  Future<Either<Failure, List<QRItem>>> getHistory();
  Future<Either<Failure, void>> addQRItem(QRItem item);
  Future<Either<Failure, void>> deleteQRItem(dynamic key);
  Future<Either<Failure, void>> clearAllHistory();

  /// Returns each item paired with its actual Hive key.
  Future<Either<Failure, List<MapEntry<dynamic, QRItem>>>> getHistoryWithKeys();
}