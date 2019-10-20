import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

const base_url = "https://biaoqing.samoy.fun/";

class NetUtils {
  var dio = new Dio();
  static BuildContext context;
  static NetUtils netUtils;

  static NetUtils getInstance(BuildContext context) {
    if (netUtils == null) {
      netUtils = new NetUtils(context);
    }
    return netUtils;
  }

  NetUtils(BuildContext context) {
    dio.interceptors.add(InterceptorsWrapper(onResponse: (response) {
      Map<String, dynamic> res = response.data;
      if (res["code"] != 10000) {
        Toast.show("${res["message"]}", context);
      }
    }, onError: (error) {
      Toast.show("服务器错误:${error.message}", context);
    }));
  }

  Future get(String path, [Map<String, dynamic> params]) async {
    Response response;
    response = await dio.get(base_url + path, queryParameters: params);
    return response.data as Map<String, dynamic>;
  }

  Future post(String path, Map<String, dynamic> params) async {
    var response = await dio.post(base_url + path, data: params);
    return response.data;
  }
}
