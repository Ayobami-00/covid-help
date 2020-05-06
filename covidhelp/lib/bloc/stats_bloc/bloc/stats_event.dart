part of 'stats_bloc.dart';

abstract class StatsEvent extends Equatable {
  const StatsEvent();
}

class FetchStats extends StatsEvent {
  final String countryCode;

  FetchStats(this.countryCode);

  @override
  List<Object> get props => [];
}
