import 'package:equatable/equatable.dart';
import 'package:location/location.dart';

abstract class LocationState extends Equatable {
  @override
  List<Object> get props => [];
}

class LocationInitial extends LocationState {}

class LocationLoaded extends LocationState {
  final LocationData locationData;

  LocationLoaded(this.locationData);

  @override
  List<Object> get props => [locationData];
}
