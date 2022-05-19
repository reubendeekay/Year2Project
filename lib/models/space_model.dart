import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class SpaceModel {
  String? id;
  final String? spaceName;
  final String? address;
  final String? category;
  final String? description;
  final double? price;
  final String? ownerId;
  final String? size;
  final Map<String, dynamic>? features;
  final int? rentTime;
  final int? likes;
  final GeoPoint? location;
  List<dynamic>? images;
  List<File>? imageFiles;

  SpaceModel({
    this.id,
    this.spaceName,
    this.category,
    this.description,
    this.price,
    this.ownerId,
    this.features,
    this.rentTime,
    this.likes,
    this.size,
    this.address,
    this.location,
    this.images,
    this.imageFiles,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'spaceName': spaceName,
      'category': category,
      'description': description,
      'price': price,
      'ownerId': ownerId,
      'features': features,
      'rentTime': rentTime,
      'likes': likes,
      'size': size,
      'address': address,
      'location': location,
      'images': images,
    };
  }

  factory SpaceModel.fromJson(dynamic json) {
    return SpaceModel(
      id: json.id,
      spaceName: json['spaceName'],
      category: json['category'],
      description: json['description'],
      price: json['price'],
      ownerId: json['ownerId'],
      features: json['features'],
      rentTime: json['rentTime'],
      likes: json['likes'],
      size: json['size'],
      address: json['address'],
      location: json['location'],
      images: json['images'],
    );
  }
}
