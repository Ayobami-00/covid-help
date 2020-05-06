part of 'news_bloc.dart';

abstract class NewsState extends Equatable {
  const NewsState();
}

class NewsEmpty extends NewsState {
  @override
  // TODO: implement props
  List<Object> get props => null;

}

class NewsLoading extends NewsState {
  @override
  // TODO: implement props
  List<Object> get props => null;

}
class NewsLoaded extends NewsState {
  // final CountryDataModel news;
  final news_data;
  final String headline;
  final String url;
  final String goto;

  NewsLoaded(this.news_data, this.headline, this.url, this.goto);



  @override
  List<Object> get props => [];
}

class NewsError extends NewsState {
  @override
  // TODO: implement props
  List<Object> get props => null;

}