part of 'viewall_bloc.dart';

@immutable
abstract class ViewAllState {}

class ViewAllInitial extends ViewAllState {}

class ViewAllLoading extends ViewAllState {}

class ViewAllSuccess extends ViewAllState {
  final List<Movie> movies;
  final List<TV> tv;
  ViewAllSuccess(this.movies, this.tv);
}

class ViewAllFailure extends ViewAllState {
  final String error;
  ViewAllFailure(this.error);
}
