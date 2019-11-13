import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

const base_url = "https://biaoqing.samoy.fun/";

class NetUtils {
  var dio = new Dio();
  static NetUtils netUtils;
  var _context;

  static NetUtils getInstance(BuildContext context) {
    if (netUtils == null) {
      netUtils = new NetUtils(context);
    }
    return netUtils;
  }

  NetUtils(BuildContext context) {
    _context = context;
    dio.interceptors.add(InterceptorsWrapper(onResponse: (response) {
      Map<String, dynamic> res = response.data;
      if (res["code"] != 10000) {
        Toast.show("${res["message"]}", context);
      }
    }, onError: (error) {
      Toast.show("服务器错误:${error.message}", context);
    }));
  }

  Future get(String path, {Map<String, dynamic> headers}) async {
    try {
      Response response =
          await dio.get(base_url + path, options: Options(headers: headers));
      return response.data as Map<String, dynamic>;
    } on DioError catch (e) {
      Toast.show("${e.toString()}", _context);
    }
  }

  Future post(String path, Map<String, dynamic> params,
      {Map<String, dynamic> headers}) async {
    print("上下文:$_context");
    try {
      Response response = await dio.post(base_url + path,
          queryParameters: params, options: Options(headers: headers));
      return response.data;
    } on DioError catch (e) {
      Toast.show("${e.message}", _context);
    }
  }
}
