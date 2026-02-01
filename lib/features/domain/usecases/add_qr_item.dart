import 'package:dartz/dartz.dart';

import '../../../ core/error/failures.dart';
import '../entities/qr_item.dart';
import '../repositories/qr_repository.dart';

class AddQRItem {
  final QRRepository repository;

  AddQRItem(this.repository);

  Future<Either<Failure, void>> call(QRItem item) async {
    return await repository.addQRItem(item);
  }
}