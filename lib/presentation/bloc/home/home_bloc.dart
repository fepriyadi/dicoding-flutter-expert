import 'package:bloc/bloc.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/usecases/get_now_playing_movies.dart';
import 'package:ditonton/domain/usecases/get_popular_movies.dart';
import 'package:ditonton/domain/usecases/get_top_rated_movies.dart';
import 'package:meta/meta.dart';

import '../../../common/failure.dart';
import '../../../domain/entities/tv.dart';
import '../../../domain/usecases/get_tv.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final GetTV getTV;
  final GetPopularMovies getPopularMovies;
  final GetNowPlayingMovies getNowPlayingMovies;
  final GetTopRatedMovies getTopRatedMovies;

  HomeBloc(this.getTV, this.getPopularMovies, this.getNowPlayingMovies,
      this.getTopRatedMovies)
      : super(HomeInitial()) {
    on<HomeEvent>((event, emit) async {
      if (event is HomeData) {
        emit(HomeLoading());

        final popular = await getTV.getTV('popular');
        final onair = await getTV.getTV('on_the_air');
        final toprated = await getTV.getTV('top_rated');

        final moviePopular = await getPopularMovies.execute();
        final movieOnair = await getNowPlayingMovies.execute();
        final movieToprated = await getTopRatedMovies.execute();

        if (popular.isLeft()) {
          emit(HomeError(
              error: DataError(popular
                  .swap()
                  .getOrElse(() => ServerFailure("Unknown"))
                  .message)));
        }
        if (onair.isLeft()) {
          emit(HomeError(
              error: DataError(onair
                  .swap()
                  .getOrElse(() => ServerFailure("Unknown"))
                  .message)));
        }
        if (toprated.isLeft()) {
          emit(HomeError(
              error: DataError(toprated
                  .swap()
                  .getOrElse(() => ServerFailure("Unknown"))
                  .message)));
        }

        if (moviePopular.isLeft()) {
          emit(HomeError(
              error: DataError(moviePopular
                  .swap()
                  .getOrElse(() => ServerFailure("Unknown"))
                  .message)));
        }
        if (movieOnair.isLeft()) {
          emit(HomeError(
              error: DataError(movieOnair
                  .swap()
                  .getOrElse(() => ServerFailure("Unknown"))
                  .message)));
        }
        if (movieToprated.isLeft()) {
          emit(HomeError(
              error: DataError(movieToprated
                  .swap()
                  .getOrElse(() => ServerFailure("Unknown"))
                  .message)));
        }

        // All succeeded
        emit(HomeLoaded(
          tranding: popular.getOrElse(() => []),
          upcoming: onair.getOrElse(() => []),
          toprated: toprated.getOrElse(() => []),
          movieNowPlaying: movieOnair.getOrElse(() => []),
          moviePopular: moviePopular.getOrElse(() => []),
          movieTopRated: movieToprated.getOrElse(() => []),
        ));
      }
    });
  }
}
