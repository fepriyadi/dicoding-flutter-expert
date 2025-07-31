import 'package:ditonton/common/constants.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/domain/usecases/get_movie.dart';
import 'package:ditonton/domain/usecases/get_tv.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/movie.dart';

part 'viewall_event.dart';
part 'viewall_state.dart';

class ViewAllBloc extends Bloc<ViewAllEvent, ViewAllState> {
  final GetTV getTV;
  final GetMovies getMovies;

  ViewAllBloc(this.getTV, this.getMovies) : super(ViewAllInitial()) {
    on<FetchCategoryItems>((event, emit) async {
      emit(ViewAllLoading());
      final result;

      if (event.type == ContentType.movie) {
        switch (event.categoryType) {
          case CategoryType.popular:
            result = await getMovies.repository.getPopularMovies();
            break;
          case CategoryType.topRated:
            result = await getMovies.repository.getTopRatedMovies();
            break;
          case CategoryType.onair:
            result = await getMovies.repository.getNowPlayingMovies();
            break;
        }
      } else {
        switch (event.categoryType) {
          case CategoryType.popular:
            result = await getTV.getTV(TV_POPULAR);
            break;
          case CategoryType.topRated:
            result = await getTV.getTV(TV_TOPRATED);
            break;
          case CategoryType.onair:
            result = await getTV.getTV(TV_ONAIR);
            break;
        }
      }
      result.fold(
        (failure) => emit(ViewAllFailure(failure.message)),
        (videos) {
          if (event.type == ContentType.movie)
            emit(ViewAllSuccess(videos, []));
          else
            emit(ViewAllSuccess([], videos));
        },
      );
    });
  }
}
