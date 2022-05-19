import 'package:flutter/foundation.dart';
import 'package:rent_space/models/user_model.dart';
import 'package:rent_space/providers/auth_provider.dart';

class AdminProvider with ChangeNotifier {
  Future<List<UserModel>> getAllUsers() async {
    final results = await usersRef.get();
    notifyListeners();
    return results.docs.map((doc) => UserModel.fromJson(doc.data())).toList();
  }

  Future<List<UserModel>> getAllLandlords() async {
    final results = await usersRef.where('isLandlord', isEqualTo: true).get();
    notifyListeners();
    return results.docs.map((doc) => UserModel.fromJson(doc.data())).toList();
  }

  Future<void> deleteUser(String uid) async {
    await usersRef.doc(uid).delete();
    notifyListeners();
  }

  Future<void> makeAdmin(String uid, bool isAdmin) async {
    await usersRef.doc(uid).update({'isAdmin': !isAdmin});
    notifyListeners();
  }

  Future<void> makeLandlord(String uid, bool isLandlord) async {
    await usersRef.doc(uid).update({'isLandlord': !isLandlord});
    notifyListeners();
  }
}
