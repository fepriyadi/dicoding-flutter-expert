import 'package:bloc/bloc.dart';
import 'package:ditonton/domain/entities/movie_detail.dart';
import 'package:meta/meta.dart';

import '../../../common/failure.dart';
import '../../../domain/entities/movie.dart';
import '../../../domain/usecases/get_movie_detail.dart';
import '../../../domain/usecases/get_movie_recommendations.dart';

part 'detail_event.dart';
part 'detail_state.dart';

class DetailMovieBloc extends Bloc<DetailEvent, DetailMovieState> {
  final GetMovieDetail getMovieDetail;
  final GetMovieRecommendations getMovieRecommendations;

  DetailMovieBloc(this.getMovieDetail, this.getMovieRecommendations)
      : super(DetailMovieInitial()) {
    on<DetailEvent>((event, emit) async {
      if (event is DetailMovieData) {
        emit(DetailMovieLoading());
        final detailResult = await getMovieDetail.execute(event.id);
        final recommendationsResult =
            await getMovieRecommendations.execute(event.id);

        if (detailResult.isLeft()) {
          emit(DetailMovieError(
              error: DataError(detailResult
                  .swap()
                  .getOrElse(() => ServerFailure("Unknown"))
                  .message)));
        }
        if (recommendationsResult.isLeft()) {
          emit(DetailMovieError(
              error: DataError(detailResult
                  .swap()
                  .getOrElse(() => ServerFailure("Unknown"))
                  .message)));
        }
        // All succeeded
        emit(DetailMovieLoaded(
            detail: detailResult.getOrElse(() => MovieDetail()),
            recommendations: recommendationsResult.getOrElse(() => [])));
      }
    });
  }
}
