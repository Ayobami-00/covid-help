class GeneralDataModel {
    Result results;
    String stat;

    GeneralDataModel.fromJson(Map<String, dynamic> parsedJson){
      stat = parsedJson['totalResults'];
      results = Result(parsedJson['results'][0]);

    }
    
}

class Result {
    int _totalCases;
    int _totalRecovered;
    int _totalUnresolved;
    int _totalDeaths;
    int _totalNewCasesToday;
    int _totalNewDeathsToday;
    int _totalActiveCases;
    int _totalSeriousCases;
    Source _source;


    Result(Map<String, dynamic> json){
        _totalCases = json["total_cases"] == null ? null : json["total_cases"];
        _totalRecovered = json["total_recovered"] == null ? null : json["total_recovered"];
        _totalUnresolved =json["total_unresolved"] == null ? null : json["total_unresolved"];
        _totalDeaths = json["total_deaths"] == null ? null : json["total_deaths"];
        _totalNewCasesToday = json["total_new_cases_today"] == null ? null : json["total_new_cases_today"];
        _totalNewDeathsToday = json["total_new_deaths_today"] == null ? null : json["total_new_deaths_today"];
        _totalActiveCases = json["total_active_cases"] == null ? null : json["total_active_cases"];
        _totalSeriousCases = json["total_serious_cases"] == null ? null : json["total_serious_cases"];
        _source = json["source"] == null ? null : Source(json["source"]);
    }


    int get totalCases => _totalCases;
    int get totalRecovered =>_totalRecovered;
    int get totalUnresolved => _totalUnresolved;
    int get totalDeaths => _totalDeaths;
    int get totalNewCasesToday =>_totalNewCasesToday;
    int get totalNewDeathsToday =>_totalNewDeathsToday;
    int get toalActiveCases =>_totalActiveCases;
    int get totalSeriousCases =>_totalSeriousCases;
    Source get source => _source;

    
}

class Source {
    String url;

   

     Source(Map<String, dynamic> json){
        url = json["url"] == null ? null : json["url"];
     }

    
}
