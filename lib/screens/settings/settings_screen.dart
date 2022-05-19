import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:provider/provider.dart';
import 'package:rent_space/helpers/constants.dart';
import 'package:rent_space/helpers/loading_effect.dart';
import 'package:rent_space/models/user_model.dart';
import 'package:rent_space/providers/auth_provider.dart';
import 'package:rent_space/screens/admin/admin.dart';
import 'package:rent_space/screens/auth/change_password.dart';
import 'package:rent_space/screens/auth/login_page.dart';
import 'package:rent_space/screens/landlord/landlord_dashboard.dart';
import 'package:rent_space/screens/notifications/notifications_screen.dart';
import 'package:rent_space/screens/profile/edit_profile.dart';
import 'package:rent_space/screens/profile/user_profile.dart';
import 'package:rent_space/screens/settings/request_landlord.dart';
import 'package:rent_space/screens/settings/wishlist_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        centerTitle: true,
      ),
      body: FutureBuilder<UserModel>(
          future: Provider.of<AuthProvider>(context, listen: false)
              .getCurrentUser(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return LoadingEffect.getSearchLoadingScreen(context);
            }
            return ListView(
              children: [
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: () {
                    Get.to(() => const UserProfileScreen());
                  },
                  child: Column(
                    children: [
                      Center(
                        child: CircleAvatar(
                            radius: 50,
                            backgroundImage:
                                NetworkImage(snapshot.data!.profile!)),
                      ),
                      const SizedBox(height: 10),
                      Center(
                          child: Text(snapshot.data!.name!,
                              style: const TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold))),
                      const SizedBox(height: 5),
                      const Center(
                        child: Text(
                          'Joined since 2 days ago',
                          style: TextStyle(fontSize: 12, color: kPrimaryColor),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
                buildListTile('Edit Profile', Icons.person_outline, () {
                  Get.to(() => EditProfileScreen());
                }),
                buildListTile(
                    snapshot.data!.isLandlord!
                        ? 'Landlord Dashboard'
                        : 'Become a Landlord',
                    Icons.person_outline, () {
                  if (snapshot.data!.isLandlord!) {
                    Get.to(() => const LandlordDashboard());
                  } else {
                    showDialog(
                        context: context,
                        builder: (ctx) => const Dialog(
                              child: SingleChildScrollView(
                                  child: RequestLandlord()),
                            ));
                  }
                }),
                buildListTile('Password', Icons.lock_outline, () {
                  Get.to(() => ChangePassword());
                }),
                buildListTile('Wishlist', Icons.favorite_border_outlined, () {
                  Get.to(() => const WishlistScreen());
                }),
                buildListTile('Notifications', Icons.notifications_none, () {
                  Get.to(() => const NotificationsScreen());
                }),
                buildListTile('Logout', Icons.logout, () async {
                  await FirebaseAuth.instance.signOut();

                  Get.offAll(() => const LoginPage());
                }),
              ],
            );
          }),
    );
  }

  Widget buildListTile(String title, IconData icon, Function onTap) {
    return Column(
      children: [
        ListTile(
          leading: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: kPrimaryColor.withOpacity(0.2),
              ),
              child: Icon(
                icon,
                color: kPrimaryColor,
              )),
          title: Text(title),
          trailing: const Icon(
            Icons.arrow_forward_ios,
            size: 16,
          ),
          onTap: () => onTap(),
        ),
        Divider(),
      ],
    );
  }
}
