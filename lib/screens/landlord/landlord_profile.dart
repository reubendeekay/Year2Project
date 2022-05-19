import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rent_space/helpers/constants.dart';
import 'package:rent_space/helpers/loading_effect.dart';
import 'package:rent_space/models/chat_provider.dart';
import 'package:rent_space/models/space_model.dart';
import 'package:rent_space/models/user_model.dart';
import 'package:rent_space/providers/post_provider.dart';
import 'package:rent_space/screens/chat/chat_room.dart';
import 'package:rent_space/screens/profile/user_profile.dart';
import 'package:rent_space/widgets/recommended_house.dart';

class LandlordProfile extends StatelessWidget {
  const LandlordProfile({Key? key, required this.user}) : super(key: key);
  final UserModel user;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<SpaceModel>>(
          future: Provider.of<PostProvider>(context, listen: false)
              .fetchLandlordSpaces(user.userId!),
          builder: ((context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return LoadingEffect.getSearchLoadingScreen(context);
            }

            return SafeArea(
              child: Stack(
                children: [
                  ListView(
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.3,
                        child: Image.network(
                          user.profile!,
                          fit: BoxFit.cover,
                        ),
                      ),
                      UserProfileDetails(user: user),
                      const SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Text('More Spaces by ${user.name}',
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold)),
                      ),
                      FutureBuilder<List<SpaceModel>>(
                          future:
                              Provider.of<PostProvider>(context, listen: false)
                                  .fetchLandlordSpaces(user.userId!),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return LoadingEffect.getSearchLoadingScreen(
                                  context);
                            }

                            return RecommendedHouse(spaces: snapshot.data!);
                          })
                    ],
                  ),
                  Positioned(
                    bottom: 10,
                    right: 20,
                    left: 20,
                    child: SizedBox(
                      height: 48,
                      child: RaisedButton(
                        onPressed: () async {
                          final users =
                              Provider.of<ChatProvider>(context, listen: false)
                                  .contactedUsers;
                          List<String> room = users.map<String>((e) {
                            return e.chatRoomId!.contains(
                                    FirebaseAuth.instance.currentUser!.uid +
                                        '_' +
                                        user.userId!)
                                ? FirebaseAuth.instance.currentUser!.uid +
                                    '_' +
                                    user.userId!
                                : user.userId! +
                                    '_' +
                                    FirebaseAuth.instance.currentUser!.uid;
                          }).toList();
                          await FirebaseFirestore.instance
                              .collection('users')
                              .doc(user.userId!)
                              .get()
                              .then((value) {
                            Navigator.of(context)
                                .pushNamed(ChatRoom.routeName, arguments: {
                              'user': UserModel.fromJson(value),
                              'chatRoomId': room.isEmpty
                                  ? FirebaseAuth.instance.currentUser!.uid +
                                      '_' +
                                      user.userId!
                                  : room.first,
                            });
                          });
                        },
                        color: kPrimaryColor,
                        child: const Text(
                          'Talk to Landlord',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            );
          })),
    );
  }
}
