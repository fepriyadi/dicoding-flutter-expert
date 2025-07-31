part of 'detail_bloc.dart';

@immutable
abstract class DetailEvent {}

class DetailMovieData extends DetailEvent {
  final int id;

  DetailMovieData({required this.id});
}
