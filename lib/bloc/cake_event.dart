import 'package:equatable/equatable.dart';

abstract class CakeEvent extends Equatable {
  const CakeEvent();

  @override
  List<Object> get props => [];
}

class FetchCakes extends CakeEvent {}
