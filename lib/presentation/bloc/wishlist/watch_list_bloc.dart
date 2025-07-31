import 'package:ditonton/common/constants.dart';
import 'package:ditonton/domain/entities/detail_video.dart';
import 'package:ditonton/domain/usecases/get_movie.dart';
import 'package:ditonton/domain/usecases/get_tv.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/movie.dart';

part 'watch_list_event.dart';
part 'watch_list_state.dart';

class WatchlistBloc extends Bloc<WatchlistEvent, WatchlistState> {
  GetTV getTV;
  GetMovies getMovies;

  WatchlistBloc(this.getTV, this.getMovies) : super(WatchlistInitial()) {
    on<AddToWatchlist>((event, emit) async {
      final result;
      if (event.type == ContentType.movie) {
        result = await getMovies.repository.saveWatchlist(event.movie);
      } else {
        result = await getTV.saveWatchlist(event.movie);
      }
      result.fold(
        (failure) => emit(WatchlistActionFailure(failure.message)),
        (message) {
          emit(WatchlistActionSuccess(message));
          emit(WatchlistStatus(true));
        },
      );
    });

    on<GetAllWatchlist>((event, emit) async {
      final result = await getMovies.repository.getWatchlistMovies();
      result.fold(
        (failure) => emit(WatchlistActionFailure(failure.message)),
        (movies) => emit(WatchlistSuccess(movies)),
      );
    });

    on<RemoveFromWatchlist>((event, emit) async {
      final result;
      if (event.type == ContentType.movie) {
        result = await getMovies.repository.removeWatchlist(event.movie);
      } else {
        result = await getTV.removeWatchlist(event.movie);
      }
      result.fold(
        (failure) => emit(WatchlistActionFailure(failure.message)),
        (message) {
          emit(WatchlistActionSuccess(message));
          emit(WatchlistStatus(false));
        },
      );
    });

    on<CheckWatchlistStatus>((event, emit) async {
      final isAdded;
      if (event.type == ContentType.movie) {
        isAdded = await getMovies.repository.isAddedToWatchlist(event.movieId);
      } else {
        isAdded = await getTV.isAddedToWatchlist(event.movieId);
      }
      emit(WatchlistStatus(isAdded));
    });
  }
}
