
import '../../utils/utils.dart';

abstract class ApiInterface {
  const ApiInterface();

  Future<List<T>> getCollectionData<T>(
      {required String endpoint,
      JSON? queryParams,
      required T Function(JSON responseBody) converter,
      final dynamic Function(bool)? onError});

  Future<T> getDocumentData<T>(
      {required String endpoint,
      JSON? queryParams,
      required T Function(JSON responseBody) converter,
      final dynamic Function(bool)? onError});

  Future<T> setData<T>(
      {required String endpoint,
      required JSON data,
      required T Function(JSON response) converter,
      final dynamic Function(bool)? onError});

  Future<T> updateData<T>(
      {required String endpoint,
      required JSON data,
      required T Function(JSON response) converter,
      final dynamic Function(bool)? onError});

  Future<T> mulitPart<T>(
      {required String endpoint,
      required JSON data,
      required T Function(JSON response) converter,
      final dynamic Function(bool)? onError});

  Future<T> deleteData<T>(
      {required String endpoint,
      JSON? data,
      required T Function(JSON response) converter,
      final dynamic Function(bool)? onError});
}
