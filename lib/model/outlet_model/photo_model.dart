// To parse this JSON data, do
//
//     final outletModel = outletModelFromJson(jsonString);

import 'dart:convert';

PhotoModel outletModelFromJson(String str) => PhotoModel.fromJson(json.decode(str));

class PhotoModel {
    PhotoModel({
        this.id,
        this.urlFoto,
        this.jenis,
    });

    String? id;
    String? urlFoto;
    String? jenis;

    factory PhotoModel.fromJson(Map<String, dynamic> json) => PhotoModel(
        id: json["id"],
        urlFoto: json["url_foto"],
        jenis: json["jenis"],
    );
}
