import 'package:equatable/equatable.dart';

abstract class BookmarkEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LoadBookmarks extends BookmarkEvent {}

class ToggleBookmark extends BookmarkEvent {
  final int houseId;

  ToggleBookmark({required this.houseId});
}
