// To parse this JSON data, do
//
//     final dashboardModel = dashboardModelFromJson(jsonString);

import 'dart:convert';

DashboardModel dashboardModelFromJson(String str) => DashboardModel.fromJson(json.decode(str));

class DashboardModel {
    DashboardModel({
        this.status,
        this.code,
        this.databody,
    });

    String? status;
    int? code;
    Databody? databody;

    factory DashboardModel.fromJson(Map<String, dynamic> json) => DashboardModel(
        status: json["status"],
        code: json["code"],
        databody: Databody.fromJson(json["databody"]),
    );
}

class Databody {
    Databody({
        this.custId,
        this.custNama,
        this.statusUser,
        this.custHp,
        this.custEmail,
        this.custTgllahir,
        this.custMembership,
    });

    String? custId;
    String? custNama;
    String? statusUser;
    String? custHp;
    String? custEmail;
    String? custTgllahir;
    String? custMembership;

    factory Databody.fromJson(Map<String, dynamic> json) => Databody(
        custId: json["cust_id"],
        custNama: json["cust_nama"],
        statusUser: json["status_user"],
        custHp: json["cust_hp"],
        custEmail: json["cust_email"],
        custTgllahir: json["cust_tgllahir"],
        custMembership: json["cust_membership"],
    );
}
