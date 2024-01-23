
import 'dart:convert';

import 'package:fusia/server/server_base.dart';
import 'package:http/http.dart' as http;

class OutletNetUtils {

  retrieveOutletList(token) async {
    
    var path = "${ServerBase.serverUrl}/index.php?c=c_cabang&m=cabang_app_list&limit=15";

    Map<String,String> _headers = {
      "Authorization": "Bearer $token",
    };

    var response = await http.get(
      Uri.parse(path),
      headers: _headers,
    ).timeout(ServerBase.durationlimit);

    return response;
  }

  retrieveDetailOutlet(masterId,token) async {

    var path = "${ServerBase.serverUrl}/index.php?c=c_cabang&m=cabang_app_list&limit=15&master_id=$masterId";

    Map<String,String> _headers = {
      "Authorization": "Bearer $token",
    };

    var response = await http.get(
      Uri.parse(path),
      headers: _headers,
    ).timeout(ServerBase.durationlimit);

    return response;
  }
}