import 'package:dio/dio.dart';
import 'package:fabiaoqing/common/api_result_code.dart';
import 'package:fabiaoqing/common/common_user.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

//const base_url = "http://172.24.32.98:8080/";
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
      if (res["code"] != REQUEST_SUCCESS) {
        Toast.show("${res["message"]}", context, gravity: Toast.CENTER);
      }
      if (res["code"] == LOGIN_EXPIRED) {
        CommonUser.getInstance().logout();
      }
    }, onError: (error) {
      Toast.show("服务器错误:${error.message}", context, gravity: Toast.CENTER);
    }));
  }

  Future get(String path, {Map<String, dynamic> headers}) async {
    try {
      Response response =
          await dio.get(base_url + path, options: Options(headers: headers));
      return response.data as Map<String, dynamic>;
    } on DioError catch (e) {
      Toast.show("${e.toString()}", _context, gravity: Toast.CENTER);
    }
  }

  Future post(String path, Map<String, dynamic> data,
      {Map<String, dynamic> headers}) async {
    try {
      Response response = await dio.post(base_url + path,
          queryParameters: data, options: Options(headers: headers));
      return response.data;
    } on DioError catch (e) {
      Toast.show("${e.message}", _context, gravity: Toast.CENTER);
    }
  }

  Future filePost(String path, FormData formData,
      {Map<String, dynamic> headers}) async {
    try {
      Response response = await dio.post(base_url + path,
          data: formData, options: Options(headers: headers));
      return response.data;
    } on DioError catch (e) {
      Toast.show("${e.message}", _context, gravity: Toast.CENTER);
    }
  }
}
