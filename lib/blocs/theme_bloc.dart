import 'package:dtt_assessment/constants/constants.dart';
import 'package:dtt_assessment/events/theme_event.dart';
import 'package:dtt_assessment/services/shared_pref_service.dart';
import 'package:dtt_assessment/states/theme_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  final _sharedPrefService = SharedPrefService();
  bool isDarkMode = false;

  ThemeBloc() : super(ThemeInitial()) {
    on<LoadDarkMode>(_onLoadDarkMode);
    on<ToggleDarkMode>(_onToggleDarkMode);
  }

  Future<void> _onLoadDarkMode(
      LoadDarkMode event, Emitter<ThemeState> emit) async {
    isDarkMode = await _sharedPrefService.getBool(Constants.DARKMODE_KEY);
    emit(ThemeLoaded(isDarkMode));
  }

  Future<void> _onToggleDarkMode(
      ToggleDarkMode event, Emitter<ThemeState> emit) async {
    isDarkMode = !isDarkMode;
    await _sharedPrefService.setBool(Constants.DARKMODE_KEY, isDarkMode);
    emit(ThemeLoaded(isDarkMode));
  }
}
