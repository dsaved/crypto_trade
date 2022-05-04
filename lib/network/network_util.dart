import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:crypto_trade/dbhandler/databaseHelper.dart';
import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class NetworkUtil {
  // next three lines makes this class a Singleton
  static NetworkUtil _instance = new NetworkUtil.internal();

  NetworkUtil.internal();

  factory NetworkUtil() => _instance;
  final JsonDecoder _decoder = new JsonDecoder();

  Future<BaseOptions> getOptions({validate = true}) async {
    var link = await DatabaseHelper.internal().getLink();
    BaseOptions options = new BaseOptions(
      baseUrl: link,
      connectTimeout: 15000,
      receiveTimeout: 100000,
      responseType: ResponseType.plain,
      contentType: 'application/json'
    );
    return options;
  }

  Future<dynamic> get(String url, BuildContext context,
      {authorize = true}) async {
    dynamic serverResponse, response;
    BaseOptions options = await getOptions(validate: authorize);
    try {
      Dio dio = new Dio(options);
      (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
          (client) {
        SecurityContext sc = new SecurityContext();
        //file is the path of certificate
//        sc.setTrustedCertificates(file);
        HttpClient httpClient = new HttpClient(context: sc);
        //allow all cert
        httpClient.badCertificateCallback =
            (X509Certificate cert, String host, int port) => true;
        return httpClient;
      };

      serverResponse = await dio.get(url);

      print("RESPONSE FROM GET ${serverResponse.statusMessage}");
      //check for connection errors
      if (serverResponse.statusCode < 200 || serverResponse.statusCode > 400) {
        return _decoder.convert(
            '{"success":false,"message":"Error Executing Request"}');
      }

      print(serverResponse.data);
      response = _decoder.convert(serverResponse.data);
    } on DioError catch (e) {
      // The request was made and the server responded with a status code
      // that falls out of the range of 2xx and is also not 304.
      if (e.response != null) {
        print(e.response.data);
        print(e.response.headers);
        print(e.response.request);
        response = '{"success":false,"message":"${e.response.statusMessage}"}';
      } else {
        // Something happened in setting up or sending the request that triggered an Error
        print(e.message);
        response =
            _decoder.convert('{"success":false,"message":"' + e.message + '"}');
      }
    } catch (error) {
      return _decoder.convert(
          '{"success":false,"message":"Error Executing Request"}');
    }
    return response;
  }

  Future<dynamic> head(String url, BuildContext context) async {
    bool serverResponse = false;
    try {
      BaseOptions options = await getOptions(validate: false);
      Dio dio = new Dio(options);
      (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
          (client) {
        SecurityContext sc = new SecurityContext();
        HttpClient httpClient = new HttpClient(context: sc);
        httpClient.badCertificateCallback =
            (X509Certificate cert, String host, int port) => true;
        return httpClient;
      };
      var response = await dio.head(url);
      if (response.statusCode == 200)
        serverResponse = true;
      else
        serverResponse = false;
    } on DioError catch (e) {
      serverResponse = false;
    }
    return serverResponse;
  }

  Future<dynamic> post(String url, BuildContext context,
      {Map body, authorize = true}) async {
    print("$body");
    dynamic serverResponse, response;
    BaseOptions options = await getOptions(validate: authorize);

    try {
      Dio dio = new Dio(options);
      (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
          (client) {
        SecurityContext sc = new SecurityContext();
        //file is the path of certificate
//        sc.setTrustedCertificates(file);
        HttpClient httpClient = new HttpClient(context: sc);
        //allow all cert
        httpClient.badCertificateCallback =
            (X509Certificate cert, String host, int port) => true;
        return httpClient;
      };

      //add image and fileds to request data
      // FormData requestData = new FormData();
      // body.forEach((key, value) {
      //   MapEntry<String, String> data = new MapEntry(key, '$value');
      //   requestData.fields.add(data);
      // });

      serverResponse = await dio.post(url, data: json.encode(body));
      print("SERVER RESPONSE: $serverResponse");

      //check for connection errors
      if (serverResponse.statusCode < 200 || serverResponse.statusCode > 400) {
        return _decoder.convert(
            '{"success":false,"message":"Error Executing Request"}');
      }

      print(serverResponse.data);
      response = _decoder.convert(serverResponse.data);
    } on DioError catch (e) {
      // The request was made and the server responded with a status code
      // that falls out of the range of 2xx and is also not 304.
      if (e.response != null) {
        print(e.response.data);
        print(e.response.headers);
        print(e.response.request);
        print(e.response.statusCode);
        String dataRes;
        if(403 == e.response.statusCode){
          dataRes = e.response.data;
        }else {
          dataRes = '{"success":false,"message":"${e.response.statusMessage}"}';
        }
        response = _decoder.convert(dataRes);
      } else {
        // Something happened in setting up or sending the request that triggered an Error
        print(e.message);
        response = _decoder.convert(
            '{"success":false,"message":"Error Executing Request"}');
      }
    } catch (error) {
      print(error);
      return _decoder.convert(
          '{"success":false,"message":"Error Executing Request"}');
    }
    return response;
  }
}

/// Describes the info of file to upload.
class UploadFileInfo {
  UploadFileInfo(this.file, this.fileName, {ContentType contentType})
      : bytes = null,
        this.contentType = contentType ?? ContentType.binary;

  UploadFileInfo.fromBytes(this.bytes, this.fileName, {ContentType contentType})
      : file = null,
        this.contentType = contentType ?? ContentType.binary;

  /// The file to upload.
  final File file;

  /// The file content
  final List<int> bytes;

  /// The file name which the server will receive.
  final String fileName;

  /// The content-type of the upload file. Default value is `ContentType.binary`
  ContentType contentType;
}
