import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';

import 'package:provider/provider.dart';
import 'package:rent_space/helpers/constants.dart';
import 'package:rent_space/helpers/my_loader.dart';
import 'package:rent_space/models/review_model.dart';
import 'package:rent_space/providers/auth_provider.dart';
import 'package:rent_space/providers/post_provider.dart';

class UserReview extends StatefulWidget {
  final String spaceId;
  const UserReview(this.spaceId, {Key? key}) : super(key: key);
  @override
  _UserReviewState createState() => _UserReviewState();
}

class _UserReviewState extends State<UserReview> {
  late double _rating;
  final reviewController = TextEditingController();
  String feel = '0';
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final user = Provider.of<AuthProvider>(context, listen: false).user;

    return SizedBox(
      width: size.width,
      child: Stack(
        children: [
          Positioned(
            top: 5,
            right: 15,
            child: InkWell(
                onTap: () async {
                  Navigator.of(context).pop();
                },
                child: Row(
                  children: const [
                    Text(
                      'Cancel',
                      style: TextStyle(fontSize: 12),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Icon(Icons.cancel, size: 16),
                  ],
                )),
          ),
          Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  const Text(
                    'Leave a Rating',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),

                  SizedBox(
                    height: 100,
                    child: Transform.scale(
                      scale: 2,
                      child: FlareActor(
                        'assets/feelings.flr',
                        fit: BoxFit.contain,

                        //alignment: Alignment.Center,
                        animation: feel,
                      ),
                    ),
                  ),
                  RatingBar(
                      onRatingUpdate: (rating) {
                        setState(() {
                          _rating = rating;
                          if (rating.floor() == 5) {
                            feel = '100';
                          } else if (rating.floor() == 4) {
                            feel = '75';
                          } else if (rating.floor() == 3) {
                            feel = '50';
                          } else if (rating.floor() == 2) {
                            feel = '25';
                          } else if (rating.floor() == 1) {
                            feel = '10';
                          } else {
                            feel = '0';
                          }
                        });
                      },
                      itemSize: 30,
                      ratingWidget: RatingWidget(
                        full: const Icon(
                          Icons.star,
                          color: Colors.amber,
                        ),
                        half: const Icon(
                          Icons.star_half,
                          color: Colors.amber,
                        ),
                        empty: const Icon(
                          Icons.star_border,
                          color: Colors.amber,
                        ),
                      )), // MySlid(),

                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: TextField(
                        maxLines: null,
                        controller: reviewController,
                        decoration: InputDecoration(
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 15),
                          labelText: 'Write a review',
                          border: InputBorder.none,
                          fillColor: Colors.grey[400],
                          filled: true,
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                              borderSide: const BorderSide(
                                color: Colors.grey,
                                width: 1,
                              )),
                        )),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  RaisedButton(
                    color: kPrimaryColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5)),
                    onPressed: () async {
                      setState(() {
                        isLoading = true;
                      });

                      final review = ReviewModel(
                        rating: _rating,
                        review: reviewController.text,
                        createdAt: Timestamp.now(),
                        fullName: user!.name!,
                        id: usersRef.doc().id,
                        userId: user.userId!,
                        imageUrl: user.profile,
                        spaceId: widget.spaceId,
                      );
                      await Provider.of<PostProvider>(context, listen: false)
                          .sendRating(review);

                      Navigator.of(context).pop();
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 13),
                      child: isLoading
                          ? const MyLoader()
                          : const Text(
                              'Submit',
                              style: TextStyle(color: Colors.white),
                            ),
                    ),
                  )
                ],
              )),
        ],
      ),
    );
  }

  Widget buildReview() {
    return Container(
      child: RatingBar(
        ratingWidget: RatingWidget(
          full: const Icon(
            Icons.star,
            color: Colors.amber,
          ),
          half: const Icon(
            Icons.star_half,
            color: Colors.amber,
          ),
          empty: const Icon(
            Icons.star_border,
            color: Colors.amber,
          ),
        ),
        onRatingUpdate: (rating) => setState(() => _rating = rating),
        allowHalfRating: true,
        itemSize: 25,
      ),
    );
  }
}
