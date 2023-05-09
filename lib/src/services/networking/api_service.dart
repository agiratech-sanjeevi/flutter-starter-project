import 'dart:convert';
import '../networking/http_service.dart';
import '../networking/api_interface.dart';

// import 'package:/src/services/networking/http_service.dart';
import 'package:flutter/material.dart';

import '../../utils/utils.dart';

class ApiService implements ApiInterface {
  final HttpService _httpService = HttpService();
  @override
  Future<List<T>> getCollectionData<T>(
      {required String endpoint,
      JSON? queryParams,
      required T Function(JSON responseBody) converter,
      final dynamic Function(bool)? onError}) async {
    final result =
        await _httpService.get(endpoint: endpoint, queryParams: queryParams);
    final data = result['data'];
    return data.map((dataMap) => converter(dataMap as JSON)).toList();
  }

  @override
  Future<T> getDocumentData<T>(
      {required String endpoint,
      JSON? queryParams,
      required T Function(JSON responseBody) converter,
      Function(bool)? onError}) async {
    print(endpoint);
    final data = await _httpService.get(
      endpoint: endpoint,
      queryParams: queryParams,
    );
    return converter(data);
  }

  @override
  Future<T> setData<T>({
    required String endpoint,
    dynamic data,
    required T Function(JSON response) converter,
    final dynamic Function(bool)? onError,
  }) async {
    print(endpoint);
    final dataMap = await _httpService.post(
      endpoint: endpoint,
      body: jsonEncode(data),
    );
    debugPrint(dataMap.toString());
    return converter(dataMap);
  }

  @override
  Future<T> mulitPart<T>({
    required String endpoint,
    dynamic data,
    required T Function(JSON response) converter,
    final dynamic Function(bool)? onError,
  }) async {
    final dataMap = await _httpService.multipartRequest(
      endpoint: endpoint,
      body: data,
    );
    debugPrint(dataMap.toString());
    return converter(dataMap);
  }

  @override
  Future<T> updateData<T>(
      {required String endpoint,
      required JSON data,
      required T Function(JSON response) converter,
      final dynamic Function(bool)? onError}) async {
    final dataMap = await _httpService.put(
      endpoint: endpoint,
      body: jsonEncode(data),
    );
    return converter(dataMap);
  }

  @override
  Future<T> deleteData<T>(
      {required String endpoint,
      JSON? data,
      required T Function(JSON response) converter,
      final dynamic Function(bool)? onError}) async {
    final dataMap = await _httpService.delete(
      endpoint: endpoint,
      // body: jsonEncode(data),
    );
    debugPrint(dataMap.toString());
    return converter(dataMap);
  }
}
