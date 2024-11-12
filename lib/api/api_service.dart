
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:groundjp/api/domain/api_result.dart';
import 'package:groundjp/api/domain/method_type.dart';
import 'package:groundjp/api/utils/header_helper.dart';
import 'package:groundjp/component/alert.dart';
import 'package:groundjp/exception/server/server_exception.dart';
import 'package:groundjp/exception/server/socket_exception.dart';
import 'package:groundjp/exception/server/timeout_exception.dart';
import 'package:groundjp/exception/socket_exception_os_code.dart';
import 'package:http/http.dart' as http;

class ApiService {

  static const ApiService instance = ApiService();
  const ApiService();
  static const String server = "http://$domain";
  static const String domain = 'localhost:8080';
  // static const String domain = 'experiments-july-kelkoo-elsewhere.trycloudflare.com';
  static const Duration _delay = Duration(seconds: 20);
  static const Map<String, String> contentTypeJson = {
    "Content-Type" : "application/json; charset=utf-8",
  };

  ResponseResult _decode(http.Response response) {
    final json = jsonDecode(utf8.decode(response.bodyBytes));
    return ResponseResult.fromJson(json);
  }

  getHeaders(Map<String, String> requestHeader, bool authorization, Map<String, String>? header) async {
    await HeaderHelper.instance.getHeaders(requestHeader, authorization, header);
  }

  Future<ResponseResult> post({required String uri, required bool authorization, Map<String, String>? header, Object? body,}) async {

    Map<String, String> requestHeader = {};
    await getHeaders(requestHeader, authorization, header);

    final response = await _execute(http.post(Uri.parse('$server$uri'), headers: requestHeader, body: body));
    return _decode(response);
  }

  Future<ResponseResult> patch({required String uri, required bool authorization, Map<String, String>? header, Object? body,}) async {

    Map<String, String> requestHeader = {};
    await getHeaders(requestHeader, authorization, header);

    final response = await _execute(http.patch(Uri.parse('$server$uri'), headers: requestHeader, body: body));
    return _decode(response);
  }

  Future<ResponseResult> delete({required String uri, required bool authorization, Map<String, String>? header, Object? body,}) async {

    Map<String, String> requestHeader = {};
    await getHeaders(requestHeader, authorization, header);

    final response = await _execute(http.delete(Uri.parse('$server$uri'), headers: requestHeader, body: body));
    return _decode(response);
  }

  Future<ResponseResult> get({required String uri, required bool authorization, Map<String, String>? header}) async {
    Map<String, String> requestHeader = {"Content-Type" : "application/json; charset=utf-8",};
    await getHeaders(requestHeader, authorization, header);

    final response = await _execute(http.get(Uri.parse('$server$uri'), headers: requestHeader));
    return _decode(response);
  }

  Future<ResponseResult> multipart(String uri, {required MethodType method, required String? multipartFilePath, required Map<String, dynamic> data}) async {
    var request = http.MultipartRequest(method.name, Uri.parse('$server$uri'));
    request.headers.addAll({"Content-Type": "application/json; charset=UTF-8"});
    await getHeaders(request.headers, true, null);

    if (multipartFilePath != null) {
      request.files.add(await http.MultipartFile.fromPath('image', multipartFilePath));
    }

    for (String key in data.keys) {
      if (data[key] == null) continue;
      request.fields[key] = data[key];
    }

    final response = await _execute(request.send());
    final responseBody = await response.stream.bytesToString();
    final json = jsonDecode(responseBody);
    return ResponseResult.fromJson(json);
  }

  Future<T> _execute<T> (Future<T> method) async {
    try {
      return await method.timeout(_delay);
    } on TimeoutException catch (_) {
      throw TimeOutException("서버 응답이 지연되고 있습니다. 나중에 다시 시도해주세요.");
    } on SocketException catch (_) {
      print(_);
      SocketOSCode error = SocketOSCode.convert(_.osError?.errorCode);
      throw InternalSocketException(error);
    } catch (e) {
      print(e);
      throw ServerException("정보를 불러오는데 실패했습니다");
    }
  }


}