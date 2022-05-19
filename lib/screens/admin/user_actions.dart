import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';

import 'package:provider/provider.dart';
import 'package:rent_space/models/chat_provider.dart';
import 'package:rent_space/models/user_model.dart';
import 'package:rent_space/providers/admin_provider.dart';
import 'package:rent_space/screens/chat/chat_room.dart';

void actionSheet(BuildContext context, UserModel user) {
  final uid = FirebaseAuth.instance.currentUser!.uid;
  showModalBottomSheet(
      context: context,
      builder: (BuildContext buildContext) {
        return Container(
          decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16), topRight: Radius.circular(16))),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                    margin: const EdgeInsets.fromLTRB(12, 0, 0, 8),
                    child: const Text("ACTIONS",
                        style: TextStyle(
                            letterSpacing: 0.3, fontWeight: FontWeight.bold))),
                ListTile(
                    dense: true,
                    leading: const Icon(
                      CupertinoIcons.text_bubble,
                      size: 20,
                    ),
                    title: const Text(
                      "Chat",
                      style: (TextStyle(
                          letterSpacing: 0.3, fontWeight: FontWeight.w500)),
                    ),
                    onTap: () async {
                      final users =
                          Provider.of<ChatProvider>(context, listen: false)
                              .contactedUsers;
                      List<String> room = users.map<String>((e) {
                        return e.chatRoomId!.contains(uid + '_' + user.userId!)
                            ? uid + '_' + user.userId!
                            : user.userId! + '_' + uid;
                      }).toList();
                      await FirebaseFirestore.instance
                          .collection('users')
                          .doc(user.userId!)
                          .get()
                          .then((value) {
                        Navigator.of(context)
                            .pushNamed(ChatRoom.routeName, arguments: {
                          'user': UserModel(
                              name: value['name'],
                              profile: value['profile'],
                              userId: value['userId'],
                              phone: value['phone'],
                              email: value['email'],
                              isLandlord: value['isLandlord'],
                              isAdmin: value['isAdmin']),
                          'chatRoomId': room.first,
                        });
                      });
                    }),
                ListTile(
                  dense: true,
                  leading: const Icon(
                    Icons.call,
                    size: 20,
                  ),
                  onTap: () async {
                    Navigator.of(context).pop();

                    await FlutterPhoneDirectCaller.callNumber(user.phone!);
                  },
                  title: const Text(
                    "Call",
                    style: (TextStyle(
                        letterSpacing: 0.3, fontWeight: FontWeight.w500)),
                  ),
                ),
                ListTile(
                  dense: true,
                  leading: const Icon(
                    Icons.close,
                    size: 20,
                  ),
                  onTap: () async {
                    Navigator.of(context).pop();
                    await Provider.of<AdminProvider>(context, listen: false)
                        .deleteUser(uid);
                  },
                  title: const Text(
                    "Delete User",
                    style: (TextStyle(
                        letterSpacing: 0.3, fontWeight: FontWeight.w500)),
                  ),
                ),
                const Divider(
                  color: Colors.grey,
                ),
                ListTile(
                  dense: true,
                  leading: const Icon(
                    Icons.cloud_upload_outlined,
                    size: 20,
                  ),
                  onTap: () async {
                    Navigator.of(context).pop();
                    await Provider.of<AdminProvider>(context, listen: false)
                        .makeAdmin(uid, user.isAdmin!);
                  },
                  title: Text(
                    user.isAdmin! ? 'Revoke Admin' : "Make Admin",
                    style: (const TextStyle(
                        letterSpacing: 0.3, fontWeight: FontWeight.w500)),
                  ),
                ),
                ListTile(
                  dense: true,
                  leading: const Icon(
                    Icons.credit_card_outlined,
                    size: 20,
                  ),
                  onTap: () async {
                    Navigator.of(context).pop();
                    await Provider.of<AdminProvider>(context, listen: false)
                        .makeAdmin(uid, user.isLandlord!);
                  },
                  title: Text(
                    user.isLandlord! ? 'Remove Landlord' : "Make Landlord",
                    style: (const TextStyle(
                        letterSpacing: 0.3, fontWeight: FontWeight.w500)),
                  ),
                ),
                ListTile(
                  dense: true,
                  leading: const Icon(
                    Icons.report_outlined,
                    size: 20,
                  ),
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  title: const Text(
                    "Block User",
                    style: (TextStyle(
                        letterSpacing: 0.3, fontWeight: FontWeight.w500)),
                  ),
                ),
              ],
            ),
          ),
        );
      });
}
