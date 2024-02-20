import 'package:cloud_firestore/cloud_firestore.dart';

class BuildingModel{
  String? id;
  String? buildingName;
  String? address;
  bool? isActive;
  DateTime? createdAt;
  DateTime? updatedAt;
  BuildingModel({this.id,this.buildingName,this.address,this.isActive,this.createdAt,this.updatedAt});

  factory BuildingModel.fromJson(Map<String, dynamic> snapshot) => BuildingModel(
      id : snapshot['id']??'idPataNi',
      buildingName : snapshot['name']??'pta ni name',
      address: snapshot['address']??'addressPtaNi',
      isActive: snapshot['isActive']??'activeHai',
      createdAt: (snapshot['createdAt'] as Timestamp).toDate(),
      updatedAt: (snapshot['updatedAt'] as Timestamp).toDate()
  );


}