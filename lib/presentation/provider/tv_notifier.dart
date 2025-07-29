import 'package:ditonton/common/constants.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/season.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:flutter/foundation.dart';

import '../../domain/usecases/get_tv.dart';

class TvNotifier extends ChangeNotifier {
  final GetTV getTV;

  TvNotifier(this.getTV);

  RequestState _state = RequestState.Empty;

  RequestState get state => _state;

  RequestState _popularState = RequestState.Empty;

  RequestState get popularState => _popularState;

  RequestState _onAirState = RequestState.Empty;

  RequestState get onAirState => _onAirState;

  RequestState _topRatedState = RequestState.Empty;

  RequestState get topRatedState => _topRatedState;

  RequestState _seasonState = RequestState.Empty;

  RequestState get seasonState => _seasonState;

  RequestState _tvDetailState = RequestState.Empty;

  RequestState get tvDetailState => _tvDetailState;

  List<TV> _tv = [];
  List<TV> _tvPopular = [];
  List<TV> _tvOnAir = [];
  List<TV> _tvTopRated = [];
  TVDetail _tvDetail = TVDetail();
  Season _season = Season();

  List<TV> get series => _tv;

  List<TV> get seriesPopular => _tvPopular;

  List<TV> get seriesOnAir => _tvOnAir;

  List<TV> get seriesTopRated => _tvTopRated;

  Season get seasons => _season;

  TVDetail get tvDetail => _tvDetail;

  String _message = '';

  String get message => _message;

  Future<void> fetchPopularTV() async {
    _popularState = RequestState.Loading;
    notifyListeners();

    final result = await getTV.getTV(TV_POPULAR);

    result.fold(
      (failure) {
        _message = failure.message;
        _popularState = RequestState.Error;
        notifyListeners();
      },
      (tvData) {
        _tvPopular = tvData;
        _popularState = RequestState.Loaded;
        notifyListeners();
      },
    );
  }

  Future<void> fetchOnAirTV() async {
    _onAirState = RequestState.Loading;
    notifyListeners();

    final result = await getTV.getTV(TV_ONAIR);

    result.fold(
      (failure) {
        _message = failure.message;
        _onAirState = RequestState.Error;
        notifyListeners();
      },
      (tvData) {
        _tvOnAir = tvData;
        _onAirState = RequestState.Loaded;
        notifyListeners();
      },
    );
  }

  Future<void> fetchTopRatedTV() async {
    _topRatedState = RequestState.Loading;
    notifyListeners();

    final result = await getTV.getTV(TV_TOPRATED);

    result.fold(
      (failure) {
        _message = failure.message;
        _topRatedState = RequestState.Error;
        notifyListeners();
      },
      (tvData) {
        _tvTopRated = tvData;
        _topRatedState = RequestState.Loaded;
        notifyListeners();
      },
    );
  }

  Future<void> getDetailTV(int id) async {
    _tvDetailState = RequestState.Loading;
    notifyListeners();

    final result = await getTV.getDetail(id);

    result.fold(
      (failure) {
        _message = failure.message;
        _tvDetailState = RequestState.Error;
        notifyListeners();
      },
      (tvData) {
        _tvDetail = tvData;
        _tvDetailState = RequestState.Loaded;
        notifyListeners();
      },
    );
  }

  Future<void> getDetailSeason(int id, int seasonNo) async {
    _seasonState = RequestState.Loading;
    notifyListeners();

    final result = await getTV.getSeasonDetail(id, seasonNo);

    result.fold(
      (failure) {
        _message = failure.message;
        _seasonState = RequestState.Error;
        notifyListeners();
      },
      (season) {
        _season = season;
        _seasonState = RequestState.Loaded;
        notifyListeners();
      },
    );
  }

  Future<void> getRecommendations(int id) async {
    _state = RequestState.Loading;
    notifyListeners();

    final result = await getTV.getRecommendation(id);

    result.fold(
      (failure) {
        _message = failure.message;
        _state = RequestState.Error;
        notifyListeners();
      },
      (tvData) {
        _tv = tvData;
        _state = RequestState.Loaded;
        notifyListeners();
      },
    );
  }

  Future<void> search(String query) async {
    _state = RequestState.Loading;
    notifyListeners();

    final result = await getTV.searchMovie(query);

    result.fold(
      (failure) {
        _message = failure.message;
        _state = RequestState.Error;
        notifyListeners();
      },
      (tvData) {
        _tv = tvData;
        _state = RequestState.Loaded;
        notifyListeners();
      },
    );
  }
}
