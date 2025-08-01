import 'package:bloc/bloc.dart';
import 'package:ditonton/domain/usecases/search_movies.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../../common/failure.dart';
import '../../../domain/entities/movie.dart';
import '../../../domain/entities/tv.dart';
import '../../../domain/usecases/get_tv.dart';

part 'search_event.dart';
part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final GetTV getTv;
  final SearchMovies searchMovies;

  SearchBloc(this.getTv, this.searchMovies) : super(SearchInitial()) {
    on<SearchEvent>((event, emit) async {
      if (event is SearchData) {
        emit(SearchLoading());
        final searchTVResult = await getTv.searchMovie(event.query);
        final searchMovieResult = await searchMovies.execute(event.query);

        if (searchTVResult.isLeft()) {
          emit(SearchError(
              error: DataError(searchTVResult
                  .swap()
                  .getOrElse(() => ServerFailure("Unknown"))
                  .message)));
        }
        if (searchTVResult.isLeft()) {
          emit(SearchError(
              error: DataError(searchTVResult
                  .swap()
                  .getOrElse(() => ServerFailure("Unknown"))
                  .message)));
        }
        // All succeeded
        emit(SearchLoaded(
          movies: searchMovieResult.getOrElse(() => []),
          tv: searchTVResult.getOrElse(() => []),
        ));
      }
    });
  }
}
