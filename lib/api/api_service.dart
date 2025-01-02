
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:groundjp/api/domain/api_result.dart';
import 'package:groundjp/api/domain/method_type.dart';
import 'package:groundjp/api/domain/result_code.dart';
import 'package:groundjp/api/service/token_service.dart';
import 'package:groundjp/api/utils/header_helper.dart';
import 'package:groundjp/component/alert.dart';
import 'package:groundjp/component/secure_strage.dart';
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
    if (response.statusCode == 401) {
      return ResponseResult(ResultCode.UNAUTHRIZED, null);
    } else if (response.statusCode == 401) {
      return ResponseResult(ResultCode.FORBIDDEN, null);
    } else {
      final json = jsonDecode(utf8.decode(response.bodyBytes));
      return ResponseResult.fromJson(json);
    }
  }

  Map<String, String> getHeaders(Map<String, String> requestHeader, String? token, Map<String, String>? header) {
     return HeaderHelper.instance.getHeaders(requestHeader, token, header);
  }

  Future<ResponseResult> get({required String uri, String? token, Map<String, String>? header}) async {
    // UNAUTHORIZED || FORBIDDEN
    final response = await _tokenVerify(
      uri: Uri.parse('$server$uri'),
      header: getHeaders(contentTypeJson, token, header),
      token: token,
      api: (uri, header, body) => _execute(http.get(uri, headers: header)),
      getStatusCode: (response) => response.statusCode,
    );
    return _decode(response);
  }

  Future<ResponseResult> post({required String uri, String? token, Map<String, String>? header, Object? body,}) async {
    final response = await _tokenVerify(
      uri: Uri.parse('$server$uri'),
      header: getHeaders({}, token, header),
      body: body,
      token: token,
      api: (uri, header, body) => _execute(http.post(uri, headers: header, body: body)),
      getStatusCode: (response) => response.statusCode,
    );
    return _decode(response);
  }

  Future<ResponseResult> patch({required String uri, String? token, Map<String, String>? header, Object? body,}) async {
    final response = await _tokenVerify(
      uri: Uri.parse('$server$uri'),
      header: getHeaders({}, token, header),
      body: body,
      token: token,
      api: (uri, header, body) => _execute(http.patch(uri, headers: header, body: body)),
      getStatusCode: (response) => response.statusCode,
    );
    return _decode(response);
  }

  Future<ResponseResult> delete({required String uri, String? token, Map<String, String>? header, Object? body,}) async {
    final response = await _tokenVerify(
      uri: Uri.parse('$server$uri'),
      header: getHeaders({}, token, header),
      body: body,
      token: token,
      api: (uri, header, body) => _execute(http.delete(uri, headers: header, body: body)),
      getStatusCode: (response) => response.statusCode,
    );
    return _decode(response);
  }

  Future<T> _tokenVerify<T>({
    required Uri uri,
    required Map<String, String> header,
    String? token,
    Object? body,
    required Future<T> Function(Uri uri, Map<String, String> header, Object? body) api,
    required int Function(T response) getStatusCode,
  }) async {
    var response = await api(uri, header, body);
    print('uri : $uri');
    print('token : $token');
    print('statusCode : ${getStatusCode(response)}');
    // UNAUTHORIZED || FORBIDDEN
    int statusCode = getStatusCode(response);

    if (statusCode == 401 || statusCode == 403) {
      var refreshToken = await SecureStorage.instance.readRefreshToken();
      // 토큰 인증에 실패하면 RefreshToken
      if (token != null && refreshToken == token) {
        // 이미 RefreshToken 으로 조회된 경우 token 모두 삭제
        SecureStorage.instance.removeAllByToken();
      } else {
        // RefreshToken 으로 AccessToken 발급 요청
        String? newAccessToken = await TokenService.instance.refreshingAccessToken();
        if (newAccessToken != null) {
          // 발급되면 새로운 AccessToken 으로 재요청
          header = getHeaders(header, newAccessToken, null);
          response = await api(uri, header, body);
        }
      }
    }
    return response;
  }

  Future<ResponseResult> multipart(String uri, {required MethodType method, required String? multipartFilePath, required Map<String, dynamic> data}) async {
    var request = http.MultipartRequest(method.name, Uri.parse('$server$uri'));
    request.headers.addAll(contentTypeJson);
    request.headers.addAll(HeaderHelper.defaultHeader);
    String? accessToken = await SecureStorage.instance.readAccessToken();
    if (accessToken != null) request.headers.addAll(HeaderHelper.instance.getAuthorization(accessToken));

    if (multipartFilePath != null) {
      request.files.add(await http.MultipartFile.fromPath('image', multipartFilePath));
    }

    for (String key in data.keys) {
      if (data[key] == null) continue;
      request.fields[key] = data[key];
    }

    final response = await _tokenVerify(
      uri: Uri.parse('$server$uri'),
      header: request.headers,
      token: accessToken,
      api: (uri, header, body) {
        request.headers.addAll(header);
        return _execute(request.send());
      },
      getStatusCode: (response) => response.statusCode,
    );
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