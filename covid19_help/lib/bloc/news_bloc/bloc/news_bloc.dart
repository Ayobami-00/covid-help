import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:covid19_help/models/country_data_model.dart';
import 'package:covid19_help/repositories/api_repository.dart';
import 'package:firebase_database/firebase_database.dart';

part 'news_event.dart';
part 'news_state.dart';

class NewsBloc extends Bloc<NewsEvent, NewsState> {
  final ApiRepository apiRepository;

  NewsBloc(this.apiRepository);
  @override
  NewsState get initialState => NewsLoading();

  @override
  Stream<NewsState> mapEventToState(NewsEvent event) async* {
    if (event is FetchNews) {
      yield* _mapFetchNewsToState(event);
    }
  }

  Stream<NewsState> _mapFetchNewsToState(FetchNews event) async* {
    if (event is FetchNews) {
      try {
        var _firebaseRef = FirebaseDatabase().reference();
        var center_news = await _firebaseRef.child('center_news').once().then((data) {
          return data.value;
        });
        var news_data = await _firebaseRef.child('news').once().then((data) {
          return data.value;
        });
        print(news_data[1]);
        Map a = center_news;
        String headline = a['Headline'];
        String url = a['image'];
        String goto = a['goto'];
        // print(a);
        // final news = await apiRepository.getCountryNews(event.countryCode);
        // print(news.countryNewsItems.length);
        //Save current Data as we will need it later
        yield NewsLoaded(news_data,headline,url,goto);
      } catch (_) {
        yield NewsError();
      }
    }
  }
}
