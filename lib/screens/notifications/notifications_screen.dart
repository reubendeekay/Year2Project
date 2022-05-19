import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rent_space/helpers/loading_effect.dart';
import 'package:rent_space/models/notification_model.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Your Notifications',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        elevation: 0,
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('userData')
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .collection('notifications')
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return LoadingEffect.getSearchLoadingScreen(context);
            }

            List<DocumentSnapshot> docs = snapshot.data!.docs;
            return ListView(
              children: List.generate(
                  docs.length,
                  (index) => NotificationsTile(
                        not: NotificationModel.fromJson(docs[index]),
                      )),
            );
          }),
    );
  }
}

class NotificationsTile extends StatelessWidget {
  const NotificationsTile({Key? key, required this.not}) : super(key: key);
  final NotificationModel not;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.grey,
        backgroundImage: NetworkImage(not.imageUrl!),
      ),
      title: Text(not.title!),
      subtitle: Text(not.message!),
      trailing: const Icon(
        Icons.arrow_forward_ios,
        size: 16,
      ),
    );
  }
}
