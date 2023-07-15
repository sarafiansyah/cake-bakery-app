import 'package:equatable/equatable.dart';
import 'package:ralali_bakery/models/cake_model.dart';

abstract class CakeState extends Equatable {
  const CakeState();

  @override
  List<Object> get props => [];
}

class CakeInitial extends CakeState {}

class CakeLoading extends CakeState {}

class CakeLoaded extends CakeState {
  final List<CakeModel> cakes;

  const CakeLoaded({required this.cakes});

  @override
  List<Object> get props => [cakes];
}

class CakeError extends CakeState {
  final String error;

  const CakeError({required this.error});

  @override
  List<Object> get props => [error];
}
