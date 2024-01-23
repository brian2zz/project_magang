// To parse this JSON data, do
//
//     final promoModel = promoModelFromJson(jsonString);

import 'dart:convert';

PromoModel promoModelFromJson(String str) => PromoModel.fromJson(json.decode(str));

class PromoModel {
    PromoModel({
        this.total,
        this.results,
    });

    String? total;
    List<Promo>? results;

    factory PromoModel.fromJson(Map<String, dynamic> json) => PromoModel(
        total: json["total"],
        results: List<Promo>.from(json["results"].map((x) => Promo.fromJson(x))),
    );
}

class Promo {
    Promo({
        this.idPromoApp,
        this.tanggalAwal,
        this.tanggalAkhir,
        this.fotoPath,
        this.judul,
        this.jenisPromo,
        this.produkId,
        this.voucherId,
        this.keterangan,
        this.createdAt,
        this.updatedAt,
        this.deletedAt,
        this.createdBy,
        this.updatedBy,
        this.deletedBy,
        this.produkNama,
        this.kodeVoucher,
        this.tanggalAwalNew,
        this.tanggalAkhirNew,
        this.urlFoto,
    });

    String? idPromoApp;
    String? tanggalAwal;
    String? tanggalAkhir;
    String? fotoPath;
    String? judul;
    String? jenisPromo;
    String? produkId;
    String? voucherId;
    String? keterangan;
    String? createdAt;
    String? updatedAt;
    String? deletedAt;
    String? createdBy;
    String? updatedBy;
    String? deletedBy;
    String? produkNama;
    String? kodeVoucher;
    String? tanggalAwalNew;
    String? tanggalAkhirNew;
    String? urlFoto;

    factory Promo.fromJson(Map<String, dynamic> json) => Promo(
        idPromoApp: json["id_promo_app"],
        tanggalAwal: json["tanggal_awal"],
        tanggalAkhir: json["tanggal_akhir"],
        fotoPath: json["foto_path"],
        judul: json["judul"],
        jenisPromo: json["jenis_promo"],
        produkId: json["produk_id"],
        voucherId: json["voucher_id"],
        keterangan: json["keterangan"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
        deletedAt: json["deleted_at"],
        createdBy: json["created_by"],
        updatedBy: json["updated_by"],
        deletedBy: json["deleted_by"],
        produkNama: json["produk_nama"],
        kodeVoucher: json["kode_voucher"],
        tanggalAwalNew: json["tanggal_awal_new"],
        tanggalAkhirNew: json["tanggal_akhir_new"],
        urlFoto: json["url_foto"],
    );

}
