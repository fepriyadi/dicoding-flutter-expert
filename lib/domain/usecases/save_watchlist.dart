import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/detail_video.dart';
import 'package:ditonton/domain/repositories/movie_repository.dart';
import 'package:ditonton/domain/usecases/get_movie.dart';

class SaveWatchlist extends GetMovies {
  final MovieRepository repository;

  SaveWatchlist(this.repository);

  Future<Either<Failure, String>> execute(DetailVideo movie) {
    return repository.saveWatchlist(movie);
  }
}
