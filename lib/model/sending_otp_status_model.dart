import 'dart:convert';

SendingOtpStatus sendingOtpStatusFromJson(String str) =>
    SendingOtpStatus.fromJson(json.decode(str));

class SendingOtpStatus {
  SendingOtpStatus({
    this.sendingRespon,
  });

  List<SendingRespon>? sendingRespon;

  factory SendingOtpStatus.fromJson(Map<String, dynamic> json) =>
      SendingOtpStatus(
        sendingRespon: List<SendingRespon>.from(
            json["sending_respon"].map((x) => SendingRespon.fromJson(x)) ?? []),
      );
}

class SendingRespon {
  SendingRespon({
    this.globalstatus,
    this.globalstatustext,
    this.datapacket,
  });

  int? globalstatus;
  String? globalstatustext;
  List<Datapacket>? datapacket;

  factory SendingRespon.fromJson(Map<String, dynamic> json) => SendingRespon(
        globalstatus: json["globalstatus"],
        globalstatustext: json["globalstatustext"],
        datapacket: List<Datapacket>.from(
            json["datapacket"].map((x) => Datapacket.fromJson(x))),
      );
}

class Datapacket {
  Datapacket({
    this.packet,
  });

  Packet? packet;

  factory Datapacket.fromJson(Map<String, dynamic> json) => Datapacket(
        packet: Packet.fromJson(json["packet"]),
      );
}

class Packet {
  Packet({
    this.number,
    this.sendingid,
    this.sendingstatus,
    this.sendingstatustext,
    this.price,
    this.sendername,
  });

  String? number;
  int? sendingid;
  int? sendingstatus;
  String? sendingstatustext;
  int? price;
  String? sendername;

  factory Packet.fromJson(Map<String, dynamic> json) => Packet(
        number: json["number"],
        sendingid: json["sendingid"],
        sendingstatus: json["sendingstatus"],
        sendingstatustext: json["sendingstatustext"],
        price: json["price"],
        sendername: json["sendername"],
      );
}
