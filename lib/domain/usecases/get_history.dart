import 'package:dartz/dartz.dart';

import '../../ core/error/failures.dart';
import '../entities/qr_item.dart';
import '../repositories/qr_repository.dart';

class GetHistory {
  final QRRepository repository;

  GetHistory(this.repository);

  Future<Either<Failure, List<QRItem>>> call() async {
    return await repository.getHistory();
  }
}