import 'package:equatable/equatable.dart';

abstract class BookmarkState extends Equatable {
  @override
  List<Object> get props => [];
}

class BookmarkInitial extends BookmarkState {}

class BookmarkLoaded extends BookmarkState {
  final List<int> bookmarkedHouses;

  BookmarkLoaded(this.bookmarkedHouses);

  @override
  List<Object> get props => [bookmarkedHouses];
}
