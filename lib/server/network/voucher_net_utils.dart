import 'dart:convert';

import 'package:http/http.dart' as http;

class VoucherNetUtils {
  static var serverUrl = "http://dev.koffiesoft.com/fusia_test";
  static var durationlimit = const Duration(seconds: 30);

  retrieveVoucherList(token, customerId) async {
    // print(token);
    var path = "$serverUrl/index.php?c=c_voucher&m=voucher_list&limit=100";

    var response = await http.get(
      Uri.parse(path),
      headers: {
        "content-type": "application/json",
        "Authorization": "Bearer $token",
      },
    );

    // print(json.decode(response.body));

    return response;
  }

  retrieveVoucherListUser(token, customerId) async {
    // print(token);
    var path =
        "$serverUrl/index.php?c=c_voucher&customer_id=$customerId&m=get_customer_voucher";

    var response = await http.get(
      Uri.parse(path),
      headers: {
        "content-type": "application/json",
        "Authorization": "Bearer $token",
      },
    );

    // print(json.decode(response.body));

    return response;
  }
}
