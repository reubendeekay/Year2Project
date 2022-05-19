import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

import 'package:provider/provider.dart';
import 'package:rent_space/helpers/constants.dart';
import 'package:rent_space/helpers/loading_effect.dart';
import 'package:rent_space/providers/auth_provider.dart';
import 'package:rent_space/models/chat_provider.dart';
import 'package:rent_space/screens/chat/chat_screen_search.dart';
import 'package:rent_space/screens/chat/widgets/chat_tile.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({Key? key}) : super(key: key);
  static const routeName = '/chat';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.5,
        title: const Text(
          'Chat',
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          IconButton(
            icon: const Icon(CupertinoIcons.search),
            onPressed: () {
              Get.to(() => const ChatScreenSearch());
            },
          ),
        ],
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: const ChatScreenWidget(),
    );
  }
}

class ChatScreenWidget extends StatelessWidget {
  static const routeName = '/chat-screen-widget';

  const ChatScreenWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    return FutureBuilder<List<ChatTileModel>>(
        future: Provider.of<ChatProvider>(context, listen: false).getChats(uid),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return LoadingEffect.getSearchLoadingScreen(context);
          }

          final contacts = snapshot.data!;
          return ListView(
            padding: const EdgeInsets.all(0),
            shrinkWrap: true,
            children: [
              ...List.generate(
                  contacts.length,
                  (index) => ChatTile(
                        roomId: contacts[index].chatRoomId!,
                        chatModel: contacts[index],
                      )),
              if (contacts.isEmpty)
                Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 25),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'You have no unread messages',
                        style: TextStyle(
                            fontSize: 18,
                            color: kPrimaryColor,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        'When you contact a landlord, you will be able to see their messages here.',
                        style: TextStyle(color: Colors.grey[400]),
                      ),
                    ],
                  ),
                )
            ],
          );
        });
  }
}
