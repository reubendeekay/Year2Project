import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:provider/provider.dart';
import 'package:rent_space/models/user_model.dart';
import 'package:rent_space/providers/auth_provider.dart';
import 'package:rent_space/screens/landlord/landlord_profile.dart';

class OwnerTile extends StatelessWidget {
  const OwnerTile({Key? key, this.userId}) : super(key: key);
  final String? userId;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<UserModel>(
        future: Provider.of<AuthProvider>(context, listen: false)
            .getOwnerDetails(userId!),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container();
          }

          final user = snapshot.data!;
          return Container(
            margin: const EdgeInsets.all(15),
            color: Colors.white,
            child: ListTile(
              leading: CircleAvatar(
                backgroundImage: NetworkImage(user.profile!),
              ),
              onTap: () {
                Get.to(() => LandlordProfile(user: user));
              },
              title: Text(user.name!),
              subtitle: Text(user.email!),
              trailing: IconButton(
                icon: const Icon(
                  Icons.arrow_forward_ios,
                  size: 18,
                ),
                onPressed: () {},
              ),
            ),
          );
        });
  }
}
