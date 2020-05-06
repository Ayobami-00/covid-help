part of 'stats_bloc.dart';

abstract class StatsState extends Equatable {
  const StatsState();
}

class StatsInitial extends StatsState {
  @override
  List<Object> get props => [];
}

class StatsLoaded extends StatsState {
  final StatsDataModel countryStats;
  final GeneralDataModel generalStats;

  StatsLoaded(this.countryStats, this.generalStats);



  @override
  List<Object> get props => [countryStats,generalStats];
}

class StatsError extends StatsState {
  @override
  // TODO: implement props
  List<Object> get props => null;

}