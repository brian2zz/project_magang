import 'dart:convert';
import 'package:fusia/server/server_base.dart';
import 'package:get/get_connect/http/src/status/http_status.dart';
import 'package:http/http.dart' as http;

class LoginNetUtils {

  requestLoginNetUtils(phone) async {
    Map<String, dynamic> bodyparams = {
      "phone_number": phone,
    };

    var response = await http
        .post(
          Uri.parse("${ServerBase.serverUrl}/index.php?c=c_login&m=verify_fusia"),
          body: bodyparams,
        )
        .timeout(ServerBase.durationlimit);

    return response;
  }

  verifyOTPNetUtils(phone, code) async {
    print(phone);

    Map<String, dynamic> bodyparams = {
      "phone_number": phone,
      "code": code,
    };

    var response = await http
        .post(
          Uri.parse("${ServerBase.serverUrl}/index.php?c=c_login&m=verify_otp"),
          body: bodyparams,
        )
        .timeout(ServerBase.durationlimit);

    return response;
  }

  sendOTPNetUtils(phone) async {
    Map<String, dynamic> bodyparams = {
      "phone_number": phone,
    };

    var response = await http
        .post(
          Uri.parse('${ServerBase.serverUrl}/index.php?c=c_login&m=sendOTP'),
          body: bodyparams,
        )
        .timeout(ServerBase.durationlimit);

    return response;
  }

  requestCreateAccount(paramsdata) async {
    Map<String, dynamic> bodyparams = {
      "cust_nama": paramsdata["fullname"],
      "cust_email": paramsdata["email"],
      "cust_tgllahir": paramsdata["datebirth"],
      "cust_hp": paramsdata["phone"],
      "stat_user": "1",
      "cust_app_check": "1",
    };

    print(bodyparams.toString());

    var response = await http
        .post(
          Uri.parse("${ServerBase.serverUrl}/index.php?c=c_customer&m=customer_create_app"),
          body: bodyparams,
        )
        .timeout(ServerBase.durationlimit);

    return response;
  }
}
