import 'package:bloc/bloc.dart';
import 'package:ditonton/domain/entities/season.dart';
import 'package:meta/meta.dart';

import '../../../common/failure.dart';
import '../../../domain/usecases/get_tv.dart';

part 'season_event.dart';
part 'season_state.dart';

class FetchSeasonBloc extends Bloc<SeasonEvent, FetchSeasonState> {
  final GetTV getMovies;

  FetchSeasonBloc(this.getMovies) : super(FetchSeasonInitial()) {
    on<SeasonEvent>((event, emit) async {
      if (event is FetchSeasonData) {
        emit(FetchSeasonLoading());
        final seasonResult =
            await getMovies.getSeasonDetail(event.seriesId, event.seasonNo);

        if (seasonResult.isLeft()) {
          emit(SeasonError(
              error: DataError(seasonResult
                  .swap()
                  .getOrElse(() => ServerFailure("Unknown"))
                  .message)));
        }
        // All succeeded
        emit(SeasonDetailLoaded(
          season: seasonResult.getOrElse(() => Season()),
        ));
      }
    });
  }
}
