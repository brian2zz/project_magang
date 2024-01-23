import 'dart:convert';

import 'package:fusia/server/server_base.dart';
import 'package:http/http.dart' as http;

class PromoNetUtils {
  retrievePromoList(token) async {
    var path =
        "${ServerBase.serverUrl}/index.php?c=c_promo_app&m=promo_app_list&limit=20";

    Map<String, String> _headers = {
      "Authorization": "Bearer $token",
    };

    var response = await http.get(
      Uri.parse(path),
      headers: _headers,
    );

    return response;
  }
  DetailPromo(token,idPromo) async {
    var path =
        "${ServerBase.serverUrl}/index.php?c=c_promo_app&m=promo_app_list&limit=1&id_promo_app=${idPromo}";

    Map<String, String> _headers = {
      "Authorization": "Bearer $token",
    };
    var response = await http.get(
      Uri.parse(path),
      headers: _headers,
    );

    return response;
  }
}
