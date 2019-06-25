import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

const base_url = "https://biaoqing.samoy.fun/";

var dio = new Dio();

class NetUtils {
  static Future get(BuildContext context, String path,
      [Map<String, dynamic> params]) async {
    dio.interceptors.add(InterceptorsWrapper(onResponse: (response) {
      Map<String, dynamic> res = response.data;
      if (res["code"] != 10000) {
        Toast.show("请求失败:${res["message"]}", context);
      }
    }, onError: (error) {
      Toast.show("服务器错误:${error.message}", context);
    }));
    Response response;
    response = await dio.get(base_url + path, queryParameters: params);
    return response.data as Map<String, dynamic>;
  }

  static Future post(String path, Map<String, dynamic> params) async {
    var response = await dio.post(base_url + path, data: params);
    return response.data;
  }
}
