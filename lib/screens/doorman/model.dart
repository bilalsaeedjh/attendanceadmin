import 'package:cloud_firestore/cloud_firestore.dart';

class DoormanModel {
  String? id;
  String? idNumber;
  String? mobileNumber;
  String? password;
  String? userName;
  String? doormanName;
  String? buildingName;
  String? buildingId;
  bool? isActive;
  DateTime? createdAt;
  DateTime? updatedAt;

  DoormanModel(
      {this.id,
      this.doormanName,
      this.buildingName,
      this.buildingId,
      this.userName,
      this.password,
      this.mobileNumber,
      this.idNumber,
      this.isActive,
      this.createdAt,
      this.updatedAt});

  factory DoormanModel.fromJson(Map<String, dynamic> snapshot) => DoormanModel(
      id: snapshot['id'],
      doormanName: snapshot['doormanName'],
      buildingName: snapshot['buildingName'],
      buildingId: snapshot['buildingId'],
      userName: snapshot['userName'],
      password: snapshot['password'],
      mobileNumber: snapshot['mobileNumber'],
      idNumber: snapshot['idNumber'],
      isActive: snapshot['isActive'],
      createdAt: (snapshot['createdAt'] as Timestamp).toDate(),
      updatedAt: (snapshot['updatedAt'] as Timestamp).toDate()
  );

  Map<String,dynamic> toJson(){
    return{
      'id': id,
      'doormanName': doormanName,
      'buildingName': buildingName,
      'buildingId': buildingId,
      'userName':userName,
      'password': password,
      'mobileNumber': mobileNumber,
      'idNumber': idNumber,
      'isActive': isActive,
      'createdAt':DateTime.now(),
      'updatedAt':DateTime.now()
    };
  }
}
