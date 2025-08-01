part of 'viewall_bloc.dart';

@immutable
abstract class ViewAllState extends Equatable {}

class ViewAllInitial extends ViewAllState {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class ViewAllLoading extends ViewAllState {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class ViewAllSuccess extends ViewAllState {
  final List<Movie> movies;
  final List<TV> tv;
  ViewAllSuccess(this.movies, this.tv);

  @override
  // TODO: implement props
  List<Object?> get props => [tv, movies];
}

class ViewAllFailure extends ViewAllState {
  final String error;
  ViewAllFailure(this.error);

  @override
  // TODO: implement props
  List<Object?> get props => [error];
}
