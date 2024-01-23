import 'dart:convert';

import 'package:fusia/server/local/local_server.dart';
import 'package:fusia/server/network/reservation_net_utils.dart';
import 'package:get/get.dart';

class ReservationController extends GetxController {
  ReservationNetUtils reservationUtils = Get.put(ReservationNetUtils());
  ReservationNetUtils menuUtils = Get.put(ReservationNetUtils());

  SendReservation(paramsdata) async {
    var result = await reservationUtils.retrieveReservation(paramsdata);
    print(jsonDecode(jsonEncode(result.body)));
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
        "details": result.body,
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


  retrieveMenuList(token, customerId) async {
    var result = await menuUtils.retrieveMenuList(token, customerId);
    // print(result);

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
      var resultConvert1 = result.body.replaceAll("({", "{");
      var resultConvert2 = resultConvert1.replaceAll("})", "}");
      
      out = {
        "status": 200,
        "details": jsonDecode(resultConvert2),
      };

    } else if (result.statusCode == 404) {
      out = {
        "status": 404,
        "details":
            "data user gagal didapatkan. Silahkan menghubungi Administrator untuk lebih lanjut.",
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
