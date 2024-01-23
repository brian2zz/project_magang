// To parse this JSON data, do
//
//     final dataAccountModel = dataAccountModelFromJson(jsonString);

import 'dart:convert';

import 'foto_model.dart';

DataAccountModel dataAccountModelFromJson(String str) => DataAccountModel.fromJson(json.decode(str));

class DataAccountModel {
    DataAccountModel({
        this.custId,
        this.custNama,
        this.statusUser,
        this.custHp,
        this.custEmail,
        this.custTgllahir,
        this.custMembership,
        this.custPoint,
        this.custPrewardTotal,
        this.foto,
    });

    String? custId;
    String? custNama;
    String? statusUser;
    String? custHp;
    String? custEmail;
    String? custTgllahir;
    String? custMembership;
    String? custPoint;
    String? custPrewardTotal;
    Foto? foto;

    factory DataAccountModel.fromJson(Map<String, dynamic> json) => DataAccountModel(
        custId: json["cust_id"],
        custNama: json["cust_nama"],
        statusUser: json["status_user"],
        custHp: json["cust_hp"],
        custEmail: json["cust_email"],
        custTgllahir: json["cust_tgllahir"],
        custMembership: json["cust_membership"],
        custPoint: json["cust_point"],
        custPrewardTotal: json["cust_preward_total"],
        foto: Foto.fromJson(json["foto"]),
    );
}
