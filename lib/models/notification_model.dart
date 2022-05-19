import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationModel {
  final String? id;
  final String? imageUrl;
  final String? title;
  final String? message;
  final Timestamp? createdAt;

  NotificationModel(
      {this.id, this.imageUrl, this.title, this.message, this.createdAt});

  factory NotificationModel.fromJson(dynamic json) {
    return NotificationModel(
      id: json.id,
      imageUrl: json['imageUrl'],
      title: json['title'],
      message: json['message'],
      createdAt: json['createdAt'],
    );
  }

  Map<String, dynamic> toJson() => {
        'imageUrl': imageUrl,
        'title': title,
        'message': message,
        'createdAt': createdAt,
      };
}
