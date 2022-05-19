import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:rent_space/helpers/constants.dart';
import 'package:rent_space/providers/auth_provider.dart';
import 'package:rent_space/models/chat_provider.dart';
import 'package:rent_space/models/user_model.dart';
import 'package:rent_space/screens/chat/chat_room.dart';

class ChatTile extends StatelessWidget {
  final String roomId;
  final ChatTileModel? chatModel;
  ChatTile({Key? key, required this.roomId, this.chatModel}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final uid = Provider.of<AuthProvider>(context).user!.userId;

    return GestureDetector(
      onTap: () async {
        // });
        final users =
            Provider.of<ChatProvider>(context, listen: false).contactedUsers;
        List<String> room = users.map<String>((e) {
          return e.chatRoomId!.contains(uid! + '_' + chatModel!.user!.userId!)
              ? uid + '_' + chatModel!.user!.userId!
              : chatModel!.user!.userId! + '_' + uid;
        }).toList();
        await FirebaseFirestore.instance
            .collection('users')
            .doc(chatModel!.user!.userId!)
            .get()
            .then((value) {
          Navigator.of(context).pushNamed(ChatRoom.routeName, arguments: {
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
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
        child: Column(
          children: [
            Row(children: [
              CircleAvatar(
                radius: 26,
                backgroundImage:
                    CachedNetworkImageProvider(chatModel!.user!.profile!),
              ),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          chatModel!.user!.name!,
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        if (chatModel!.user!.isAdmin!)
                          const Icon(
                            Icons.verified,
                            color: kPrimaryColor,
                            size: 16,
                          ),
                        const Spacer(),
                        // Text(
                        //   DateFormat('HH:mm').format(chatModel!.time!.toDate()),
                        //   style:
                        //       const TextStyle(fontSize: 13, color: Colors.grey),
                        // )
                      ],
                    ),
                    Text(
                      '${chatModel!.latestMessageSenderId == uid ? 'You: ' : ''}${chatModel!.latestMessage}',
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ],
                ),
              )
            ]),
            const SizedBox(
              height: 8,
            ),
            const Divider(
              height: 1,
            )
          ],
        ),
      ),
    );
  }
}
