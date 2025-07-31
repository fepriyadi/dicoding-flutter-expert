import 'package:ditonton/domain/repositories/movie_repository.dart';
import 'package:ditonton/domain/usecases/get_movie.dart';

class GetWatchListStatus extends GetMovies {
  final MovieRepository repository;

  GetWatchListStatus(this.repository);

  Future<bool> execute(int id) async {
    return repository.isAddedToWatchlist(id);
  }
}
