import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

class VisitorModel {
  DateTime? checkIn;
  DateTime? checkOut;

  String? doormanId;
  String? userName;

  //firstName, secondName
  String? floorNum;
  String? id;
  String? idNumber;

  String? imageUrl;
  bool? isCheckedIn;

  bool? isNewsLetterSubscribed;
  String? mobileNumber;
  String? reasonVisit;
  List<VisitorHistoryCheckIn>? vistorCheckInHistoryDocs = [];
  List<VisitorHistoryCheckOut>? vistorCheckOutHistoryDocs = [];
  String? notCheckedOutDocId;
  String? lastDoormanId;

  VisitorModel(
      {this.id,
      this.doormanId,
      this.userName,
      this.mobileNumber,
      this.idNumber,
      this.checkIn,
      this.imageUrl,
      this.isNewsLetterSubscribed,
      this.reasonVisit,
      this.isCheckedIn,
      this.floorNum,
      this.vistorCheckInHistoryDocs,
      this.vistorCheckOutHistoryDocs,
        this.notCheckedOutDocId = '',
        this.lastDoormanId = '',
      this.checkOut});

  VisitorModel fromJson(Map<String, dynamic> snapshot)  {
      return VisitorModel(
          id: snapshot['id'] ?? 'Id empty',
          doormanId: snapshot['doormanId'] ?? 'doorman Id empty',
          userName: "${snapshot['firstName']} ${snapshot['lastName']}",
          mobileNumber: snapshot['mobileNumber'],
          idNumber: snapshot['idNumber'],
          checkIn: snapshot['checkInTime'] != null?(snapshot['checkInTime'] as Timestamp).toDate():null,
          checkOut:  snapshot['checkOutTime'] != null?(snapshot['checkOutTime'] as Timestamp).toDate():null,
          isCheckedIn: snapshot['isCheckedIn'],
          reasonVisit: snapshot['reasonVisit'],
          floorNum: snapshot['floor_office-num'],
          imageUrl: snapshot['imageUrl'],
          isNewsLetterSubscribed: snapshot['isNewsLetterSubscribed'],
        notCheckedOutDocId: snapshot['notCheckedOutDocId'],
          lastDoormanId: snapshot['lastDoormanId']
      );
  }
}

class VisitorHistoryCheckIn {
  Timestamp? checkInTime;
  String? checkInDoormanId;
  String? docId;
  DateTime? date;

  VisitorHistoryCheckIn(
      {this.docId, this.checkInTime, this.date, this.checkInDoormanId});

  factory VisitorHistoryCheckIn.fromJson(Map<String, dynamic> snapshot) =>
      VisitorHistoryCheckIn(
        checkInDoormanId: snapshot['checkInDoormanId'],
        checkInTime: snapshot['checkInTime'],
        docId: snapshot['docId'],
        date: (snapshot['date'] as Timestamp).toDate(),
      );

  Map<String, dynamic> toJson() {
    return {
      'checkInDoormanId': checkInDoormanId,
      'checkInTime': checkInTime,
      'docId': docId,
      'date': date
    };
  }
}

class VisitorHistoryCheckOut {
  Timestamp? checkOutTime;
  String? checkOutDoormanId;
  String? docId;
  DateTime? date;

  VisitorHistoryCheckOut(
      {this.docId, this.checkOutTime, this.checkOutDoormanId, this.date});

  factory VisitorHistoryCheckOut.fromJson(Map<String, dynamic> snapshot) =>
      VisitorHistoryCheckOut(
          docId: snapshot['docId'],
          checkOutDoormanId: snapshot['checkOutDoormanId'],
          checkOutTime: snapshot['checkOutTime'],
          date: (snapshot['date'] as Timestamp).toDate());

  Map<String, dynamic> toJson() {
    return {
      'docId': docId,
      'checkOutDoormanId': checkOutDoormanId,
      'checkOutTime': checkOutTime,
      'date': date
    };
  }
}
