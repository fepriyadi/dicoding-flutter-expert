import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../../common/failure.dart';
import '../../../domain/entities/tv.dart';
import '../../../domain/usecases/get_tv.dart';

part 'detail_event.dart';
part 'detail_state.dart';

class DetailTVBloc extends Bloc<DetailEvent, DetailState> {
  final GetTV getTV;

  DetailTVBloc(this.getTV) : super(DetailInitial()) {
    on<DetailEvent>((event, emit) async {
      if (event is DetailData) {
        emit(DetailLoading());
        final detailResult = await getTV.getDetail(event.id);
        final recommendationResult = await getTV.getRecommendation(event.id);

        if (detailResult.isLeft()) {
          emit(DetailError(
              error: DataError(detailResult
                  .swap()
                  .getOrElse(() => ServerFailure("Unknown"))
                  .message)));
        }
        if (recommendationResult.isLeft()) {
          emit(DetailError(
              error: DataError(recommendationResult
                  .swap()
                  .getOrElse(() => ServerFailure("Unknown"))
                  .message)));
        }
        // All succeeded
        emit(DetailLoaded(
            detail: detailResult.getOrElse(() => TVDetail()),
            recommendation: recommendationResult.getOrElse(() => [])));
      }
    });
  }
}
