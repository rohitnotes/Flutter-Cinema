import 'dart:async';
import 'package:cinema_flt/models/service_model.dart';
import 'package:cinema_flt/utils/request_state.dart';
import 'package:flutter/foundation.dart';

import 'package:cinema_flt/models/movie/movies_result.dart';
import 'package:cinema_flt/repository/movie_repository.dart';

class HomeBloc {
  final MovieRepository _movieRepository;

  // movie controller
  final _upcomingController = StreamController<MoviesResult>.broadcast();
  final _populerController = StreamController<MoviesResult>.broadcast();
  final _trendingController = StreamController<MoviesResult>.broadcast();

  // state controller
  final _statePopuler = StreamController<UiState>.broadcast();

  // state output
  Stream<UiState> get statePopuler => _statePopuler.stream;

  // output
  Stream<MoviesResult> get upcomingMovies => _upcomingController.stream;
  Stream<MoviesResult> get populerMovies => _populerController.stream;
  Stream<MoviesResult> get trendingMovies => _trendingController.stream;
  
  Function(UiState) get setStatePopuler => _statePopuler.sink.add;

  HomeBloc({@required movieRepository}) : _movieRepository = movieRepository;

  void getAllCategoryMovie() {
    getUpcomingMovie(1);
    getPopulerMovie(1);
    getTrendingMovie(1);
  }

  void getUpcomingMovie([int page = 1]) async {
    try {
      setStatePopuler(UiState(RequestState.LOADING));
      ServiceModel result = await _movieRepository.getUpcomingMovie(page);
      if (result.isSuccess) {
        _upcomingController.sink.add(result.data);
      }
      setStatePopuler(UiState(RequestState.DONE));
    } catch (err) {
      print('Error Upcoming : ${err.toString()}');
      setStatePopuler(UiState(RequestState.ERROR));
    }
  }

  void getPopulerMovie([int page = 1]) async {
    try {
      ServiceModel result = await _movieRepository.getPopulerMovie(page);
      _populerController.sink.add(result.data);
    } catch (err) {
      print('Error Populer : ${err.toString()}');
    }
  }

  void getTrendingMovie([int page = 1]) async {
    try {
      ServiceModel result = await _movieRepository.getTrendingMovie(page);
      _trendingController.sink.add(result.data);
    } catch (err) {
      print('Error : ${err.toString()}');
    }
  }

  void dispose() {
    _upcomingController.close();
    _populerController.close();
    _trendingController.close();
    _statePopuler.close();
  }
}
