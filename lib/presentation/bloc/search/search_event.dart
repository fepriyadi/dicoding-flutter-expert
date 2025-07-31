part of 'search_bloc.dart';

@immutable
abstract class SearchEvent {}

class SearchData extends SearchEvent {
  final String query;

  SearchData({required this.query});
}
