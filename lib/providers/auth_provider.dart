// ignore_for_file: recursive_getters, unused_field

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:rent_space/models/user_model.dart';

final usersRef = FirebaseFirestore.instance.collection('users');

class AuthProvider with ChangeNotifier {
  UserModel? _user;
  UserModel? get user => _user;

  Future<void> logIn(String email, String password) async {
    await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);

    await getCurrentUser();

    notifyListeners();
  }

  Future<void> signUp(UserModel userModel) async {
    final result = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: userModel.email!.trim(), password: userModel.password!.trim());
    userModel.userId = result.user!.uid;
    final id = result.user!.uid;

    await usersRef.doc(id).set(userModel.toJson());

    getCurrentUser();
  }

  Future<UserModel> getCurrentUser() async {
    final value = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    _user = UserModel.fromJson(value);

    notifyListeners();
    return _user!;
  }

  Future<UserModel> getOwnerDetails(String uid) async {
    final value =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();

    notifyListeners();
    return UserModel.fromJson(value);
  }

  Future<void> updateProfile(UserModel user) async {
    await usersRef.doc(user.userId).update(user.toJson());
    notifyListeners();
  }
}
