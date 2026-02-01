import 'package:dartz/dartz.dart';

import '../../ core/error/failures.dart';
import '../../domain/entities/qr_item.dart';
import '../../domain/repositories/qr_repository.dart';
import '../datasources/qr_local_datasource.dart';
import '../models/qr_item_model.dart';

class QRRepositoryImpl implements QRRepository {
  final QRLocalDataSource localDataSource;

  QRRepositoryImpl(this.localDataSource);

  @override
  Future<Either<Failure, List<QRItem>>> getHistory() async {
    try {
      final models = await localDataSource.getHistory();
      final entities = models.map((model) => model.toEntity()).toList();
      return Right(entities);
    } catch (e) {
      return Left(CacheFailure('Failed to load history: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, void>> addQRItem(QRItem item) async {
    try {
      final model = QRItemModel.fromEntity(item);
      await localDataSource.addQRItem(model);
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure('Failed to add QR item: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteQRItem(int index) async {
    try {
      await localDataSource.deleteQRItem(index);
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure('Failed to delete QR item: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, void>> clearAllHistory() async {
    try {
      await localDataSource.clearAllHistory();
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure('Failed to clear history: ${e.toString()}'));
    }
  }
}