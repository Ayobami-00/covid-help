part of 'news_bloc.dart';

abstract class NewsEvent extends Equatable {
  const NewsEvent();
}

class FetchNews extends NewsEvent {
  // final String countryCode;

  // FetchNews(this.countryCode);
  @override
  List<Object> get props => [];
}