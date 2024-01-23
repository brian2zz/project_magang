import 'dart:convert';
import 'package:fusia/model/voucher_model.dart';
import 'package:fusia/server/network/voucher_net_utils.dart';
import 'package:get/get.dart';

class VoucherController extends GetxController {
  VoucherNetUtils netUtils = Get.put(VoucherNetUtils());

  retrieveVouchers(token, customerId) async {
    var result = await netUtils.retrieveVoucherList(token, customerId);

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
      // // var decodeList =
      // jsonDecode(result.body.replaceAll("(", "").replaceAll(")", "")),
      // var listEn = jsonDecode(result.body);
      // jsonEncode(result.body.replaceAll("(", "").replaceAll(")", "")),
      out = {
        "status": 200,
        "details": jsonDecode(resultConvert2),
        // "list": decodeList['results'] as List,
      };
      print(jsonDecode(resultConvert2)['results']);

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

  retrieveVoucherUser(token, customerId) async {
    var result = await netUtils.retrieveVoucherListUser(token, customerId);
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
      // // var decodeList =
      // jsonDecode(result.body.replaceAll("(", "").replaceAll(")", "")),
      // var listEn = jsonDecode(result.body);
      // jsonEncode(result.body.replaceAll("(", "").replaceAll(")", "")),
      out = {
        "status": 200,
        "details": jsonDecode(resultConvert2),
        // "list": decodeList['results'] as List,
      };
      print(jsonDecode(resultConvert2)['results']);

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
}
