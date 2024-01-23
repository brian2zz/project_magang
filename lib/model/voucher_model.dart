// To parse this JSON data, do
//
//     final voucherModel = voucherModelFromJson(jsonString);

import 'dart:convert';

VoucherModel voucherModelFromJson(String str) => VoucherModel.fromJson(json.decode(str));

String voucherModelToJson(VoucherModel data) => json.encode(data.toJson());

class VoucherModel {
    VoucherModel({
        this.total,
        this.results,
    });

    String? total;
    List<Voucher>? results;

    factory VoucherModel.fromJson(Map<String, dynamic> json) => VoucherModel(
        total: json["total"],
        results: List<Voucher>.from(json["results"].map((x) => Voucher.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "total": total,
        "results": List<dynamic>.from(results!.map((x) => x.toJson())),
    };
}

class Voucher {
    Voucher({
        this.idVoucher,
        this.kodeVoucher,
        this.verifikasiVoucher,
        this.jenisVoucher,
        this.tanpaKodeVoucher,
        this.jenisPromoOngkir,
        this.ongkirFlatRp,
        this.nilaiRp,
        this.nilaiPersen,
        this.nilaiMaxRp,
        this.minimumRp,
        this.tanggalAwal,
        this.tanggalAkhir,
        this.maksimumDigunakan,
        this.custId,
        this.custOpsi,
        this.keterangan,
        this.status,
        this.createdBy,
        this.updatedBy,
        this.deletedBy,
        this.createdAt,
        this.updatedAt,
        this.deletedAt,
        this.tanggalAwalNew,
        this.tanggalAkhirNew,
        this.idFoto,
        this.urlFoto,
    });

    String? idVoucher;
    String? kodeVoucher;
    String? verifikasiVoucher;
    String? jenisVoucher;
    String? tanpaKodeVoucher;
    String? jenisPromoOngkir;
    String? ongkirFlatRp;
    String? nilaiRp;
    String? nilaiPersen;
    String? nilaiMaxRp;
    String? minimumRp;
    DateTime? tanggalAwal;
    DateTime? tanggalAkhir;
    String? maksimumDigunakan;
    String? custId;
    String? custOpsi;
    String? keterangan;
    String? status;
    String? createdBy;
    String? updatedBy;
    dynamic? deletedBy;
    DateTime? createdAt;
    DateTime? updatedAt;
    dynamic? deletedAt;
    String? tanggalAwalNew;
    String? tanggalAkhirNew;
    String? idFoto;
    String? urlFoto;

    factory Voucher.fromJson(Map<String, dynamic> json) => Voucher(
        idVoucher: json["id_voucher"],
        kodeVoucher: json["kode_voucher"],
        verifikasiVoucher: json["verifikasi_voucher"],
        jenisVoucher: json["jenis_voucher"],
        tanpaKodeVoucher: json["tanpa_kode_voucher"],
        jenisPromoOngkir: json["jenis_promo_ongkir"],
        ongkirFlatRp: json["ongkir_flat_rp"],
        nilaiRp: json["nilai_rp"],
        nilaiPersen: json["nilai_persen"],
        nilaiMaxRp: json["nilai_max_rp"],
        minimumRp: json["minimum_rp"],
        tanggalAwal: DateTime.parse(json["tanggal_awal"]),
        tanggalAkhir: DateTime.parse(json["tanggal_akhir"]),
        maksimumDigunakan: json["maksimum_digunakan"],
        custId: json["cust_id"],
        custOpsi: json["cust_opsi"],
        keterangan: json["keterangan"],
        status: json["status"],
        createdBy: json["created_by"],
        updatedBy: json["updated_by"],
        deletedBy: json["deleted_by"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        deletedAt: json["deleted_at"],
        tanggalAwalNew: json["tanggal_awal_new"],
        tanggalAkhirNew: json["tanggal_akhir_new"],
        idFoto: json["id_foto"],
        urlFoto: json["url_foto"],
    );

    Map<String, dynamic> toJson() => {
        "id_voucher": idVoucher,
        "kode_voucher": kodeVoucher,
        "verifikasi_voucher": verifikasiVoucher,
        "jenis_voucher": jenisVoucher,
        "tanpa_kode_voucher": tanpaKodeVoucher,
        "jenis_promo_ongkir": jenisPromoOngkir,
        "ongkir_flat_rp": ongkirFlatRp,
        "nilai_rp": nilaiRp,
        "nilai_persen": nilaiPersen,
        "nilai_max_rp": nilaiMaxRp,
        "minimum_rp": minimumRp,
        "tanggal_awal": "${tanggalAwal!.year.toString().padLeft(4, '0')}-${tanggalAwal!.month.toString().padLeft(2, '0')}-${tanggalAwal!.day.toString().padLeft(2, '0')}",
        "tanggal_akhir": "${tanggalAkhir!.year.toString().padLeft(4, '0')}-${tanggalAkhir!.month.toString().padLeft(2, '0')}-${tanggalAkhir!.day.toString().padLeft(2, '0')}",
        "maksimum_digunakan": maksimumDigunakan,
        "cust_id": custId,
        "cust_opsi": custOpsi,
        "keterangan": keterangan,
        "status": status,
        "created_by": createdBy,
        "updated_by": updatedBy,
        "deleted_by": deletedBy,
        "created_at": createdAt!.toIso8601String(),
        "updated_at": updatedAt!.toIso8601String(),
        "deleted_at": deletedAt,
        "tanggal_awal_new": tanggalAwalNew,
        "tanggal_akhir_new": tanggalAkhirNew,
        "id_foto": idFoto,
        "url_foto": urlFoto,
    };
}
class VoucherUserModel {
    VoucherUserModel({
        this.total,
        this.results,
    });

    String? total;
    List<Result>? results;

    factory VoucherUserModel.fromJson(Map<String, dynamic> json) => VoucherUserModel(
        total: json["total"],
        results: List<Result>.from(json["results"].map((x) => Result.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "total": total,
        "results": List<dynamic>.from(results!.map((x) => x.toJson())),
    };
}

class Result {
    Result({
        this.cvoucherId,
        this.cvoucherCustId,
        this.cvoucherSumber,
        this.cvoucherJdiskonId,
        this.cvoucherVoucherId,
        this.cvoucherTanggalDigunakan,
        this.createdBy,
        this.createdAt,
        this.updatedBy,
        this.updatedAt,
        this.jdiskonJudul,
        this.tanggalBerlaku,
        this.keterangan,
        this.idFoto,
        this.urlFoto,
    });

    String? cvoucherId;
    String? cvoucherCustId;
    String? cvoucherSumber;
    dynamic? cvoucherJdiskonId;
    String? cvoucherVoucherId;
    dynamic? cvoucherTanggalDigunakan;
    String? createdBy;
    DateTime? createdAt;
    dynamic? updatedBy;
    dynamic? updatedAt;
    String? jdiskonJudul;
    String? tanggalBerlaku;
    String? keterangan;
    String? idFoto;
    String? urlFoto;

    factory Result.fromJson(Map<String, dynamic> json) => Result(
        cvoucherId: json["cvoucher_id"],
        cvoucherCustId: json["cvoucher_cust_id"],
        cvoucherSumber: json["cvoucher_sumber"],
        cvoucherJdiskonId: json["cvoucher_jdiskon_id"],
        cvoucherVoucherId: json["cvoucher_voucher_id"],
        cvoucherTanggalDigunakan: json["cvoucher_tanggal_digunakan"],
        createdBy: json["created_by"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedBy: json["updated_by"],
        updatedAt: json["updated_at"],
        jdiskonJudul: json["jdiskon_judul"],
        tanggalBerlaku: json["tanggal_berlaku"],
        keterangan: json["keterangan"],
        idFoto: json["id_foto"],
        urlFoto: json["url_foto"],
    );

    Map<String, dynamic> toJson() => {
        "cvoucher_id": cvoucherId,
        "cvoucher_cust_id": cvoucherCustId,
        "cvoucher_sumber": cvoucherSumber,
        "cvoucher_jdiskon_id": cvoucherJdiskonId,
        "cvoucher_voucher_id": cvoucherVoucherId,
        "cvoucher_tanggal_digunakan": cvoucherTanggalDigunakan,
        "created_by": createdBy,
        "created_at": createdAt!.toIso8601String(),
        "updated_by": updatedBy,
        "updated_at": updatedAt,
        "jdiskon_judul": jdiskonJudul,
        "tanggal_berlaku": tanggalBerlaku,
        "keterangan": keterangan,
        "id_foto": idFoto,
        "url_foto": urlFoto,
    };
}
