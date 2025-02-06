import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class ConnectionCubit extends Cubit<InternetConnectionStatus?> {
  late final StreamSubscription<InternetConnectionStatus> _subscription;
  late final InternetConnectionChecker _checker;

  ConnectionCubit() : super(null) {
    _checker = InternetConnectionChecker.instance;
    _subscription = _checker.onStatusChange.listen((status) {
      emit(status);
    });
  }

  @override
  Future<void> close() {
    _subscription.cancel();
    _checker.dispose();

    return super.close();
  }
}
