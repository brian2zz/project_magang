

import 'dart:convert';

import 'package:fusia/model/promo_model.dart';
import 'package:fusia/server/network/dashboard_net_utils.dart';
import 'package:get/get.dart';

class DashboardController extends GetxController {
  
    DashboardNetUtils netUtils = Get.put(DashboardNetUtils());

    retrieveDashboard(token,customerId) async {
      var result = await netUtils.retrieveHomeDashboard(token,customerId);

      Map<String,dynamic> out = {};

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
          "details": jsonDecode(result.body),
        };

        //print(out);
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

    retrieveBannerPromo(token) async {

      var result = await netUtils.retrieveBannerPromo(token);

      Map<String,dynamic> out = {};

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
        
        String resultConvert1 = result.body.replaceFirst("(","");
        var resultConvert2 = resultConvert1.replaceRange(resultConvert1.toString().length-1,resultConvert1.toString().length,"");

        out = {
          "status": 200,
          "details": promoModelFromJson(resultConvert2),
        };

        //print(out);
      } else if (result.statusCode == 404) {
        out = {
          "status": 404,
          "details":
              "data banner promo tidak didapatkan. Silahkan menghubungi Administrator untuk lebih lanjut.",
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