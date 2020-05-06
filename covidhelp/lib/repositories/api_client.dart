import 'dart:convert';

import 'package:covidhelp/models/stats_model.dart';
import 'package:dio/dio.dart';
import 'package:covidhelp/models/country_data_model.dart';
import 'package:covidhelp/models/general_data_model.dart';
import 'package:covidhelp/models/news_model.dart';
import 'package:covidhelp/models/other_case_model.dart';
import 'package:http/http.dart' as http;

import 'api_interceptor.dart';

class ApiClient {
  static const baseUrl =
      'https://thevirustracker.com/free-api';
  Dio _dio;
  ApiClient() {
    BaseOptions options = BaseOptions(
        receiveTimeout: 100000, connectTimeout: 100000, baseUrl: baseUrl);
    _dio = Dio(options);
    _dio.interceptors.add(ApiInterceptor());
  }
  Future<GeneralDataModel> getAllCountryData() async {
    final url = '$baseUrl?global=stats';

    final response = await http.get(url);
    if (response.statusCode == 200) {
      // print(json.decode(response.body)['countrynewsitems'][0]["2"]);
      // If the call to the server was successful, parse the JSON
      return GeneralDataModel.fromJson(json.decode(response.body));
    } else {
      // If that call was not successful, throw an error.
      throw Exception('Failed to load post');
    }
  }
  Future<CountryDataModel> getCountryNews(String countryCode) async {
    // final url = 'https://thevirustracker.com/free-api?countryTotal=NG';
    final url = '$baseUrl?countryNewsTotal=$countryCode';
    final response = await http.get(url);
    if (response.statusCode == 200) {
      // print(json.decode(response.body)['countrynewsitems'][0]["2"]);
      // If the call to the server was successful, parse the JSON
      return CountryDataModel.fromJson(json.decode(response.body));
    } else {
      // If that call was not successful, throw an error.
      throw Exception('Failed to load post');
    }
  }

  Future<StatsDataModel> getCountryStats(String countryCode) async {
    // final url = 'https://thevirustracker.com/free-api?countryTotal=NG';
    final url = '$baseUrl?countryTotal=$countryCode';
    final response = await http.get(url);
    if (response.statusCode == 200) {
      // print(json.decode(response.body)['countrynewsitems'][0]["2"]);
      // If the call to the server was successful, parse the JSON
      return StatsDataModel.fromJson(json.decode(response.body));
    } else {
      // If that call was not successful, throw an error.
      throw Exception('Failed to load post');
    }
  }
    // try {
    //   final response = await _dio.get(url);

    //   return response;
    // } on DioError catch (e) {
    //   print(e.error);
    //   throw e.error;
    // }
  
  Future<OtherCaseModel> getConfirmedCases() async {
    final url = '$baseUrl/cases/confirmed';

    try {
      final response = await _dio.get(url);
      return OtherCaseModel.fromJson(response.data[0]);
    } on DioError catch (e) {
      print(e.error);
      throw e.error;
    }
  }
  Future<OtherCaseModel> getDeathCases() async {
    final url = '$baseUrl/deaths';

    try {
      final response = await _dio.get(url);
      return OtherCaseModel.fromJson(response.data[0]);
    } on DioError catch (e) {
      print(e.error);
      throw e.error;
    }
  }
  Future<OtherCaseModel> getRecoveredCases() async {
    final url = '$baseUrl/recovered';

    try {
      final response = await _dio.get(url);
      return OtherCaseModel.fromJson(response.data[0]);
    } on DioError catch (e) {
      print(e.error);
      throw e.error;
    }
  }
}
