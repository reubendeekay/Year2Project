import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:rent_space/helpers/constants.dart';
import 'package:rent_space/helpers/review_widget.dart';
import 'package:rent_space/models/chat_provider.dart';

import 'package:rent_space/models/space_model.dart';
import 'package:rent_space/models/user_model.dart';
import 'package:rent_space/screens/chat/chat_room.dart';
import 'package:rent_space/screens/details/space_location.dart';
import 'package:rent_space/screens/details/owner_tile.dart';
import 'package:rent_space/screens/details/space_reviews.dart';
import 'package:rent_space/screens/payment/payment_screen.dart';
import 'package:rent_space/widgets/about.dart';
import 'package:rent_space/widgets/content_intro.dart';
import 'package:rent_space/widgets/details_app_bar.dart';
import 'package:rent_space/widgets/house_info.dart';

class Details extends StatelessWidget {
  final SpaceModel space;
  const Details({
    Key? key,
    required this.space,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          ListView(
            shrinkWrap: true,
            children: [
              DetailsAppBar(space: space),
              const SizedBox(height: 20),
              ContentIntro(space: space),
              const SizedBox(height: 20),
              const HouseInfo(),
              const SizedBox(height: 5),
              OwnerTile(
                userId: space.ownerId,
              ),
              const SizedBox(height: 5),
              About(
                space: space,
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Text('Reviews',
                    style: Theme.of(context).textTheme.headline1!.copyWith(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        )),
              ),
              const SizedBox(height: 5),
              SpaceReviews(spaceId: space.id!),
              const SizedBox(height: 5),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 10),
                height: 65,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: OutlineButton(
                    onPressed: () {
                      showDialog(
                          barrierDismissible: false,
                          context: context,
                          builder: (context) => SimpleDialog(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5)),
                                  children: [
                                    UserReview(
                                      space.id!,
                                    )
                                  ]));
                    },
                    color: kPrimaryColor,
                    child: const Text('Add Review'),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              SpaceLocation(
                imageUrl: space.images!.first,
                location:
                    LatLng(space.location!.latitude, space.location!.longitude),
              ),
              const SizedBox(height: 80),
            ],
          ),
          Positioned(
            bottom: 15,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Get.off(() => PaymentScreen(
                              space: space,
                            ));
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        primary: Theme.of(context).primaryColor,
                      ),
                      child: Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        child: const Text(
                          'Book Now',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  InkWell(
                    onTap: () async {
                      final users =
                          Provider.of<ChatProvider>(context, listen: false)
                              .contactedUsers;
                      List<String> room = users.map<String>((e) {
                        return e.chatRoomId!.contains(
                                FirebaseAuth.instance.currentUser!.uid +
                                    '_' +
                                    space.ownerId!)
                            ? FirebaseAuth.instance.currentUser!.uid +
                                '_' +
                                space.ownerId!
                            : space.ownerId! +
                                '_' +
                                FirebaseAuth.instance.currentUser!.uid;
                      }).toList();
                      await FirebaseFirestore.instance
                          .collection('users')
                          .doc(space.ownerId!)
                          .get()
                          .then((value) {
                        Navigator.of(context)
                            .pushNamed(ChatRoom.routeName, arguments: {
                          'user': UserModel.fromJson(value),
                          'chatRoomId': room.isEmpty
                              ? FirebaseAuth.instance.currentUser!.uid +
                                  '_' +
                                  space.ownerId!
                              : room.first,
                        });
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: kPrimaryColor),
                      child: const Icon(CupertinoIcons.text_bubble,
                          color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
