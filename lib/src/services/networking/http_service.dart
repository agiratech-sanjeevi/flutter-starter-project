import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

import '../../utils/utils.dart';
import '../local_storage/key_value_storage_service.dart';
import 'network_check.dart';

class HttpService {
  //! HTTP Get API Calls.
  Future<JSON> get({
    required String endpoint,
    Map<String, String>? headers,
    JSON? queryParams,
    final dynamic Function(bool)? onError,
  }) async {
    final bool isNetworkAvailable = await NetworkCheck().check();
    if (isNetworkAvailable) {
      try {
        final response = await http.get(
          Uri.parse(endpoint),
          headers: headers ?? await addAuthenticationHeader(),
        );
        var responseJson = json.decode(response.body.toString());
        responseJson.putIfAbsent("status_code", () => response.statusCode);
        return responseJson;
      } on Exception catch (_) {}
    }
    return onError != null ? onError(isNetworkAvailable) : false;
  }

//! HTTP Post Api Call.
  Future<JSON> post(
      {required String endpoint,
      dynamic body,
      final dynamic Function(bool)? onError}) async {
    final bool isNetworkAvailable = await NetworkCheck().check();
    if (isNetworkAvailable) {
      debugPrint(body);

      try {
        final response = await http.post(
          Uri.parse(endpoint),
          headers: await addAuthenticationHeader(),
          // headers
          //     ? await authenticationHeaderWithoutcontent()
          //     : await addAuthenticationHeader(),
          body: body,
        );
        var responseJson = json.decode(response.body.toString());
        responseJson.putIfAbsent("status_code", () => response.statusCode);
        return responseJson;
      } on Exception catch (_) {
        debugPrint('$_');
      }
    }
    return onError != null ? onError(isNetworkAvailable) : null;
  }

  Future<JSON> multipartRequest(
      {required String endpoint,
      dynamic body,
      final dynamic Function(bool)? onError}) async {
    final bool isNetworkAvailable = await NetworkCheck().check();
    if (isNetworkAvailable) {
      try {
        debugPrint("endpoint " + Uri.parse(endpoint).toString());
        debugPrint("filePath " + body.toString());
        var request = http.MultipartRequest("POST", Uri.parse(endpoint));
        request.headers.addAll(await addAuthenticationHeader());
        request.fields["upload_type"] = "attachement";
        if (body.isNotEmpty) {
          http.MultipartFile frontFile = await http.MultipartFile.fromPath(
              'file', body,
              contentType:
                  MediaType('image', ImageUtils.getImageExtension(body)));
          request.files.add(frontFile);
        }
        debugPrint("request " + request.toString());
        http.StreamedResponse response = await request.send();
        var respStr = await response.stream.bytesToString();
        var responseJson = json.decode(respStr.toString());
        responseJson.putIfAbsent("status_code", () => response.statusCode);
        return responseJson;
      } on Exception catch (_) {
        debugPrint('$_');
      }
    }
    return onError != null ? onError(isNetworkAvailable) : false;
  }

//! HTTP Put Api Call.
  // Future<dynamic> put(String url,
  //     {Map<String, String>? headers,
  //     Map<String, String>? params,
  //     body,
  //     final dynamic Function(bool)? onError}) async {
  //   final bool isNetworkAvailable = await NetworkCheck().check();
  //   if (isNetworkAvailable) {
  //     try {
  //       final response = await http.put(
  //         Uri.parse(url),
  //         headers: headers,
  //         body: body,
  //       );
  //       var responseJson = json.decode(response.body.toString());
  //       responseJson.putIfAbsent("status_code", () => response.statusCode);
  //       return responseJson;
  //     } on Exception catch (_) {
  //       debugPrint('$_');
  //     }
  //   }
  //   return onError != null ? onError(isNetworkAvailable) : null;
  // }
  Future<JSON> put(
      {required String endpoint,
      dynamic body,
      final dynamic Function(bool)? onError}) async {
    final bool isNetworkAvailable = await NetworkCheck().check();
    if (isNetworkAvailable) {
      try {
        final response = await http.put(
          Uri.parse(endpoint),
          headers: await addAuthenticationHeader(),
          body: body,
        );
        var responseJson = json.decode(response.body.toString());
        responseJson.putIfAbsent("status_code", () => response.statusCode);
        return responseJson;
      } on Exception catch (_) {
        debugPrint('$_');
      }
    }
    return onError != null ? onError(isNetworkAvailable) : null;
  }

//! HTTP Delete Api Call.
  Future<dynamic> delete(
      {required String endpoint,
      // dynamic body,
      final dynamic Function(bool)? onError}) async {
    final bool isNetworkAvailable = await NetworkCheck().check();
    if (isNetworkAvailable) {
      try {
        final response = await http.delete(
          Uri.parse(endpoint),
          headers: await addAuthenticationHeader(),
          // body: body,
        );
        var responseJson = json.decode(response.body.toString());
        responseJson.putIfAbsent("status_code", () => response.statusCode);
        return responseJson;
      } on Exception catch (_) {
        debugPrint('$_');
      }
    }
    return onError != null ? onError(isNetworkAvailable) : null;
  }
}

final KeyValueStorageService _localStor = KeyValueStorageService();
Future<Map<String, String>> addAuthenticationHeader() async {
  String token = await _localStor.getAuthToken();
  debugPrint(token);

  return {
    'Authorization': 'Bearer $token',
    'Content-Type': 'application/json',
  };
}

Future<Map<String, String>> authenticationHeaderWithoutcontent() async {
  String token = await _localStor.getAuthToken();
  return {'Authorization': 'Bearer $token'};
}
