part of 'qr_generator_cubit.dart';

abstract class QRGeneratorState extends Equatable {
  const QRGeneratorState();

  @override
  List<Object?> get props => [];
}

class QRGeneratorInitial extends QRGeneratorState {
  const QRGeneratorInitial();
}

class QRGeneratorLoading extends QRGeneratorState {
  const QRGeneratorLoading();
}

class QRGeneratorSuccess extends QRGeneratorState {
  final String content;

  const QRGeneratorSuccess(this.content);

  @override
  List<Object?> get props => [content];
}

class QRGeneratorError extends QRGeneratorState {
  final String message;

  const QRGeneratorError(this.message);

  @override
  List<Object?> get props => [message];
}