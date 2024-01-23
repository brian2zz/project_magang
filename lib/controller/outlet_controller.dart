
import 'dart:convert';

import 'package:fusia/model/outlet_model.dart';
import 'package:fusia/model/outlet_model/detail_outlet_model.dart';
import 'package:fusia/server/local/local_server.dart';
import 'package:fusia/server/network/outlet_net_utils.dart';
import 'package:get/get.dart';

class OutletController extends GetxController {

  OutletNetUtils netUtils = Get.put(OutletNetUtils());
  LocalUtils localUtils = Get.put(LocalUtils());

  static final masterIdOutlet1 = "".obs;

  storedMasterId(masterId) async {
    await localUtils.storeOutletMasterID(masterId);
  }

  retrieveMasterId() async {
    await localUtils.retrieveOutletMasterID();

    masterIdOutlet1.value = LocalUtils.masterIdOutlet.value;
  }  

  retrieveOutletListController(token) async {
    var result = await netUtils.retrieveOutletList(token);

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
      
      var resultConvert1 = result.body.replaceAll("(","");
      var resultConvert2 = resultConvert1.replaceAll(")","");

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

  retrieveDetailOutletController(masterId, token) async {
    var result = await netUtils.retrieveDetailOutlet(masterId, token);

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
      
      String resultConvert1 = result.body.replaceFirst("(","");
      var resultConvert2 = resultConvert1.replaceRange(resultConvert1.toString().length-1,resultConvert1.toString().length,"");
      
      print(resultConvert2.toString());

      out = {
        "status": 200,
        "details": detailOutletModelFromJson(resultConvert2),
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