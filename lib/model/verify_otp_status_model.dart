// To parse this JSON data, do
//
//     final verifyOtpStatus = verifyOtpStatusFromJson(jsonString);

import 'dart:convert';

VerifyOtpStatus verifyOtpStatusFromJson(String str) =>
    VerifyOtpStatus.fromJson(json.decode(str));

class VerifyOtpStatus {
  VerifyOtpStatus({
    this.status,
    this.code,
    this.databody,
    this.fcmToken,
    this.custNama,
    this.custId,
    this.userId,
    this.token,
    this.jnsKelamin,
    this.custMembershipId,
    this.custMembership,
  });

  String? status;
  int? code;
  String? databody;
  String? fcmToken;
  String? custNama;
  String? custId;
  String? userId;
  String? token;
  String? jnsKelamin;
  String? custMembershipId;
  String? custMembership;

  factory VerifyOtpStatus.fromJson(Map<String, dynamic> json) =>
      VerifyOtpStatus(
        status: json["status"],
        code: json["code"],
        databody: json["databody"],
        fcmToken: json["fcm_token"],
        custNama: json["cust_nama"],
        custId: json["cust_id"],
        userId: json["user_id"],
        token: json["token"],
        jnsKelamin: json["jns_kelamin"],
        custMembershipId: json["cust_membership_id"],
        custMembership: json["cust_membership"],
      );
}
