// To parse this JSON data, do
//
//     final outletModel = outletModelFromJson(jsonString);

import 'dart:convert';

import 'package:fusia/model/outlet_model/photo_model.dart';

DetailOutletModel detailOutletModelFromJson(String str) => DetailOutletModel.fromJson(json.decode(str));

class DetailOutletModel {
    DetailOutletModel({
        this.total,
        this.results,
    });

    String? total;
    List<Result>? results;

    factory DetailOutletModel.fromJson(Map<String, dynamic> json) => DetailOutletModel(
        total: json["total"],
        results: List<Result>.from(json["results"].map((x) => Result.fromJson(x))),
    );
}

class Result {
    Result({
        this.cabangId,
        this.cabangNama,
        this.cabangAlamat,
        this.cabangKecamatan,
        this.cabangKecamatanId,
        this.cabangKota,
        this.cabangKotaId,
        this.cabangKodepos,
        this.cabangPropinsi,
        this.cabangPropinsiId,
        this.cabangTelp,
        this.cabangKeterangan,
        this.cabangLatitude,
        this.cabangLongitude,
        this.jamBuka,
        this.jamTutup,
        this.statusBuka,
        this.foto,
    });

    String? cabangId;
    String? cabangNama;
    String? cabangAlamat;
    String? cabangKecamatan;
    String? cabangKecamatanId;
    String? cabangKota;
    String? cabangKotaId;
    String? cabangKodepos;
    String? cabangPropinsi;
    String? cabangPropinsiId;
    String? cabangTelp;
    String? cabangKeterangan;
    String? cabangLatitude;
    String? cabangLongitude;
    String? jamBuka;
    String? jamTutup;
    String? statusBuka;
    List<PhotoModel>? foto;

    factory Result.fromJson(Map<String, dynamic> json) => Result(
        cabangId: json["cabang_id"],
        cabangNama: json["cabang_nama"],
        cabangAlamat: json["cabang_alamat"],
        cabangKecamatan: json["cabang_kecamatan"],
        cabangKecamatanId: json["cabang_kecamatan_id"],
        cabangKota: json["cabang_kota"],
        cabangKotaId: json["cabang_kota_id"],
        cabangKodepos: json["cabang_kodepos"],
        cabangPropinsi: json["cabang_propinsi"],
        cabangPropinsiId: json["cabang_propinsi_id"],
        cabangTelp: json["cabang_telp"],
        cabangKeterangan: json["cabang_keterangan"],
        cabangLatitude: json["cabang_latitude"],
        cabangLongitude: json["cabang_longitude"],
        jamBuka: (json["jam_buka"] == null) ? "" : json["jam_buka"],
        jamTutup: (json["jam_tutup"] == null) ? "" : json["jam_tutup"],
        statusBuka: (json["status_buka"] == null) ? "" : json["status_buka"],
        foto: (json["foto"] == null) ? [] : List<PhotoModel>.from(json["foto"].map((x) => PhotoModel.fromJson(x))),
    );

}
