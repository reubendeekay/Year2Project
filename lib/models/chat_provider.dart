import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:rent_space/models/message_model.dart';
import 'package:rent_space/models/user_model.dart';

class ChatTileModel {
  final UserModel? user;
  String? latestMessage;
  Timestamp? time;
  final String? latestMessageSenderId;
  final String? chatRoomId;

  ChatTileModel({
    this.user,
    this.latestMessage,
    this.time,
    this.chatRoomId,
    this.latestMessageSenderId,
  });
}

class ChatProvider with ChangeNotifier {
  List<ChatTileModel> _contactedUsers = [];

  List<ChatTileModel> get contactedUsers => [..._contactedUsers];

  /////////////////SEND MESSAGE////////////////////////
  Future<void> sendMessage(
      String toUserId, String fromUserId, MessageModel message) async {
    final uid = fromUserId;
    String url = '';

    if (message.mediaFiles!.isNotEmpty) {
      await Future.forEach(message.mediaFiles!, (File element) async {
        final fileData = await FirebaseStorage.instance
            .ref('chatFiles/$uid/${DateTime.now().toIso8601String()}')
            .putFile(element);
        url = await fileData.ref.getDownloadURL();
      }).then((_) async {
        final initiator = FirebaseFirestore.instance
            .collection('chats')
            .doc(uid + '_' + toUserId);
        final receiver = FirebaseFirestore.instance
            .collection('chats')
            .doc(toUserId + '_' + uid);

        initiator.get().then((value) => {
              if (value.exists)
                {
                  initiator.update({
                    'latestMessage':
                        message.message!.isNotEmpty ? message.message : 'photo',
                    'sentAt': Timestamp.now(),
                    'sentBy': uid,
                  }),
                  initiator.collection('messages').doc().set({
                    'message':
                        message.message!.isNotEmpty ? message.message : 'photo',
                    'sender': uid,
                    'to': toUserId,
                    'media': url,
                    'mediaType': message.mediaType,
                    'isRead': false,
                    'sentAt': Timestamp.now()
                  })
                }
              else
                {
                  receiver.get().then((value) => {
                        if (value.exists)
                          {
                            receiver.update({
                              'latestMessage': message.message!.isNotEmpty
                                  ? message.message
                                  : 'photo',
                              'sentAt': Timestamp.now(),
                              'sentBy': uid,
                            }),
                            receiver.collection('messages').doc().set({
                              'message': message.message!.isNotEmpty
                                  ? message.message
                                  : 'photo',
                              'sender': uid,
                              'to': toUserId,
                              'media': url,
                              'mediaType': message.mediaType,
                              'isRead': false,
                              'sentAt': Timestamp.now()
                            })
                          }
                        else
                          {
                            initiator.set({
                              'initiator': uid,
                              'receiver': toUserId,
                              'startedAt': Timestamp.now(),
                              'latestMessage': message.message!.isNotEmpty
                                  ? message.message
                                  : '',
                              'sentAt': Timestamp.now(),
                              'sentBy': uid,
                            }),
                            initiator.collection('messages').doc().set({
                              'message': message.message ?? '',
                              'sender': uid,
                              'to': toUserId,
                              'media': url,
                              'mediaType': message.mediaType,
                              'isRead': false,
                              'sentAt': Timestamp.now()
                            }),
                          }
                      })
                }
            });
      });
    } else {
      final initiator = FirebaseFirestore.instance
          .collection('chats')
          .doc(uid + '_' + toUserId);
      final receiver = FirebaseFirestore.instance
          .collection('chats')
          .doc(toUserId + '_' + uid);

      initiator.get().then((value) => {
            if (value.exists)
              {
                initiator.update({
                  'latestMessage': message.message ?? 'photo',
                  'sentAt': Timestamp.now(),
                  'sentBy': uid,
                }),
                initiator.collection('messages').doc().set({
                  'message': message.message ?? '',
                  'sender': uid,
                  'to': toUserId,
                  'media': url,
                  'mediaType': message.mediaType,
                  'isRead': false,
                  'sentAt': Timestamp.now()
                })
              }
            else
              {
                receiver.get().then((value) => {
                      if (value.exists)
                        {
                          receiver.update({
                            'latestMessage': message.message ?? 'photo',
                            'sentAt': Timestamp.now(),
                            'sentBy': uid,
                          }),
                          receiver.collection('messages').doc().set({
                            'message': message.message ?? '',
                            'sender': uid,
                            'to': toUserId,
                            'media': url,
                            'mediaType': message.mediaType,
                            'isRead': false,
                            'sentAt': Timestamp.now()
                          })
                        }
                      else
                        {
                          initiator.set({
                            'initiator': uid,
                            'receiver': toUserId,
                            'startedAt': Timestamp.now(),
                            'latestMessage': message.message ?? '',
                            'sentAt': Timestamp.now(),
                            'sentBy': uid,
                          }),
                          initiator.collection('messages').doc().set({
                            'message': message.message ?? '',
                            'sender': uid,
                            'media': url,
                            'to': toUserId,
                            'mediaType': message.mediaType,
                            'isRead': false,
                            'sentAt': Timestamp.now()
                          }),
                        }
                    })
              }
          });
    }
  }

  //////////////////////////////////////////////////////
  ///
  ///
  Future<List<ChatTileModel>> getChats(String uid) async {
    List<ChatTileModel> users = [];

    final initiatorChats = await FirebaseFirestore.instance
        .collection('chats')
        .where('initiator', isEqualTo: uid)
        .get();
    final receiverChats = await FirebaseFirestore.instance
        .collection('chats')
        .where('receiver', isEqualTo: uid)
        .get();

    await Future.forEach(initiatorChats.docs,
        (QueryDocumentSnapshot element) async {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(element['receiver'])
          .get()
          .then((value) => {
                // print(value['username']),
                if (value.exists)
                  {
                    users.add(
                      ChatTileModel(
                          chatRoomId: element.id,
                          latestMessageSenderId: element['sentBy'],
                          user: UserModel(
                              name: value['name'],
                              profile: value['profile'],
                              userId: value['userId'],
                              phone: value['phone'],
                              email: value['email'],
                              isLandlord: value['isLandlord'],
                              isAdmin: value['isAdmin']),
                          latestMessage: element['latestMessage'],
                          time: element['sentAt']),
                    ),
                  }
              });
    });

    await Future.forEach(receiverChats.docs,
        (QueryDocumentSnapshot element) async {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(element['initiator'])
          .get()
          .then((value) => {
                if (value.exists)
                  {
                    if (users.where((e) => e.chatRoomId == element.id).isEmpty)
                      users.add(
                        ChatTileModel(
                            chatRoomId: element.id,
                            latestMessageSenderId: element['sentBy'],
                            user: UserModel(
                                name: value['name'],
                                profile: value['profile'],
                                userId: value['userId'],
                                phone: value['phone'],
                                email: value['email'],
                                isLandlord: value['isLandlord'],
                                isAdmin: value['isAdmin']),
                            latestMessage: element['latestMessage'],
                            time: element['sentAt']),
                      ),
                  }
              });
    });
    users.sort((a, b) => b.time!.compareTo(a.time!));

    notifyListeners();
    return _contactedUsers = users;
  }

  Future<List<ChatTileModel>> searchUser(String searchTerm) async {
    List<UserModel> users = [];

    final results = await FirebaseFirestore.instance.collection('users').get();
    results.docs
        .where((element) =>
            element['name'].toLowerCase().contains(searchTerm.toLowerCase()) ||
            element['phone'].toLowerCase().contains(searchTerm.toLowerCase()) ||
            element['name'].toLowerCase().contains(searchTerm.toLowerCase()))
        .forEach((e) {
      users.add(
        UserModel(
            name: e['name'],
            profile: e['profile'],
            userId: e['userId'],
            phone: e['phone'],
            email: e['email'],
            isLandlord: e['isLandlord'],
            isAdmin: e['isAdmin']),
      );
    });
    print(users.length);

    notifyListeners();
    _contactedUsers =
        users.map((e) => ChatTileModel(user: e, chatRoomId: '')).toList();

    return users.map((e) => ChatTileModel(user: e, chatRoomId: '')).toList();
  }
}
