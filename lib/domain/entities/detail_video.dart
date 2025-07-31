import 'package:ditonton/domain/entities/season.dart';

abstract class DetailVideo {
  String get posterPath;
  String get title;
  int get id;
  String get overview;
  String get releaseDate;
  double get voteAverage;
  List<Season> get seasons;
}
