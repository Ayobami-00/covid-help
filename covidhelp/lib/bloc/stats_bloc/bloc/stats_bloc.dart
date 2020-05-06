import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:covidhelp/models/stats_model.dart';
import 'package:equatable/equatable.dart';
import 'package:covidhelp/models/country_data_model.dart';
import 'package:covidhelp/models/general_data_model.dart';
import 'package:covidhelp/repositories/api_repository.dart';

part 'stats_event.dart';
part 'stats_state.dart';

class StatsBloc extends Bloc<StatsEvent, StatsState> {
  final ApiRepository apiRepository;

  StatsBloc(this.apiRepository);
  @override
  StatsState get initialState => StatsInitial();

    @override
  Stream<StatsState> mapEventToState(StatsEvent event) async* {
    if (event is FetchStats) {
      yield* _mapFetchStatsToState(event);
    } 
  }

  Stream<StatsState> _mapFetchStatsToState(FetchStats event) async* {
    if(event is FetchStats){
      try {
      final countryStats = await apiRepository.getCountryStats(event.countryCode);
      final generalStats = await apiRepository.getAllCountryData();
      //Save current Data as we will need it later
      yield StatsLoaded(countryStats,generalStats);
    } catch (_) {
      yield StatsError();
    }
    }
    
  }
  }

