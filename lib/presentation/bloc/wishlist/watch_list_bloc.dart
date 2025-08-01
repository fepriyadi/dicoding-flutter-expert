import 'package:ditonton/common/constants.dart';
import 'package:ditonton/domain/entities/detail_video.dart';
import 'package:ditonton/domain/entities/movie_detail.dart';
import 'package:ditonton/domain/usecases/get_tv.dart';
import 'package:ditonton/domain/usecases/get_watchlist_movies.dart';
import 'package:ditonton/domain/usecases/get_watchlist_status.dart';
import 'package:ditonton/domain/usecases/remove_watchlist.dart';
import 'package:ditonton/domain/usecases/save_watchlist.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/movie.dart';

part 'watch_list_event.dart';
part 'watch_list_state.dart';

class WatchlistBloc extends Bloc<WatchlistEvent, WatchlistState> {
  GetTV getTV;
  GetWatchlistMovies getWatchlistMovies;
  GetWatchListStatus getWatchListStatus;
  SaveWatchlist saveWatchlist;
  RemoveWatchlist removeWatchlist;

  WatchlistBloc(this.getTV, this.saveWatchlist, this.removeWatchlist,
      this.getWatchListStatus, this.getWatchlistMovies)
      : super(WatchlistInitial()) {
    on<AddToWatchlist>((event, emit) async {
      final result;
      if (event.type == ContentType.movie) {
        result = await saveWatchlist.execute(event.movie);
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
      final result = await getWatchlistMovies.execute();
      result.fold(
        (failure) => emit(WatchlistActionFailure(failure.message)),
        (movies) => emit(WatchlistSuccess(movies)),
      );
    });

    on<RemoveFromWatchlist>((event, emit) async {
      final result;
      if (event.type == ContentType.movie) {
        final data = event.movie as MovieDetail;
        result = await removeWatchlist.execute(data);
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
        isAdded = await getWatchListStatus.execute(event.movieId);
      } else {
        isAdded = await getTV.isAddedToWatchlist(event.movieId);
      }
      emit(WatchlistStatus(isAdded));
    });
  }
}
