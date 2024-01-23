import 'dart:convert';

import 'package:fusia/model/promo_model.dart';
import 'package:fusia/server/local/local_server.dart';
import 'package:fusia/server/network/promo_net_utils.dart';
import 'package:get/get.dart';

class PromoController extends GetxController {
  PromoNetUtils netUtils = Get.put(PromoNetUtils());
  LocalUtils localUtils = Get.put(LocalUtils());

  static var promoId = "".obs;

  requestPromoId(promoId) async {
    await localUtils.storePromoPromoId(promoId);
  }

  retrievePromoId() async {
    await localUtils.retrievePromoPromoId();

    promoId.value = LocalUtils.promoIdPromo.value;
  }

  retrievePromoList(token) async {
    var result = await netUtils.retrievePromoList(token);

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
            "Data Cabang tidak didapatkan. Silahkan menghubungi Administrator untuk lebih lanjut.",
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

  DetailPromo(token, idPromo) async {
    print(idPromo);
    var result = await netUtils.DetailPromo(token, idPromo);

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
      var resultConvert1 = result.body.replaceAll("(", "");
      var resultConvert2 = resultConvert1.replaceAll(")", "");
      out = {
        "status": 200,
        "details": jsonDecode(resultConvert2),
      };
    } else if (result.statusCode == 404) {
      out = {
        "status": 404,
        "details":
            "Data Cabang tidak didapatkan. Silahkan menghubungi Administrator untuk lebih lanjut.",
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
