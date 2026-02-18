import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../features/data/datasources/qr_local_datasource.dart';
import '../../features/data/models/qr_item_model.dart';
import '../../features/data/repositories/qr_repository_impl.dart';
import '../../features/domain/repositories/qr_repository.dart';
import '../../features/domain/usecases/add_qr_item.dart';
import '../../features/domain/usecases/clear_all_history.dart';
import '../../features/domain/usecases/delete_qr_item.dart';
import '../../features/domain/usecases/get_history.dart';
import '../../features/domain/usecases/get_keys.dart';
import '../../features/presentation/cubits/history/history_cubit.dart';
import '../../features/presentation/cubits/qr_generator/qr_generator_cubit.dart';
import '../../features/presentation/cubits/qr_scanner/qr_scanner_cubit.dart';
import '../prefs/preferences_service.dart';

final getIt = GetIt.instance;

Future<void> initializeDependencies() async {
  // Shared Preferences
  final sharedPreferences = await SharedPreferences.getInstance();
  getIt.registerLazySingleton(() => sharedPreferences);

  // Services
  getIt.registerLazySingleton(() => PreferencesService(getIt()));

  // Data sources
  getIt.registerLazySingleton<QRLocalDataSource>(
    () => QRLocalDataSourceImpl(Hive.box<QRItemModel>('qr_history')),
  );

  // Repositories
  getIt.registerLazySingleton<QRRepository>(
    () => QRRepositoryImpl(getIt()),
  );

  // Use cases
  getIt.registerLazySingleton(() => AddQRItem(getIt()));
  getIt.registerLazySingleton(() => GetHistory(getIt()));
  getIt.registerLazySingleton(() => DeleteQRItem(getIt()));
  getIt.registerLazySingleton(() => ClearAllHistory(getIt()));
  getIt.registerLazySingleton(() => GetHistoryWithKeys(getIt()));

  // Cubits
  // QRScannerCubit(AddQRItem, GetHistory)  ← 2 params
  getIt.registerFactory(() => QRScannerCubit(getIt(), getIt()));
  // QRGeneratorCubit(AddQRItem, GetHistory) ← 2 params
  getIt.registerFactory(() => QRGeneratorCubit(getIt(), getIt()));
  // HistoryCubit(GetHistoryWithKeys, DeleteQRItem, ClearAllHistory) ← 3 params
  getIt.registerFactory(() => HistoryCubit(getIt(), getIt(), getIt()));
}