class CountryDataModel {
  List<CountryStats> countryStats;
  List<NewsItem> countryNewsItems;

  CountryDataModel.fromJson(Map<String, dynamic> parsedJson) {
    try {
      List<CountryStats> temp = [];
      temp.add(CountryStats(parsedJson['countrydata'][0]));
      countryStats = temp;

      List<NewsItem> temp2 = [];
      for (int i = 1; i < parsedJson['countrynewsitems'][0].length; i++) {
        temp2.add(NewsItem(parsedJson['countrynewsitems'][0][i.toString()]));
      }
      countryNewsItems = temp2;
    } catch (_) {
      
    }
  }
}

class CountryStats {
  Info _info;
  int _totalCases;
  int _totalRecovered;
  int _totalUnresolved;
  int _totalDeaths;
  int _totalNewCasesToday;
  int _totalNewDeathsToday;
  int _totalActiveCases;
  int _totalSeriousCases;

  CountryStats(json) {
    _info = json["info"] == null ? null : Info(json["info"]);
    _totalCases = json["total_cases"] == null ? null : json["total_cases"];
    _totalRecovered =
        json["total_recovered"] == null ? null : json["total_recovered"];
    _totalUnresolved =
        json["total_unresolved"] == null ? null : json["total_unresolved"];
    _totalDeaths = json["total_deaths"] == null ? null : json["total_deaths"];
    _totalNewCasesToday = json["total_new_cases_today"] == null
        ? null
        : json["total_new_cases_today"];
    _totalNewDeathsToday = json["total_new_deaths_today"] == null
        ? null
        : json["total_new_deaths_today"];
    _totalActiveCases =
        json["total_active_cases"] == null ? null : json["total_active_cases"];
    _totalSeriousCases = json["total_serious_cases"] == null
        ? null
        : json["total_serious_cases"];
  }

  Info get info => _info;

  int get totalCases => _totalCases;

  int get totalRecovered => _totalRecovered;

  int get totalUnresolved => _totalUnresolved;

  int get totalDeaths => _totalDeaths;

  int get totalNewCasesToday => _totalNewCasesToday;

  int get totalNewDeathsToday => _totalNewDeathsToday;

  int get totalActiveCases => _totalActiveCases;

  int get totalSeriousCases => _totalSeriousCases;
}

class Info {
  int _ourid;
  String _title;
  String _code;
  String _source;

  Info(json) {
    _ourid = json["ourid"] == null ? null : json["ourid"];
    _title = json["title"] == null ? null : json["title"];
    _code = json["code"] == null ? null : json["code"];
    _source = json["source"] == null ? null : json["source"];
  }

  int get ourid => _ourid;
  String get title => _title;
  String get code => _code;
  String get source => _source;
}

class NewsItem {
  String _newsid;
  String _title;
  String _image;
  String _time;
  String _url;

  NewsItem(json) {
    _newsid = json["newsid"] == null ? null : json["newsid"];
    _title = json["title"] == null ? null : json["title"];
    _image = json["image"] == null ? null : json["image"];
    _time = json["time"] == null ? null : json["time"];
    _url = json["url"] == null ? null : json["url"];
  }

  String get newsid => _newsid;
  String get title => _title;
  String get image => _image;
  String get time => _time;
  String get url => _url;
}
