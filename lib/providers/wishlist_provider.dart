import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:rent_space/models/space_model.dart';
import 'package:rent_space/models/user_model.dart';
import 'package:rent_space/providers/auth_provider.dart';
import 'package:rent_space/providers/post_provider.dart';

class WishlistProvider with ChangeNotifier {
  Future<void> addToWishlist(String id, bool exists) async {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    await usersRef.doc(uid).update({
      'wishlist':
          exists ? FieldValue.arrayRemove([id]) : FieldValue.arrayUnion([id])
    });

    notifyListeners();
  }

  Future<List<SpaceModel>> fetchWishlist() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    final userResult = await usersRef.doc(uid).get();
    final userData = UserModel.fromJson(userResult);

    List<SpaceModel> spaces = [];

    for (String element in userData.wishlist!) {
      final spaceResult = await spaceRef.doc(element).get();

      spaces.add(SpaceModel.fromJson(spaceResult));
    }

    notifyListeners();
    return spaces;
  }
}
