import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:rent_space/models/review_model.dart';
import 'package:rent_space/models/space_model.dart';
import 'package:rent_space/models/user_model.dart';
import 'package:rent_space/providers/auth_provider.dart';

final spaceRef = FirebaseFirestore.instance.collection('spaces');

class PostProvider with ChangeNotifier {
  List<SpaceModel> _spaces = [];

  List<SpaceModel> get spaces {
    return [..._spaces];
  }

////ADDING NEW SPACE
  Future<void> addSpace(SpaceModel space) async {
    final id = spaceRef.doc().id;
    List<String> urls = [];

    if (space.imageFiles != null) {
      for (int i = 0; i < space.imageFiles!.length; i++) {
        final upload = await FirebaseStorage.instance
            .ref('spaces/$id/$i')
            .putFile(space.imageFiles![i]);

        urls.add(await upload.ref.getDownloadURL());
      }
    }

    space.id = id;
    space.images = urls;

    await spaceRef.doc(id).set(space.toJson());
    await getSpaces();

    notifyListeners();
  }

  ////EDITING A SPACE
  Future<void> editSpace(SpaceModel space) async {
    final id = space.id;
    List<String> urls = [];

    if (space.imageFiles != null) {
      for (int i = 0; i < space.imageFiles!.length; i++) {
        final upload = await FirebaseStorage.instance
            .ref('spaces/$id/$i')
            .putFile(space.imageFiles![i]);

        urls.add(await upload.ref.getDownloadURL());
      }
    }

    space.id = id;
    if (urls.isNotEmpty) {
      space.images = urls;
    }

    await spaceRef.doc(id).update(space.toJson());
    await getSpaces();

    notifyListeners();
  }

////FETCHING ALL SPACES

  Future<List<SpaceModel>> getSpaces() async {
    final results = await spaceRef.get();

    final mySpaces = results.docs.map((e) => SpaceModel.fromJson(e)).toList();

    notifyListeners();
    return _spaces = mySpaces;
  }

  //FETCHING LANDLOARD SPACES
  Future<List<SpaceModel>> fetchLandlordSpaces(String uid) async {
    final results = await spaceRef.where('ownerId', isEqualTo: uid).get();

    final mySpaces = results.docs.map((e) => SpaceModel.fromJson(e)).toList();

    notifyListeners();
    return mySpaces;
  }

//FETCHING LANDLORD DETAILS
  Future<UserModel> fetchLandLordDetails(String id) async {
    return usersRef.doc(id).get().then((value) {
      return UserModel.fromJson(value);
    });
  }

  ////SEARCHING SPACES

  Future<List<SpaceModel>> searchSpaces(String term) async {
    final results = await spaceRef.get();

    final searcResult = results.docs
        .where((element) =>
            element['spaceName'].toLowerCase().contains(term.toLowerCase()) ||
            element['address'].toLowerCase().contains(term.toLowerCase()) ||
            element['category'].toLowerCase().contains(term.toLowerCase()) ||
            element['address'].toLowerCase().contains(term.toLowerCase()))
        .toList();

    return searcResult.map((e) => SpaceModel.fromJson(e)).toList();
  }

  Future<void> sendRating(ReviewModel review) async {
    await FirebaseFirestore.instance
        .collection('spaces/${review.spaceId!}/reviews')
        .doc()
        .set(review.toJson());

    notifyListeners();
  }

  Future<void> deleteSpace(String id) async {
    await spaceRef.doc(id).delete();
    notifyListeners();
  }
}
