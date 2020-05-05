import 'dart:async';
import 'dart:math';

import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_search_panel/flutter_search_panel.dart';
// import 'package:flutter_search_panel/search_item.dart';
import 'package:covid19_help/bloc/news_bloc/bloc/news_bloc.dart';
import 'package:covid19_help/models/ncovid_data.dart';
import 'package:covid19_help/models/country_data_model.dart';
import 'package:covid19_help/models/newsModel.dart';
import 'package:covid19_help/models/serializers.dart';
import 'package:covid19_help/utils/hex_colour.dart';
import 'package:covid19_help/widgets/loading.dart';
import 'package:url_launcher/url_launcher.dart';

class NewsPage extends StatefulWidget {
  @override
  _NewsPageState createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  String _now;
  Timer _everySecond;
  String _newsTitle = "Amazing Places in America";
  String _newsDescr =
      "For Some reason- this country, this city, this neighbourhood, this particular street...";
  String _selectedValue = 'Afghanistan';

  List<String> _countryList = [
    "Afghanistan",
    "Albania",
    "Algeria",
    "Angola",
    "Argentina",
    "Armenia",
    "Australia",
    "Austria",
    "Azerbaijan",
    "Bahamas",
    "Bangladesh",
    "Belarus",
    "Belgium",
    "Belize",
    "Benin",
    "Bhuta",
    "Bolivia",
    "Bosnia and Herzegovina",
    "Botswana",
    "Brazil",
    "Brunei Darussalam",
    "Bulgaria",
    "Burkina Faso",
    "Burundi",
    "Cambodia",
    "Cameroon",
    "Canada",
    "Ivory Coast",
    "Central African Republic",
    "Chad",
    "Chile",
    "China",
    "Colombia",
    "Congo",
    "Democratic Republic of Congo",
    "Costa Rica",
    "Croatia",
    "Cuba",
    "Cyprus",
    "Czech Republic",
    "Denmark",
    "Diamond Princess",
    "Djibouti",
    "Dominican Republic",
    "DR Congo",
    "Ecuador",
    "Egypt",
    "El Salvador",
    "Equatorial Guinea",
    "Eritrea",
    "Estonia",
    "Ethiopia",
    "Falkland Islands",
    "Fiji",
    "Finland",
    "France",
    "French Guiana",
    "French Southern Territories",
    "Gabon",
    "Gambia",
    "Georgia",
    "Germany",
    "Ghana",
    "Greece",
    "Greenland",
    "Guatemala",
    "Guinea",
    "Guinea-Bissau",
    "Guyana",
    "Haiti",
    "Honduras",
    "Hong Kong",
    "Hungary",
    "Iceland",
    "India",
    "Indonesia",
    "Iran",
    "Iraq",
    "Ireland",
    "Israel",
    "Italy",
    "Jamaica",
    "Japan",
    "Jordan",
    "Kazakhstan",
    "Kenya",
    "Korea",
    "Kosovo",
    "Kuwait",
    "Kyrgyzstan",
    "Lao",
    "Latvia",
    "Lebanon",
    "Lesotho",
    "Liberia",
    "Libya",
    "Lithuania",
    "Luxembourg",
    "Macedonia",
    "Madagascar",
    "Malawi",
    "Malaysia",
    "Mali",
    "Mauritania",
    "Mexico",
    "Moldova",
    "Mongolia",
    "Montenegro",
    "Morocco",
    "Mozambique",
    "Myanmar",
    "Namibia",
    "Nepal",
    "Netherlands",
    "New Caledonia",
    "New Zealand",
    "Nicaragua",
    "Niger",
    "Nigeria",
    "North Korea",
    "Norway",
    "Oman",
    "Pakistan",
    "Palestine",
    "Panama",
    "Papua New Guinea",
    "Paraguay",
    "Peru",
    "Philippines",
    "Poland",
    "Portugal",
    "Puerto Rico",
    "Qatar",
    "Republic of Kosovo",
    "Romania",
    "Russia",
    "Rwanda",
    "Saudi Arabia",
    "Senegal",
    "Serbia",
    "Sierra Leone",
    "Singapore",
    "Slovakia",
    "Slovenia",
    "Solomon Islands",
    "Somalia",
    "South Africa",
    "South Korea",
    "South Sudan",
    "Spain",
    "Sri Lanka",
    "Sudan",
    "Suriname",
    "Svalbard and Jan Mayen",
    "Swaziland",
    "Sweden",
    "Switzerland",
    "Syrian Arab Republic",
    "Taiwan",
    "Tajikistan",
    "Tanzania",
    "Thailand",
    "Timor-Leste",
    "Togo",
    "Trinidad and Tobago",
    "Tunisia",
    "Turkey",
    "Turkmenistan",
    "UAE",
    "Uganda",
    "United Kingdom",
    "Ukraine",
    "USA",
    "Uruguay",
    "Uzbekistan",
    "Vanuatu",
    "Venezuela",
    "Vietnam",
    "Western Sahara",
    "Yemen",
    "Zambia",
    "Zimbabwe",
  ];
  Map<String, String> _countryMap = {
    "Afghanistan": "AF",
    "Albania": "AL",
    "Algeria": "DZ",
    "Angola": "AO",
    "Argentina": "AR",
    "Armenia": "AM",
    "Australia": "AU",
    "Austria": "AT",
    "Azerbaijan": "AZ",
    "Bahamas": "BS",
    "Bangladesh": "BD",
    "Belarus": "BY",
    "Belgium": "BE",
    "Belize": "BZ",
    "Benin": "BJ",
    "Bhuta": "BT",
    "Bolivia": "BO",
    "Bosnia and Herzegovina": "BA",
    "Botswana": "BW",
    "Brazil": "BR",
    "Brunei Darussalam": "BN",
    "Bulgaria": "BG",
    "Burkina Faso": "BF",
    "Burundi": "BI",
    "Cambodia": "KH",
    "Cameroon": "CM",
    "Canada": "CA",
    "Ivory Coast": "CI",
    "Central African Republic": "CF",
    "Chad": "TD",
    "Chile": "CL",
    "China": "CN",
    "Colombia": "CO",
    "Congo": "CG",
    "Democratic Republic of Congo": "CD",
    "Costa Rica": "CR",
    "Croatia": "HR",
    "Cuba": "CU",
    "Cyprus": "CY",
    "Czech Republic": "CZ",
    "Denmark": "DK",
    "Diamond Princess": "DP",
    "Djibouti": "DJ",
    "Dominican Republic": "DO",
    "DR Congo": "CD",
    "Ecuador": "EC",
    "Egypt": "EG",
    "El Salvador": "SV",
    "Equatorial Guinea": "GQ",
    "Eritrea": "ER",
    "Estonia": "EE",
    "Ethiopia": "ET",
    "Falkland Islands": "FK",
    "Fiji": "FJ",
    "Finland": "FI",
    "France": "FR",
    "French Guiana": "GF",
    "French Southern Territories": "TF",
    "Gabon": "GA",
    "Gambia": "GM",
    "Georgia": "GE",
    "Germany": "DE",
    "Ghana": "GH",
    "Greece": "GR",
    "Greenland": "GL",
    "Guatemala": "GT",
    "Guinea": "GN",
    "Guinea-Bissau": "GW",
    "Guyana": "GY",
    "Haiti": "HT",
    "Honduras": "HN",
    "Hong Kong": "HK",
    "Hungary": "HU",
    "Iceland": "IS",
    "India": "IN",
    "Indonesia": "ID",
    "Iran": "IR",
    "Iraq": "IQ",
    "Ireland": "IE",
    "Israel": "IL",
    "Italy": "IT",
    "Jamaica": "JM",
    "Japan": "JP",
    "Jordan": "JO",
    "Kazakhstan": "KZ",
    "Kenya": "KE",
    "Korea": "KP",
    "Kosovo": "XK",
    "Kuwait": "KW",
    "Kyrgyzstan": "KG",
    "Lao": "LA",
    "Latvia": "AV",
    "Lebanon": "LB",
    "Lesotho": "LS",
    "Liberia": "LR",
    "Libya": "LY",
    "Lithuania": "LT",
    "Luxembourg": "LU",
    "Macedonia": "MK",
    "Madagascar": "MG",
    "Malawi": "MW",
    "Malaysia": "MY",
    "Mali": "ML",
    "Mauritania": "MR",
    "Mexico": "MX",
    "Moldova": "MD",
    "Mongolia": "MN",
    "Montenegro": "ME",
    "Morocco": "MA",
    "Mozambique": "MZ",
    "Myanmar": "MN",
    "Namibia": "NA",
    "Nepal": "NP",
    "Netherlands": "NL",
    "New Caledonia": "NC",
    "New Zealand": "NZ",
    "Nicaragua": "NI",
    "Niger": "NE",
    "Nigeria": "NG",
    "North Korea": "KP",
    "Norway": "NO",
    "Oman": "OM",
    "Pakistan": "PK",
    "Palestine": "PS",
    "Panama": "PA",
    "Papua New Guinea": "PG",
    "Paraguay": "PY",
    "Peru": "PE",
    "Philippines": "PH",
    "Poland": "PL",
    "Portugal": "PT",
    "Puerto Rico": "PR",
    "Qatar": "QA",
    "Republic of Kosovo": "XK",
    "Romania": "RO",
    "Russia": "RU",
    "Rwanda": "RW",
    "Saudi Arabia": "SA",
    "Senegal": "SN",
    "Serbia": "RS",
    "Sierra Leone": "SL",
    "Singapore": "SG",
    "Slovakia": "SK",
    "Slovenia": "SI",
    "Solomon Islands": "SB",
    "Somalia": "SO",
    "South Africa": "ZA",
    "South Korea": "KR",
    "South Sudan": "SS",
    "Spain": "ES",
    "Sri Lanka": "LK",
    "Sudan": "SD",
    "Suriname": "SR",
    "Svalbard and Jan Mayen": "SJ",
    "Swaziland": "SZ",
    "Sweden": "SE",
    "Switzerland": "CH",
    "Syrian Arab Republic": "SY",
    "Taiwan": "TW",
    "Tajikistan": "TJ",
    "Tanzania": "TZ",
    "Thailand": "TH",
    "Timor-Leste": "TL",
    "Togo": "TG",
    "Trinidad and Tobago": "TT",
    "Tunisia": "TN",
    "Turkey": "TR",
    "Turkmenistan": "TM",
    "UAE": "AE",
    "Uganda": "UG",
    "United Kingdom": "GB",
    "Ukraine": "UA",
    "USA": "US",
    "Uruguay": "UY",
    "Uzbekistan": "UZ",
    "Vanuatu": "VU",
    "Venezuela": "VE",
    "Vietnam": "VN",
    "Western Sahara": "EH",
    "Yemen": "YE",
    "Zambia": "ZM",
    "Zimbabwe": "ZW",
  };
  // List<SearchItem<int>> data;
  
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    BlocProvider.of<NewsBloc>(context).add(FetchNews());
  }

  @override
  Widget build(BuildContext context) {
    // data = _countryList
    //     .asMap()
    //     .map((index, value) => MapEntry(index, SearchItem(index, value)))
    //     .values
    //     .toList();

    return Scaffold(
        backgroundColor: HexColor("#d1e9ea"),
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: HexColor("#d1e9ea"),
          title: Row(
            children: <Widget>[
              Text(
                'News',
                style: TextStyle(color: Colors.black),
              ),
              SizedBox(width: 10.0),
              // Flexible(
              //   child: DropdownButton<String>(
              //     items: _countryList
              //         .map((data) => DropdownMenuItem<String>(
              //               child: Text(data),
              //               value: data,
              //             ))
              //         .toList(),
              //     onChanged: (String value) {
              //       setState(() => _selectedValue = value);
              //       BlocProvider.of<NewsBloc>(context)
              //           .add(FetchNews(_countryMap[value]));
              //     },
              //     hint: Row(
              //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              //       children: <Widget>[
              //         Text(_selectedValue),
              //       ],
              //     ),
              //   ),

              //   // child: FlutterSearchPanel<int>(
              //   //   padding: EdgeInsets.all(10.0),
              //   //   selected: 118,
              //   //   title: 'Search News by country',
              //   //   data: data,
              //   //   icon: new Icon(
              //   //     Icons.check_circle,
              //   //     color: Colors.deepPurple,
              //   //   ),
              //   //   color: HexColor("#d1e9ea"),
              //   //   textStyle: new TextStyle(
              //   //       color: Colors.deepPurple,
              //   //       fontWeight: FontWeight.bold,
              //   //       fontSize: 20.0,
              //   //       decorationStyle: TextDecorationStyle.dotted),
              //   //   onChanged: (int value) {
              //   //     print(value);
              //   //   },
              //   // ),
              // ),
              // Icon(Icons.location_on,color: Colors.red,),
            ],
          ),
        ),
        body: BlocBuilder<NewsBloc, NewsState>(
            builder: (BuildContext context, NewsState state) {
          if (state is NewsLoaded) {
            // CountryDataModel news = state.news;
            var news = state.news_data;
            return ListView(
              children: <Widget>[
                Container(
                  color: Colors.white,
                  height: 150.0,
                  width: MediaQuery.of(context).size.width,
                  child: InkWell(
                    onTap: () async {
                      String url = state.goto;
                      if (await canLaunch(url)) {
                        await launch(url);
                      }
                    },
                    child: Stack(
                      children: <Widget>[
                        // SizedBox(
                        //     height: 350.0,
                        //     width: MediaQuery.of(context).size.width,
                        //     child: Carousel(
                        //       dotSize: 4.0,
                        //       dotSpacing: 15.0,
                        //       dotColor: Colors.white,
                        //       indicatorBgPadding: 2.0,
                        //       dotBgColor: Colors.transparent,
                        //       dotIncreasedColor: Colors.deepPurple,
                        //       animationDuration:
                        //           const Duration(milliseconds: 1000),
                        //       autoplayDuration: _delay,
                        //       images: [
                        //         NetworkImage(
                        //             'https://picsum.photos/250?image=10'),
                        //         NetworkImage('https://picsum.photos/250?image=1'),
                        //         NetworkImage('https://picsum.photos/250?image=9'),
                        //       ],
                        //     )),

                        Container(
                          height: MediaQuery.of(context).size.height,
                          width: MediaQuery.of(context).size.width,
                          child: Image.network(state.url, fit: BoxFit.cover),
                        ),

                        Container(
                          height: MediaQuery.of(context).size.height,
                          width: MediaQuery.of(context).size.width,
                          color: Colors.white.withOpacity(0.2),
                        ),
                        // Positioned(
                        //   left: 30.0,
                        //   right: 0.0,
                        //   top: 40.0,
                        //   bottom: 0.0,
                        //   child: Text("TRENDING NEWS",
                        //       style: TextStyle(
                        //           color: Colors.white,
                        //           fontSize: 20.0,
                        //           fontWeight: FontWeight.bold)),
                        // ),
                        // Positioned(
                        //   left: 30.0,
                        //   right: 40.0,
                        //   top: 80.0,
                        //   bottom: 268.0,
                        //   child: Container(
                        //       color: Colors.white, width: 70.0, height: 10.0,
                        //       child: Image.network(
                        //             'https://picsum.photos/250?image=10'),),
                        // ),
                        Positioned(
                          left: 10.0,
                          right: 0.0,
                          top: 25.0,
                          bottom: 0.0,
                          child: Text(state.headline,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.bold)),
                        ),
                        // Positioned(
                        //   left: 30.0,
                        //   right: 0.0,
                        //   top: 200.0,
                        //   bottom: 0.0,
                        //   child: Text("Visit us at www.freetek.com.ng for more info",
                        //       style: TextStyle(
                        //           color: Colors.white,
                        //           fontSize: 15.0,
                        //           fontWeight: FontWeight.bold)),
                        // ),
                        // Positioned(
                        //   left: 30.0,
                        //   right: 150.0,
                        //   top: 270.0,
                        //   bottom: 30.0,
                        //   child: Padding(
                        //     padding: const EdgeInsets.fromLTRB(0.0, .0, 0.0, .0),
                        //     child: Material(
                        //         borderRadius: BorderRadius.circular(10.0),
                        //         color: Colors.deepPurple,
                        //         elevation: 0.0,
                        //         child: MaterialButton(
                        //           onPressed: () async {},
                        //           minWidth: MediaQuery.of(context).size.width,
                        //           child: Text(
                        //             "LEARN MORE",
                        //             textAlign: TextAlign.center,
                        //             style: TextStyle(
                        //                 color: Colors.white,
                        //                 fontWeight: FontWeight.bold,
                        //                 fontSize: 15.0),
                        //           ),
                        //         )),
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                ),
                Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    child: NewsPageTabView(news: news)),
              ],
            );
          } else if (state is NewsLoaded) {
            return Loading();
          } else if (state is NewsError) {
            return Center(
                child: Text('No news currently available!',
                    style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                        fontSize: 26.0)));
          } else {
            return Loading();
          }
        }));
  }
}

class NewsPageTabView extends StatefulWidget {
  // final CountryDataModel news;
  final news;

  const NewsPageTabView({Key key, this.news}) : super(key: key);

  _NewsPageTabViewState createState() => _NewsPageTabViewState();
}

class _NewsPageTabViewState extends State<NewsPageTabView>
    with SingleTickerProviderStateMixin {
  TabController controller;
  MaterialColor active = Colors.red;
  MaterialColor notActive = Colors.grey;
  final _key = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    controller = new TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {    
    return Container(
      child: Column(
        children: <Widget>[
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.center,
          //   children: <Widget>[
          //     Expanded(
          //         child: FlatButton(
          //             onPressed: () {

          //             },
          //             child: Text('Latest',
          //                 style: TextStyle(
          //                   color: Colors.red,
          //                 )))),
          //   ],
          // ),
          // Divider(),
          SizedBox(height: 10.0),
          Expanded(
            child: Align(
              alignment: Alignment.topCenter,
              child: ListView.builder(
                  itemCount: widget.news.length,
                  // itemCount: widget.news.countryNewsItems.length,
                  // reverse: true,
                  // shrinkWrap: true,
                  // physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (BuildContext context, int index) {
                    int image_num = new Random().nextInt(20);
                    Image image =  Image.network(
                                'https://picsum.photos/250?image=$image_num',
                                width: 60.0,
                              );
                    try{
                      int image_num = new Random().nextInt(20);
                      image = (( widget.news[index]['image_url'] == "None") || (widget.news[index]['image_url'] == "null"))
                            ? Image.network(
                                'https://picsum.photos/250?image=$image_num',
                                width: 60.0,
                              )
                            : Image.network(
                                widget.news[index]['image_url'],
                                width: 60.0,
                              );

                    }catch(e){
                      int image_num = new Random().nextInt(20);
                      image = Image.network(
                                'https://picsum.photos/250?image=$image_num',
                                width: 60.0,
                              );

                    }
                    if (index == 0) {
                      return Text(" ");
                    } else {
                      // var reversedNewsList = widget.news.countryNewsItems.reversed.toList();
                      var news_list = widget.news;
                      return ListTile(
                        onTap: () async {
                          String url = news_list[index]['url'];
                          if (await canLaunch(url)) {
                            await launch(url);
                          } else {
                            _key.currentState.showSnackBar(SnackBar(
                                content:
                                    Text("Cannot open link at this time!")));
                          }
                        },
                        leading: image,
                        title: Text(news_list[index]['title']),
                        subtitle: Text(news_list[index]['date']),
                      );
                    }
                  }),
            ),
          )
        ],
      ),
    );
  }
}
