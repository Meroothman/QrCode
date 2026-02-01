import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:qrcode/%20core/di/injection.dart';
import 'package:qrcode/features/presentation/cubits/qr_generator/qr_generator_cubit.dart' ;
import ' core/prefs/preferences_service.dart';
import 'features/data/models/qr_item_model.dart';
import 'features/presentation/cubits/history/history_cubit.dart';
import 'features/presentation/cubits/qr_scanner/qr_scanner_cubit.dart';
import 'features/presentation/screens/home/main_screen.dart';
import 'features/presentation/screens/onboarding/onboarding_screen.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive
  await Hive.initFlutter();
  Hive.registerAdapter(QRItemModelAdapter());
  await Hive.openBox<QRItemModel>('qr_history');

  // Initialize dependency injection
  await initializeDependencies();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Get preferences service to check onboarding status
    final preferencesService = getIt<PreferencesService>();
    final hasSeenOnboarding = preferencesService.hasSeenOnboarding;

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => getIt<QRScannerCubit>()),
        BlocProvider(create: (_) => getIt<QRGeneratorCubit>()),
        BlocProvider(create: (_) => getIt<HistoryCubit>()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'QR Code App',
        theme: ThemeData(
          brightness: Brightness.dark,
          primarySwatch: Colors.amber,
          scaffoldBackgroundColor: const Color(0xFF333333),
        ),
        // Show MainScreen if user has seen onboarding, else show OnboardingScreen
        home: hasSeenOnboarding ? const MainScreen() : const OnboardingScreen(),
      ),
    );
  }
}