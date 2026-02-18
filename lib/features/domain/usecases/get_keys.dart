import 'package:dartz/dartz.dart';

import '../../../ core/error/failures.dart';
import '../entities/qr_item.dart';
import '../repositories/qr_repository.dart';

/// Returns history items paired with their actual Hive keys.
class GetHistoryWithKeys {
  final QRRepository repository;

  GetHistoryWithKeys(this.repository);

  Future<Either<Failure, List<MapEntry<dynamic, QRItem>>>> call() async {
    return await repository.getHistoryWithKeys();
  }
}