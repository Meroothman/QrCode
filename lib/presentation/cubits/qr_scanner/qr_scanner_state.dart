part of 'qr_scanner_cubit.dart';

abstract class QRScannerState extends Equatable {
  const QRScannerState();

  @override
  List<Object?> get props => [];
}

class QRScannerInitial extends QRScannerState {
  const QRScannerInitial();
}

class QRScannerProcessing extends QRScannerState {
  const QRScannerProcessing();
}

class QRScannerSuccess extends QRScannerState {
  final String code;

  const QRScannerSuccess(this.code);

  @override
  List<Object?> get props => [code];
}

class QRScannerError extends QRScannerState {
  final String message;

  const QRScannerError(this.message);

  @override
  List<Object?> get props => [message];
}