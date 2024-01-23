import 'dart:convert';

import 'package:fusia/server/local/local_server.dart';
import 'package:fusia/server/network/login_net_utils.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  LoginNetUtils netutils = Get.put(LoginNetUtils());
  LocalUtils localUtils = Get.put(LocalUtils());

  static var userToken = "".obs;
  static var customerId = "".obs;
  static var isLogin = "".obs;

  //LOCAL DATA//

  storedUserLocalData(statusLogin,token,customerId) async {
    await localUtils.storeUserLocal(statusLogin,token, customerId);
  }

  retrieveUserLocalData() async {
    await localUtils.retrieveUserLocal();

    userToken.value = LocalUtils.token.value;
    customerId.value = LocalUtils.customerId.value;
  }

  retrieveUserIsLogin() async {
    await localUtils.retrieveIsLogin();

    isLogin.value = LocalUtils.statusLogin.value;
  }

  clearData() async {
    await localUtils.clearData();

    userToken.value = "";
    customerId.value = "";
    isLogin.value = "";
  }

  
  //NETWORK//

  requestLoginController(phone) async {
    var result = await netutils.requestLoginNetUtils(phone);

    Map<String, dynamic> out = {};

    if (result == 'ReqTimeOut') {
      out = {
        "status": 1,
        "details": "Request Time Out",
      };
    } else if (result == "SocketConnProblem") {
      out = {
        "status": 1,
        "details":
            "Koneksi internet anda bermasalah. Silahkan cek jaringan anda kembali.",
      };
    } else if (result.statusCode == 200) {
      out = {
        "status": 200,
        "details": jsonDecode(result.body),
      };
    } else if (result.statusCode == 404) {
      out = {
        "status": 404,
        "details":
            "login gagal dilakukan. Silahkan menghubungi Administrator untuk lebih lanjut.",
      };
    } else {
      out = {
        "status": result.statusCode,
        "details":
            "Terjadi gangguan ketika mengambil data. Silahkan menghubungi Administrator untuk lebih lanjut.",
      };
    }
    return out;
  }

  verifyOTPController(phone, code) async {
    var result = await netutils.verifyOTPNetUtils(phone, code);

    Map<String, dynamic> out = {};

    if (result == 'ReqTimeOut') {
      out = {
        "status": 1,
        "details": "Request Time Out",
      };
    } else if (result == "SocketConnProblem") {
      out = {
        "status": 1,
        "details":
            "Koneksi internet anda bermasalah. Silahkan cek jaringan anda kembali.",
      };
    } else if (result.statusCode == 200) {
      out = {
        "status": 200,
        "details": jsonDecode(result.body),
      };
    } else if (result.statusCode == 404) {
      out = {
        "status": 404,
        "details":
            "login gagal dilakukan. Silahkan menghubungi Administrator untuk lebih lanjut.",
      };
    } else {
      out = {
        "status": result.statusCode,
        "details":
            "Terjadi gangguan ketika mengambil data. Silahkan menghubungi Administrator untuk lebih lanjut.",
      };
    }
    return out;
  }

  registerAccountController(paramsdata) async {
    var result = await netutils.requestCreateAccount(paramsdata);

    Map<String, dynamic> out = {};

    if (result == 'ReqTimeOut') {
      out = {
        "status": 1,
        "details": "Request Time Out",
      };
    } else if (result == "SocketConnProblem") {
      out = {
        "status": 1,
        "details":
            "Koneksi internet anda bermasalah. Silahkan cek jaringan anda kembali.",
      };
    } else if (result.statusCode == 200) {
      out = {
        "status": 200,
        "details": jsonDecode(result.body),
      };
      print(out.toString());
    } else if (result.statusCode == 404) {
      out = {
        "status": 404,
        "details":
            "login gagal dilakukan. Silahkan menghubungi Administrator untuk lebih lanjut.",
      };
    } else if (result) {

    } else {
      out = {
        "status": result.statusCode,
        "details":
            "Terjadi gangguan ketika mengambil data. Silahkan menghubungi Administrator untuk lebih lanjut.",
      };
    }
    return out;
  }

  reSendOTPController(phone) async {
    var result = await netutils.sendOTPNetUtils(phone);

    Map<String, dynamic> out = {};

    if (result == 'ReqTimeOut') {
      out = {
        "status": 1,
        "details": "Request Time Out",
      };
    } else if (result == "SocketConnProblem") {
      out = {
        "status": 1,
        "details":
            "Koneksi internet anda bermasalah. Silahkan cek jaringan anda kembali.",
      };
    } else if (result.statusCode == 200) {
      out = {
        "status": 200,
        "details": jsonDecode(result.body),
      };
    } else if (result.statusCode == 404) {
      out = {
        "status": 404,
        "details":
            "kirim ulang otp gagal dilakukan. Silahkan menghubungi Administrator untuk lebih lanjut.",
      };
    } else {
      out = {
        "status": result.statusCode,
        "details":
            "Terjadi gangguan ketika mengambil data. Silahkan menghubungi Administrator untuk lebih lanjut.",
      };
    }
    return out;
  }
}
