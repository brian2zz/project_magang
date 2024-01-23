import 'dart:convert';
import 'package:get/get_connect/http/src/status/http_status.dart';
import 'package:http/http.dart' as http;

class UpdateInfoNetUtils {
  static var serverUrl = "http://dev.koffiesoft.com/fusia_test";

  static var durationlimit = const Duration(seconds: 30);

  retrieveUpdate(paramsdata) async {
    Map<String, dynamic> bodyparams = {
      "cust_nama": paramsdata['nama'],
      "cust_email": paramsdata['Email'],
      "cust_hp": paramsdata['phone'],
      "cust_tgllahir": paramsdata['datebirth'],
    };
    var path =
        "$serverUrl/index.php?c=c_customer&m=update_acc_info&id=${paramsdata['id']}";

    var response = await http
        .post(
          Uri.parse(path),
          body: bodyparams,
        )
        .timeout(durationlimit);

    return response;
  }
}
