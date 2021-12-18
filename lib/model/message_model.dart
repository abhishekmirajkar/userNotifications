// To parse this JSON data, do
//
//     final messageModel = messageModelFromJson(jsonString);

import 'dart:convert';

MessageModel messageModelFromJson(String str) => MessageModel.fromJson(json.decode(str));

String messageModelToJson(MessageModel data) => json.encode(data.toJson());

class MessageModel {
  MessageModel({
    this.deptId,
    this.batchId,
    this.adminId,
    this.divId,
    this.cateId,
    this.date,
    this.admin,
    this.messageData,
  });

  String deptId;
  String batchId;
  String adminId;
  String divId;
  String cateId;
  String date;
  String admin;
  String messageData;

  factory MessageModel.fromJson(Map<String, dynamic> json) => MessageModel(
    deptId: json["deptId"],
    batchId: json["batchId"],
    adminId: json["adminId"],
    divId: json["divId"],
    cateId: json["cateId"],
    date: json["date"],
    admin: json["admin"],
    messageData: json["messageData"],
  );

  Map<String, dynamic> toJson() => {
    "deptId": deptId,
    "batchId": batchId,
    "adminId": adminId,
    "divId": divId,
    "messageData": messageData,
  };
}
