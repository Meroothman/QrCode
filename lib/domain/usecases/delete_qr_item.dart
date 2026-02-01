import 'package:dartz/dartz.dart';

import '../../ core/error/failures.dart';
import '../repositories/qr_repository.dart';
class DeleteQRItem {
  final QRRepository repository;

  DeleteQRItem(this.repository);

  Future<Either<Failure, void>> call(int index) async {
    return await repository.deleteQRItem(index);
  }
}