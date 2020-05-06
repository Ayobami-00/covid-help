class NewsModel {

  int _totalResults;
  List<Articles> _articles = [];

  NewsModel.fromJson(Map<String, dynamic> parsedJson) {
    print(parsedJson['articles'].length);
    _totalResults = parsedJson['totalResults'];
    List<Articles> temp = [];
    for (int i = 0; i < parsedJson['articles'].length; i++) {
      Articles articles = Articles(parsedJson['articles'][i]);
      temp.add(articles);
    }
    _articles = temp;
  }

  List<Articles> get articles => _articles;
  int get totalResults => _totalResults;


}

class Articles {
  String _author;
  String _title;
  String _description;
  String _url;
  String _urlToImage;
  String _publishedAt;
  String _content;
  String _articleName;
  
 

  Articles(articles) {
    _author = articles['author'];
    _title = articles['title'];
    _description = articles['description'];
    _url = articles['url'];
    _urlToImage = articles['urlToImage'];
    _publishedAt = articles['publishedAt'];
    _content = articles['content'];
    _articleName = articles['source']['name'];

    
  }

  String get author => _author;

  String get title => _title;

  String get description =>_description;

  String get url => _url;

  String get urlToImage => _urlToImage;

  String get publishedAt => _publishedAt;

  String get conten => _content;

  String get articleName => _articleName;



  
}