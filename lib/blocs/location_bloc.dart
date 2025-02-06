import 'package:dtt_assessment/events/location_event.dart';
import 'package:dtt_assessment/states/location_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:location/location.dart';

class LocationBloc extends Bloc<LocationEvent, LocationState> {
  LocationData? locationData;

  LocationBloc() : super(LocationInitial()) {
    on<LoadLocation>(_onLoadLocation);
  }

  Future<void> _onLoadLocation(
      LoadLocation event, Emitter<LocationState> emit) async {
    Location location = Location();

    bool serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    PermissionStatus permissionStatus = await location.hasPermission();
    if (permissionStatus == PermissionStatus.denied) {
      permissionStatus = await location.requestPermission();
      if (permissionStatus != PermissionStatus.granted ||
          permissionStatus != PermissionStatus.grantedLimited) {
        return;
      }
    }

    locationData = await location.getLocation();
    emit(LocationLoaded(locationData!));
  }
}
