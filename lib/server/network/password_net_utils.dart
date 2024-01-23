import 'dart:convert';
import 'package:get/get_connect/http/src/status/http_status.dart';
import 'package:http/http.dart' as http;

class PasswordNetUtils {
  static var serverUrl = "http://dev.koffiesoft.com/fusia_test";

  static var durationlimit = const Duration(seconds: 30);

  retrievePassword(customerId, oldPassword, newPassword) async {
    Map<String, dynamic> bodyparams = {
      "cust_id": customerId,
      "old_password": oldPassword ?? "",
      "new_password": newPassword ?? "",
    };
    var path = "$serverUrl/index.php?c=c_login&m=change_password";

    var response = await http
        .post(
          Uri.parse(path),
          body: bodyparams,
        )
        .timeout(durationlimit);

    return response;
  }
}
