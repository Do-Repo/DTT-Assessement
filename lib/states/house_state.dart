import 'package:dtt_assessment/models/house_model.dart';
import 'package:equatable/equatable.dart';

abstract class HouseState extends Equatable {
  @override
  List<Object> get props => [];
}

class HouseInitial extends HouseState {}

class HouseLoading extends HouseState {}

class HouseLoaded extends HouseState {
  final List<HouseModel> houses;

  HouseLoaded({required this.houses});

  @override
  List<Object> get props => [houses];
}

class HouseError extends HouseState {
  final String message;

  HouseError({required this.message});

  @override
  List<Object> get props => [message];
}
