
import 'package:covid19_help/models/stats_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:covid19_help/models/country_data_model.dart';
import 'package:covid19_help/models/general_data_model.dart';
import 'package:covid19_help/models/other_case_model.dart';
import 'package:covid19_help/repositories/api_client.dart';
import 'package:http/http.dart' as http;


class ApiRepository {
  final ApiClient apiClient;

  ApiRepository({@required this.apiClient}): assert(apiClient != null);
  Future<GeneralDataModel> getAllCountryData() async {
    return apiClient.getAllCountryData();
  }
  Future<OtherCaseModel> getRecoveredCases() async {
    return apiClient.getRecoveredCases();
  }
  Future<OtherCaseModel> getConfirmedCases() async {
    return apiClient.getConfirmedCases();
  }
  Future<OtherCaseModel> getDeathCases() async {
    return apiClient.getDeathCases();
  }
  Future<CountryDataModel> getCountryNews(String countryCode) async {
    return apiClient.getCountryNews(countryCode);
  }
  Future<StatsDataModel> getCountryStats(String countryCode) async {
    return apiClient.getCountryStats(countryCode);
  }
  // Future<OtherCaseModel> getSuspectedCases() async {
  //   return apiClient.getSuspectedCases();
  // }
  
}