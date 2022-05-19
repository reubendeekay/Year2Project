import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rent_space/models/space_model.dart';
import 'package:rent_space/models/user_model.dart';

class TenantModel {
  final UserModel? user;
  final SpaceModel? space;
  final Timestamp? rentedAt;
  final String? id;

  TenantModel({this.user, this.space, this.rentedAt, this.id});

  factory TenantModel.fromJson(dynamic json) {
    return TenantModel(
      user: json['user'] != null ? UserModel.fromJson(json['user']) : null,
      space: json['space'] != null ? SpaceModel.fromJson(json['space']) : null,
      rentedAt: json['rentedAt'],
      id: json.id,
    );
  }
}
