// To parse this JSON data, do
//
//     final menuModel = menuModelFromJson(jsonString);

import 'dart:convert';

MenuModel menuModelFromJson(String str) => MenuModel.fromJson(json.decode(str));

String menuModelToJson(MenuModel data) => json.encode(data.toJson());

class MenuModel {
    MenuModel({
        this.total,
        this.results,
    });

    String? total;
    List<ResultMenu>? results;

    factory MenuModel.fromJson(Map<String, dynamic> json) => MenuModel(
        total: json["total"],
        results: List<ResultMenu>.from(json["results"].map((x) => ResultMenu.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "total": total,
        "results": List<dynamic>.from(results!.map((x) => x.toJson())),
    };
}

class ResultMenu {
    ResultMenu({
        this.produkId,
        this.satuanId,
        this.produkNama,
        this.satuanKode,
    });

    String? produkId;
    String? satuanId;
    String? produkNama;
    String? satuanKode;

    factory ResultMenu.fromJson(Map<String, dynamic> json) => ResultMenu(
        produkId: json["produk_id"],
        satuanId: json["satuan_id"],
        produkNama: json["produk_nama"],
        satuanKode: json["satuan_kode"],
    );

    Map<String, dynamic> toJson() => {
        "produk_id": produkId,
        "satuan_id": satuanId,
        "produk_nama": produkNama,
        "satuan_kode": satuanKode,
    };
}
