import 'package:ditonton/domain/entities/season.dart';
import 'package:equatable/equatable.dart';

abstract class DetailVideo extends Equatable {
  String get posterPath;
  String get title;
  int get id;
  String get overview;
  String get releaseDate;
  double get voteAverage;
  List<Season> get seasons;
}
