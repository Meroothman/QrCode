# QR Code App - Clean Architecture

A professional Flutter QR code scanner and generator app built with Clean Architecture principles and BLoC state management.

## 🏗️ Architecture

This project follows **Clean Architecture** with three main layers:

### 1. Domain Layer (Business Logic)
- **Entities**: Core business objects (`QRItem`)
- **Repositories**: Abstract interfaces defining data operations
- **Use Cases**: Single-responsibility business logic operations
  - `AddQRItem`: Add a new QR item to history
  - `GetHistory`: Retrieve all history items
  - `DeleteQRItem`: Remove a specific item
  - `ClearAllHistory`: Clear all items

### 2. Data Layer
- **Models**: Data transfer objects with Hive annotations
- **Data Sources**: Local data source implementation using Hive
- **Repository Implementation**: Concrete implementation of domain repositories

### 3. Presentation Layer (UI)
- **Cubits**: State management using BLoC pattern
  - `QRScannerCubit`: Manages QR scanning state
  - `QRGeneratorCubit`: Manages QR generation state
  - `HistoryCubit`: Manages history state with filtering
- **Screens**: Feature-based screen organization
- **Widgets**: Reusable UI components

## 📁 Project Structure

```
lib/
├── core/
│   ├── constants/
│   │   └── app_constants.dart          # Colors, strings, constants
│   ├── di/
│   │   └── injection.dart              # Dependency injection setup
│   ├── error/
│   │   └── failures.dart               # Error handling classes
│   └── utils/
│       └── utils.dart                  # Validation & formatting utilities
│
├── data/
│   ├── datasources/
│   │   └── qr_local_datasource.dart    # Hive operations
│   ├── models/
│   │   ├── qr_item_model.dart          # Hive model
│   │   └── qr_item_model.g.dart        # Generated Hive adapter
│   └── repositories/
│       └── qr_repository_impl.dart     # Repository implementation
│
├── domain/
│   ├── entities/
│   │   └── qr_item.dart                # Domain entity
│   ├── repositories/
│   │   └── qr_repository.dart          # Repository interface
│   └── usecases/
│       ├── add_qr_item.dart
│       ├── get_history.dart
│       ├── delete_qr_item.dart
│       └── clear_all_history.dart
│
├── presentation/
│   ├── cubits/
│   │   ├── history/
│   │   │   ├── history_cubit.dart
│   │   │   └── history_state.dart
│   │   ├── qr_generator/
│   │   │   ├── qr_generator_cubit.dart
│   │   │   └── qr_generator_state.dart
│   │   └── qr_scanner/
│   │       ├── qr_scanner_cubit.dart
│   │       └── qr_scanner_state.dart
│   ├── screens/
│   │   ├── generator/
│   │   │   └── qr_generator_screen.dart
│   │   ├── history/
│   │   │   └── history_screen.dart
│   │   ├── home/
│   │   │   └── main_screen.dart
│   │   ├── onboarding/
│   │   │   └── onboarding_screen.dart
│   │   └── scanner/
│   │       └── qr_scanner_screen.dart
│   └── widgets/
│       ├── history/
│       │   ├── detail_dialog.dart
│       │   ├── filter_tabs_widget.dart
│       │   ├── history_item_widget.dart
│       │   └── qr_code_dialog.dart
│       └── scanner/
│           └── scan_result_dialog.dart
│
└── main.dart                           # App entry point
```

## ✨ Features

- ✅ **QR Code Scanner**: Real-time QR code scanning with camera
- ✅ **QR Code Generator**: Generate QR codes from text
- ✅ **History Management**: Track scanned and generated QR codes
- ✅ **Link Detection**: Automatically detect and open URLs
- ✅ **Share Functionality**: Share generated QR codes
- ✅ **Filter System**: Filter history by scan or generate type
- ✅ **Error Handling**: Comprehensive error handling with user feedback
- ✅ **Clean Architecture**: Maintainable and testable codebase

## 🚀 Getting Started

### Prerequisites

- Flutter SDK (3.0.0 or higher)
- Dart SDK (3.0.0 or higher)

### Installation

1. **Clone the repository** (or copy the files)

2. **Install dependencies**:
```bash
flutter pub get
```

3. **Generate Hive adapters** (if not already generated):
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

4. **Run the app**:
```bash
flutter run
```

### Platform-Specific Setup

#### Android
Add camera permission to `android/app/src/main/AndroidManifest.xml`:
```xml
<uses-permission android:name="android.permission.CAMERA" />
<uses-feature android:name="android.hardware.camera" />
<uses-feature android:name="android.hardware.camera.autofocus" />
```

#### iOS
Add camera permission to `ios/Runner/Info.plist`:
```xml
<key>NSCameraUsageDescription</key>
<string>This app needs camera access to scan QR codes</string>
```

## 🏛️ Architecture Principles

### Dependency Rule
Dependencies only point inward. Domain layer has no dependencies on outer layers.

### Single Responsibility
Each class has one reason to change. Use cases are single-purpose.

### Dependency Injection
Using `get_it` for dependency management, making the code testable and maintainable.

### State Management
Using `flutter_bloc` (Cubit) for predictable state management:
- Clear separation between UI and business logic
- Easy to test
- Stream-based state updates

## 📦 Key Dependencies

- **flutter_bloc**: State management
- **equatable**: Value equality for states
- **get_it**: Dependency injection
- **dartz**: Functional programming (Either for error handling)
- **hive**: Local database
- **mobile_scanner**: QR code scanning
- **qr_flutter**: QR code generation
- **share_plus**: Share functionality
- **url_launcher**: Open URLs

## 🎯 Key Improvements Over Original Code

1. **Clean Architecture**: Proper separation of concerns
2. **State Management**: BLoC pattern instead of setState
3. **Error Handling**: Proper error states and user feedback
4. **Dependency Injection**: Testable and maintainable code
5. **Type Safety**: Strong typing with domain entities
6. **Code Organization**: Feature-based structure
7. **Reusability**: Modular widgets and utilities
8. **Performance**: Better state management and widget lifecycle
9. **Maintainability**: SOLID principles applied
10. **Scalability**: Easy to add new features

## 🐛 Bug Fixes

- Fixed scanner not restarting after scan
- Proper state management to prevent multiple scans
- Better error handling in all operations
- Fixed memory leaks with proper disposal
- Improved URL validation
- Better date formatting

## 🧪 Testing

The architecture makes it easy to test each layer independently:

```dart
// Example: Testing a use case
test('AddQRItem should add item to repository', () async {
  // Arrange
  final mockRepository = MockQRRepository();
  final useCase = AddQRItem(mockRepository);
  final item = QRItem(...);
  
  // Act
  final result = await useCase(item);
  
  // Assert
  expect(result, isA<Right>());
  verify(mockRepository.addQRItem(item));
});
```

## 🔄 Future Enhancements

- [ ] Image picker for scanning from gallery
- [ ] Export history to CSV/JSON
- [ ] QR code customization (colors, logo)
- [ ] Batch QR code generation
- [ ] Cloud sync
- [ ] Dark/Light theme toggle
- [ ] Multiple QR code formats support

## 📝 Notes

- The app uses Hive for local storage (lightweight and fast)
- All states are immutable using Equatable
- Error handling uses Either type from dartz
- URL launching is handled with proper error states
- The scanner automatically restarts after successful scan

## 🤝 Contributing

When adding new features, follow the Clean Architecture principles:

1. Start with domain layer (entities, use cases)
2. Implement data layer (models, data sources, repositories)
3. Create presentation layer (cubits, screens, widgets)
4. Add to dependency injection
5. Write tests

## 📄 License

This project is open source and available under the MIT License.

## 👤 Author

Refactored to Clean Architecture with BLoC pattern for better maintainability and scalability.