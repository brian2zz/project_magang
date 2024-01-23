
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../server_base.dart';

class DashboardNetUtils {

  retrieveHomeDashboard(token,customerId) async {

    var path = "${ServerBase.serverUrl}/index.php?c=c_customer&m=customer_app_list&cust_id=$customerId";

    var response = await http.get(
      Uri.parse(path),
      headers: {
        "content-type": "application/json",
        "Authorization": "Bearer $token",
      },
    );

    return response;
  }

  retrieveBannerPromo(token) async {

    var path = "${ServerBase.serverUrl}/index.php?c=c_promo_app&m=promo_app_list&limit=20";

    Map<String,String> _headers = {
      "Authorization": "Bearer $token",
    };

    var response = await http.get(
      Uri.parse(path),
      headers: _headers,
    );

    return response;
  }
}