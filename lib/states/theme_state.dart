import 'package:equatable/equatable.dart';

abstract class ThemeState extends Equatable {
  @override
  List<Object> get props => [];
}

class ThemeInitial extends ThemeState {}

class ThemeLoaded extends ThemeState {
  final bool isDarkMode;

  ThemeLoaded(this.isDarkMode);

  @override
  List<Object> get props => [isDarkMode];
}
