import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/route_manager.dart';
import 'package:provider/provider.dart';
import 'package:rent_space/models/user_model.dart';
import 'package:rent_space/providers/auth_provider.dart';
import 'package:rent_space/screens/chat/chat_screen.dart';
import 'package:rent_space/screens/profile/user_profile.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            FutureBuilder<UserModel>(
                future: Provider.of<AuthProvider>(context, listen: false)
                    .getCurrentUser(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return GestureDetector(
                      onTap: () {
                        Get.to(() => const UserProfileScreen());
                      },
                      child: CircleAvatar(
                        radius: 20,
                        backgroundImage: NetworkImage(snapshot.data!.profile!),
                      ),
                    );
                  }
                  return const CircleAvatar(
                    backgroundImage: AssetImage('assets/images/avatar.jpeg'),
                  );
                }),
            IconButton(
              onPressed: () {
                Get.to(() => const ChatScreen());
              },
              icon: const Icon(CupertinoIcons.text_bubble),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(50);
}
