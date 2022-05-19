import 'package:flutter/foundation.dart';
import 'package:rent_space/models/space_model.dart';
import 'package:rent_space/models/user_model.dart';
import 'package:rent_space/providers/post_provider.dart';

class TenancyProvider with ChangeNotifier {
  Future<List<SpaceModel>> getUserTenancy(UserModel user) async {
    List<SpaceModel> spaces = [];
    for (var element in user.rentedPlaces!) {
      final spaceResult = await spaceRef.doc(element).get();
      final space = SpaceModel.fromJson(spaceResult);
      spaces.add(space);
    }
    return spaces;
  }
}
