part of 'search_bloc.dart';

abstract class SearchEvent extends Equatable {
  const SearchEvent();

  @override
  List<Object> get props => [];
}

class GetPosts extends SearchEvent {}

class SearchUsers extends SearchEvent {
  final String text;
  const SearchUsers(this.text);
  @override
  List<Object> get props => [text];
}
