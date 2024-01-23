import 'dart:convert';
import 'package:get/get_connect/http/src/status/http_status.dart';
import 'package:http/http.dart' as http;

class ReservationNetUtils {
  static var serverUrl = "http://dev.koffiesoft.com/fusia";

  static var durationlimit = const Duration(seconds: 30);

  retrieveReservation(paramsdata) async {
    Map<String, dynamic> bodyparams = {
      "res_cust_id": paramsdata['customerId'],
      "res_tanggal": paramsdata['tanggal'],
      "res_jam": paramsdata['waktu'],
      "res_durasi": '20',
      "res_gudang_id": '6',
      "res_keterangan": paramsdata['keterangan'],
      "res_est_jml_org": paramsdata['jumlahOrang'],
      "dres_id": '0',
      "dres_produk_id": '12',
      "dres_jumlah": "5",
    };
    var path = "$serverUrl/index.php?c=c_reservasi&m=reservasi_create_app";

    var response = await http
        .post(
          Uri.parse(path),
          headers: {
            'Content-Type': 'application/json;charset=UTF-8',
            'Charset': 'utf-8',
            "Authorization": "Bearer ${paramsdata['token']}"
          },
          body: bodyparams,
        )
        .timeout(durationlimit);
    print(response);
    return response;
  }

  retrieveMenuList(token, customerId) async {
    // print(token);
    var path = "$serverUrl/index.php?c=c_reservasi&m=get_produk_list_app";

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
