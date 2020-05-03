import 'package:covid19_help/models/stats_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:covid19_help/bloc/stats_bloc/bloc/stats_bloc.dart';
import 'package:covid19_help/models/country_data_model.dart';
import 'package:covid19_help/models/general_data_model.dart';
import 'package:covid19_help/provider/user_provider.dart';
import 'package:covid19_help/utils/hex_colour.dart';
import 'package:covid19_help/widgets/loading.dart';
import 'package:provider/provider.dart';

class StatsPage extends StatefulWidget {
  @override
  _StatsPageState createState() => _StatsPageState();
}

class _StatsPageState extends State<StatsPage> {
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

  Map<String,String> _countryMap = {
    "Afghanistan":"AF",
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
    "Benin" : "BJ",
    "Bhuta": "BT",
    "Bolivia": "BO",
    "Bosnia and Herzegovina": "BA",
    "Botswana": "BW",
    "Brazil" : "BR",
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
    "Chile" : "CL",
    "China" : "CN",
    "Colombia": "CO",
    "Congo": "CG",
    "Democratic Republic of Congo":"CD",
    "Costa Rica":"CR",
    "Croatia":"HR",
    "Cuba": "CU",
    "Cyprus": "CY",
    "Czech Republic": "CZ",
    "Denmark": "DK",
    "Diamond Princess":"DP",
    "Djibouti":"DJ",
    "Dominican Republic":"DO",
    "DR Congo":"CD",
    "Ecuador":"EC",
    "Egypt":"EG",
    "El Salvador":"SV",
    "Equatorial Guinea":"GQ",
    "Eritrea":"ER",
    "Estonia":"EE",
    "Ethiopia":"ET",
    "Falkland Islands":"FK",
    "Fiji":"FJ",
    "Finland":"FI",
    "France":"FR",
    "French Guiana":"GF",
    "French Southern Territories":"TF",
    "Gabon":"GA",
    "Gambia":"GM",
    "Georgia":"GE",
    "Germany":"DE",
    "Ghana":"GH",
    "Greece":"GR",
    "Greenland":"GL",
    "Guatemala":"GT",
    "Guinea":"GN",
    "Guinea-Bissau":"GW",
    "Guyana":"GY",
    "Haiti":"HT",
    "Honduras":"HN",
    "Hong Kong":"HK",
    "Hungary":"HU",
    "Iceland":"IS",
    "India":"IN",
    "Indonesia":"ID",
    "Iran":"IR",
    "Iraq":"IQ",
    "Ireland":"IE",
    "Israel":"IL",
    "Italy":"IT",
    "Jamaica":"JM",
    "Japan":"JP",
    "Jordan":"JO",
    "Kazakhstan":"KZ",
    "Kenya":"KE",
    "Korea":"KP",
    "Kosovo":"XK",
    "Kuwait":"KW",
    "Kyrgyzstan":"KG",
    "Lao":"LA",
    "Latvia":"AV",
    "Lebanon":"LB",
    "Lesotho":"LS",
    "Liberia":"LR",
    "Libya":"LY",
    "Lithuania":"LT",
    "Luxembourg":"LU",
    "Macedonia":"MK",
    "Madagascar":"MG",
    "Malawi":"MW",
    "Malaysia":"MY",
    "Mali":"ML",
    "Mauritania":"MR",
    "Mexico":"MX",
    "Moldova":"MD",
    "Mongolia":"MN",
    "Montenegro":"ME",
    "Morocco":"MA",
    "Mozambique":"MZ",
    "Myanmar":"MN",
    "Namibia":"NA",
    "Nepal":"NP",
    "Netherlands":"NL",
    "New Caledonia":"NC",
    "New Zealand":"NZ",
    "Nicaragua":"NI",
    "Niger":"NE",
    "Nigeria":"NG",
    "North Korea":"KP",
    "Norway":"NO",
    "Oman":"OM",
    "Pakistan":"PK",
    "Palestine":"PS",
    "Panama":"PA",
    "Papua New Guinea":"PG",
    "Paraguay":"PY",
    "Peru":"PE",
    "Philippines":"PH",
    "Poland":"PL",
    "Portugal":"PT",
    "Puerto Rico":"PR",
    "Qatar":"QA",
    "Republic of Kosovo":"XK",
    "Romania":"RO",
    "Russia":"RU",
    "Rwanda":"RW",
    "Saudi Arabia":"SA",
    "Senegal":"SN",
    "Serbia":"RS",
    "Sierra Leone":"SL",
    "Singapore":"SG",
    "Slovakia":"SK",
    "Slovenia":"SI",
    "Solomon Islands":"SB",
    "Somalia":"SO",
    "South Africa":"ZA",
    "South Korea":"KR",
    "South Sudan":"SS",
    "Spain":"ES",
    "Sri Lanka":"LK",
    "Sudan":"SD",
    "Suriname":"SR",
    "Svalbard and Jan Mayen":"SJ",
    "Swaziland":"SZ",
    "Sweden":"SE",
    "Switzerland":"CH",
    "Syrian Arab Republic":"SY",
    "Taiwan":"TW",
    "Tajikistan":"TJ",
    "Tanzania":"TZ",
    "Thailand":"TH",
    "Timor-Leste":"TL",
    "Togo":"TG",
    "Trinidad and Tobago":"TT",
    "Tunisia":"TN",
    "Turkey":"TR",
    "Turkmenistan":"TM",
    "UAE":"AE",
    "Uganda":"UG",
    "United Kingdom":"GB",
    "Ukraine":"UA",
    "USA":"US",
    "Uruguay":"UY",
    "Uzbekistan":"UZ",
    "Vanuatu":"VU",
    "Venezuela":"VE",
    "Vietnam":"VN",
    "Western Sahara":"EH",
    "Yemen":"YE",
    "Zambia":"ZM",
    "Zimbabwe":"ZW",
  };
  String _currentCountry = "Albania";

  @override
void didChangeDependencies() {
  super.didChangeDependencies();
  BlocProvider.of<StatsBloc>(context).add(FetchStats('AF'));
}
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context);
    return Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: HexColor("#d1e9ea"),
          title: Text('Statistics', style: TextStyle(color: Colors.black)),
        ),
        backgroundColor: HexColor("#d1e9ea"),
        body: BlocBuilder<StatsBloc, StatsState>(
            builder: (BuildContext context, StatsState state) { 
              if(state is StatsLoaded){
                StatsDataModel countryStats = state.countryStats;
                GeneralDataModel generalStats = state.generalStats;
                return ListView(
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width,
              height: 250.0,
              child: Stack(
                children: <Widget>[
                  Positioned(
                    bottom: 0.0,
                    left: 0.0,
                    right: 0.0,
                    top: 0.0,
                    child: Image.asset(
                      "images/Black_and_white_political_map_of_the_world.png",
                      fit: BoxFit.cover,
                    ),
                  ),

                   Positioned(
                    bottom: 0.0,
                    left: 0.0,
                    right: 0.0,
                    top: 0.0,
                    child: Container(
                      color: Colors.white.withOpacity(0.8)
                    )
                  ),


                   Positioned(
                    bottom: 0.0,
                    left: 0.0,
                    right: 0.0,
                    top: 10.0,
                    child: Column(children: <Widget>[
                      Icon(Icons.data_usage),
                      SizedBox(height:2.0),
                      Text("Total cases:",style:TextStyle(fontWeight: FontWeight.bold)),
                      SizedBox(height:2.0),
                      Text('${generalStats.results.totalCases}',style:TextStyle(fontWeight: FontWeight.bold)),
                    ],)
                  ),


                  Positioned(
                    bottom: 0.0,
                    left: 0.0,
                    right: 0.0,
                    top: 180.0,
                    child: Column(children: <Widget>[
                      Icon(Icons.data_usage),
                      SizedBox(height:2.0),
                      Text("Total cases today:",style:TextStyle(fontWeight: FontWeight.bold)),
                      SizedBox(height:2.0),
                      Text('${generalStats.results.totalNewCasesToday}',style:TextStyle(fontWeight: FontWeight.bold)),
                    ],)
                  ),


                  Positioned(
                    bottom: 0.0,
                    left: 0.0,
                    right: 230.0,
                    top: 60.0,
                    child: Column(children: <Widget>[
                      Icon(Icons.data_usage),
                      SizedBox(height:2.0),
                      Text("Total deaths:",style:TextStyle(fontWeight: FontWeight.bold)),
                      SizedBox(height:2.0),
                      Text('${generalStats.results.totalDeaths}',style:TextStyle(fontWeight: FontWeight.bold)),
                    ],)
                  ),


                  Positioned(
                    bottom: 0.0,
                    left: 0.0,
                    right: 230.0,
                    top: 140.0,
                    child: Column(children: <Widget>[
                      Icon(Icons.data_usage),
                      SizedBox(height:2.0),
                      Text("Total deaths today:",style:TextStyle(fontWeight: FontWeight.bold)),
                      SizedBox(height:2.0),
                      Text('${generalStats.results.totalNewDeathsToday}',style:TextStyle(fontWeight: FontWeight.bold)),
                    ],)
                  ),
                  
                  Positioned(
                    bottom: 0.0,
                    left: 230.0,
                    right: 0.0,
                    top: 140.0,
                    child: Column(children: <Widget>[
                      Icon(Icons.data_usage),
                      SizedBox(height:2.0),
                      Text("Unresolved:",style:TextStyle(fontWeight: FontWeight.bold)),
                      SizedBox(height:2.0),
                      Text('${generalStats.results.totalUnresolved}',style:TextStyle(fontWeight: FontWeight.bold)),
                    ],)
                  ),

                  Positioned(
                    bottom: 0.0,
                    left: 230.0,
                    right: 0.0,
                    top: 60.0,
                    child: Column(children: <Widget>[
                      Icon(Icons.data_usage),
                      SizedBox(height:2.0),
                      Text("Serious cases:",style:TextStyle(fontWeight: FontWeight.bold)),
                      SizedBox(height:2.0),
                      Text('${generalStats.results.toalActiveCases}',style:TextStyle(fontWeight: FontWeight.bold)),
                    ],)
                  )

                  
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top:15.0),
              child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15.0))),
                elevation: 2,
                margin: EdgeInsets.all(12.0),
                child: Padding(
                  padding: const EdgeInsets.all(0.0),
                  child: ExpansionTile(
                    backgroundColor: Colors.white,
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(height: 20.0),
                        Padding(
                          padding: const EdgeInsets.only(left: 27.0),
                          child: Text(_currentCountry,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 25.0)),
                        ),
                        SizedBox(height: 20.0),
                        Padding(
                          padding: const EdgeInsets.only(left: 27.0),
                          child: Text("Select a different Country",
                              style: TextStyle(color: Colors.black)),
                        ),
                        SizedBox(height: 20.0)
                      ],
                    ),
                    trailing: SizedBox(),
                    children: <Widget>[
                      new DropdownButton<String>(
                          items: _countryList.map((String value) {
                            return new DropdownMenuItem<String>(
                              value: value,
                              child: new Text(value),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              _currentCountry = value;
                              BlocProvider.of<StatsBloc>(context).add(FetchStats(_countryMap[value]));
                            });
                          },
                          value: _currentCountry)
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15.0))),
                elevation: 2,
                margin: EdgeInsets.all(12.0),
                child: Container(
                    child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        SvgPicture.asset(
                          'images/medical-file.svg',
                          width: 50.0,
                        ),
                        SizedBox(
                          width: 10.0,
                        ),
                        Text("TOTAL CASES",
                            style:
                                TextStyle(color: Colors.black, fontSize: 25.0)),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Text('${countryStats.countryStats[0].totalCases}',
                            style:
                                TextStyle(color: Colors.black, fontSize: 20.0)),
                        SizedBox(
                          width: 5.0,
                        ),
                        // Padding(
                        //   padding: const EdgeInsets.only(top: 8.0),
                        //   child: Text("2 in ICU",
                        //       style: TextStyle(
                        //           color: Colors.black, fontSize: 10.0)),
                        // ),
                        SizedBox(
                          width: 5.0,
                        ),
                      ],
                    ),
                  ],
                )),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15.0))),
                elevation: 2,
                margin: EdgeInsets.all(12.0),
                child: Container(
                    child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        SvgPicture.asset(
                          'images/heart.svg',
                          width: 50.0,
                        ),
                        SizedBox(
                          width: 10.0,
                        ),
                        Text("IN HOSPITAL",
                            style:
                                TextStyle(color: Colors.black, fontSize: 25.0)),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Text('${countryStats.countryStats[0].totalUnresolved}',
                            style:
                                TextStyle(color: Colors.black, fontSize: 20.0)),
                        SizedBox(
                          width: 5.0,
                        ),
                        // Padding(
                        //   padding: const EdgeInsets.only(top: 8.0),
                        //   child: Text('${countryStats.countryStats[0].totalUnresolved/generalStats.results.totalCases}',
                        //       style: TextStyle(
                        //           color: Colors.black, fontSize: 8.0)),
                        // ),
                        SizedBox(
                          width: 5.0,
                        ),
                      ],
                    ),
                  ],
                )),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15.0))),
                elevation: 2,
                margin: EdgeInsets.all(12.0),
                child: Container(
                    child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        SvgPicture.asset(
                          'images/memorial.svg',
                          width: 50.0,
                        ),
                        SizedBox(
                          width: 10.0,
                        ),
                        Text("DECEASED",
                            style:
                                TextStyle(color: Colors.black, fontSize: 25.0)),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Text('${countryStats.countryStats[0].totalDeaths}',
                            style:
                                TextStyle(color: Colors.black, fontSize: 20.0)),
                        SizedBox(
                          width: 5.0,
                        ),
                        // Padding(
                        //   padding: const EdgeInsets.only(top: 8.0),
                        //   child: Text('${countryStats.countryStats[0].totalDeaths/generalStats.results.totalCases}',
                        //       style: TextStyle(
                        //           color: Colors.black, fontSize: 8.0)),
                        // ),
                        SizedBox(
                          width: 5.0,
                        ),
                      ],
                    ),
                  ],
                )),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15.0))),
                elevation: 2,
                margin: EdgeInsets.all(12.0),
                child: Container(
                    child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        SvgPicture.asset(
                          'images/recovered-1.svg',
                          width: 50.0,
                        ),
                        SizedBox(
                          width: 10.0,
                        ),
                        Text("DISCHARGED",
                            style:
                                TextStyle(color: Colors.black, fontSize: 25.0)),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Text('${countryStats.countryStats[0].totalRecovered}',
                            style:
                                TextStyle(color: Colors.black, fontSize: 20.0)),
                        SizedBox(
                          width: 5.0,
                        ),
                        // Padding(
                        //   padding: const EdgeInsets.only(top: 8.0),
                        //   child: Text('${countryStats.countryStats[0].totalRecovered/generalStats.results.totalCases}',
                        //       style: TextStyle(
                        //           color: Colors.black, fontSize: 8.0)),
                        // ),
                        SizedBox(
                          width: 5.0,
                        ),
                      ],
                    ),
                  ],
                )),
              ),
            ),
          ],
        );
              }
              else if(state is StatsInitial){
                return Loading();
              }
              else if(state is StatsError){
            return Center(child: Text('No statistics currently available!',style:TextStyle(color:Colors.red,fontWeight:FontWeight.bold,fontSize: 24.0)));
              }
              else{
                return Loading();
              }
            })
            
              
        );
  }
}
