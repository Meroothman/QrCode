import 'package:dartz/dartz.dart';

import '../../../ core/error/failures.dart';
import '../repositories/qr_repository.dart';

class ClearAllHistory {
  final QRRepository repository;

  ClearAllHistory(this.repository);

  Future<Either<Failure, void>> call() async {
    return await repository.clearAllHistory();
  }
}