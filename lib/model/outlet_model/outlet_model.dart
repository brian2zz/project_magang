// To parse this JSON data, do
//
//     final outletModel = outletModelFromJson(jsonString);

import 'dart:convert';

OutletModel outletModelFromJson(String str) => OutletModel.fromJson(json.decode(str));

class OutletModel {
    OutletModel({
        this.total,
        this.results,
    });

    String? total;
    List<Result>? results;

    factory OutletModel.fromJson(Map<String, dynamic> json) => OutletModel(
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
        this.idFoto,
        this.urlFoto,
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
    String? idFoto;
    String? urlFoto;

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
        idFoto: json["id_foto"],
        urlFoto: json["url_foto"],
    );
}
