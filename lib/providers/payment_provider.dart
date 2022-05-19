import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:rent_space/models/invoice_models.dart';
import 'package:rent_space/models/notification_model.dart';
import 'package:rent_space/models/space_model.dart';
import 'package:rent_space/models/user_model.dart';
import 'package:rent_space/providers/auth_provider.dart';
import 'package:rent_space/providers/post_provider.dart';
import 'package:rent_space/providers/tenant_model.dart';

class PaymentProvider with ChangeNotifier {
  //RENT SPACE
  Future<void> rentSpace(String user, SpaceModel space) async {
    await usersRef.doc(user).update({
      'rentedPlaces': FieldValue.arrayUnion([space.id])
    });
    final uid = FirebaseAuth.instance.currentUser!.uid;

    await FirebaseFirestore.instance
        .collection('landlords')
        .doc(space.ownerId!)
        .collection('tenants')
        .add({
      'user': user,
      'space': space.id,
      'joinedAt': Timestamp.now(),
    });

    await usersRef
        .doc(space.ownerId!)
        .update({'balance': FieldValue.increment(space.price!)});

    final not = NotificationModel(
      title: 'Rented ${space.spaceName!}',
      message: 'You have successfully rented a ${space.spaceName!}',
      imageUrl: space.images!.first,
      createdAt: Timestamp.now(),
    );
    await FirebaseFirestore.instance
        .collection('userData')
        .doc(uid)
        .collection('notifications')
        .add(not.toJson());

    await FirebaseFirestore.instance.collection('transactions').add({
      'user': user,
      ...space.toJson(),
    });
    notifyListeners();
  }

  Future<void> checkOut(String user, SpaceModel space) async {
    await usersRef.doc(user).update({
      'rentedPlaces': FieldValue.arrayRemove([space.id])
    });
    final uid = FirebaseAuth.instance.currentUser!.uid;

    await FirebaseFirestore.instance
        .collection('landlords')
        .doc(space.ownerId!)
        .collection('tenants')
        .where('user', isEqualTo: user)
        .get()
        .then((value) {
      for (var doc in value.docs) {
        doc.reference.delete();
      }
    });

    final not = NotificationModel(
      title: 'Checked out ${space.spaceName!}',
      message: 'You have successfully checked out of ${space.spaceName!}',
      imageUrl: space.images!.first,
      createdAt: Timestamp.now(),
    );
    await FirebaseFirestore.instance
        .collection('userData')
        .doc(uid)
        .collection('notifications')
        .add(not.toJson());

    notifyListeners();
  }

  Future<List<TenantModel>> fetchTenants() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final results = await FirebaseFirestore.instance
        .collection('landlords')
        .doc(uid)
        .collection('tenants')
        .get();

    List<TenantModel> tenants = [];

    for (var element in results.docs) {
      final user = await usersRef.doc(element['user']).get().then((value) {
        return UserModel.fromJson(value);
      });

      final space = await spaceRef.doc(element['space']).get().then((value) {
        return SpaceModel.fromJson(value);
      });

      if (tenants
          .where((element) => element.user!.userId == user.userId)
          .isEmpty) {
        tenants.add(TenantModel(user: user, space: space));
      }
    }

    notifyListeners();
    return tenants;
  }

//PAY RENT

  Future<void> payRent(String owner, double amount) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(owner)
        .update({'balance': FieldValue.increment(amount)});
    notifyListeners();
  }

  Future<Invoice> getTransactions() async {
    final results =
        await FirebaseFirestore.instance.collection('transactions').get();
    final uid = FirebaseAuth.instance.currentUser!.uid;

    final spaces = results.docs.map((e) => SpaceModel.fromJson(e)).toList();

    return Invoice(
        info: InvoiceInfo(
            date: DateTime.now(),
            description: 'All Transactions',
            dueDate: DateTime.now(),
            number: '541'),
        supplier:
            Supplier(name: uid, address: 'Chiromo, Nairobi', paymentInfo: uid),
        customer: Customer(name: uid),
        items: spaces
            .map((e) => InvoiceItem(
                description: e.spaceName!,
                quantity: 1,
                unitPrice: e.price!,
                date: DateTime.now(),
                name: e.address!))
            .toList());
  }
}
