import 'dart:convert';
import 'package:get/get_connect/http/src/status/http_status.dart';
import 'package:http/http.dart' as http;

class PhotoNetUtils {
  static var serverUrl = "http://dev.koffiesoft.com/fusia_test";

  static var durationlimit = const Duration(seconds: 30);

  retrievePhoto(customerId, PhotoName,base64Image,idFoto) async {
    Map<String, dynamic> bodyparams = {
      "cust_id": customerId,
      "cfoto_path": "${PhotoName}",
      "cfoto_id": idFoto,
      "cfoto_default": 'true',
      "cfoto_file_base64": base64Image,
    };
    var path = "$serverUrl/index.php?c=c_customer&m=customer_photo_insert";

    var response = await http
        .post(
          Uri.parse(path),
          body: bodyparams,
        )
        .timeout(durationlimit);

    return response;
  }
}
