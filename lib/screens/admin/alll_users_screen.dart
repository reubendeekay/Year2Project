import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rent_space/helpers/constants.dart';
import 'package:rent_space/helpers/loading_effect.dart';
import 'package:rent_space/models/user_model.dart';
import 'package:rent_space/providers/admin_provider.dart';
import 'package:rent_space/screens/admin/user_actions.dart';

class AllUsersScreen extends StatelessWidget {
  const AllUsersScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Users'),
      ),
      body: FutureBuilder<List<UserModel>>(
          future:
              Provider.of<AdminProvider>(context, listen: false).getAllUsers(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return LoadingEffect.getSearchLoadingScreen(context);
            }

            return ListView(
                children: snapshot.data!
                    .map(
                      (e) => ListTile(
                        title: Row(
                          children: [
                            Text(e.name!),
                            const SizedBox(
                              width: 5,
                            ),
                            if (e.isAdmin!)
                              const Icon(
                                Icons.verified,
                                color: kPrimaryColor,
                                size: 16,
                              )
                          ],
                        ),
                        onTap: () {
                          actionSheet(context, e);
                        },
                        subtitle: Text(e.email!),
                        leading: CircleAvatar(
                          backgroundColor: Colors.grey,
                          backgroundImage: NetworkImage(e.profile!),
                        ),
                      ),
                    )
                    .toList());
          }),
    );
  }
}
