import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:rent_space/helpers/constants.dart';
import 'package:rent_space/helpers/loading_effect.dart';
import 'package:rent_space/helpers/mpesa_helper.dart';
import 'package:rent_space/helpers/my_dropdown.dart';
import 'package:rent_space/models/space_model.dart';
import 'package:rent_space/models/user_model.dart';
import 'package:rent_space/providers/auth_provider.dart';
import 'package:rent_space/providers/tenancy_provider.dart';
import 'package:rent_space/screens/profile/tenant_details_screen.dart';
import 'package:sliver_header_delegate/sliver_header_delegate.dart';

class UserProfileScreen extends StatelessWidget {
  const UserProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
        body: FutureBuilder<UserModel>(
            future: Provider.of<AuthProvider>(context, listen: false)
                .getCurrentUser(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return LoadingEffect.getSearchLoadingScreen(context);
              }

              return CustomScrollView(slivers: [
                SliverPersistentHeader(
                  pinned: true,
                  delegate: FlexibleHeaderDelegate(
                    backgroundColor: kPrimaryColor,
                    expandedHeight: size.height * 0.3,
                    background: MutableBackground(
                      expandedWidget: Image.network(
                        snapshot.data!.profile!,
                        fit: BoxFit.cover,
                      ),
                      collapsedColor: kPrimaryColor,
                    ),
                    statusBarHeight: MediaQuery.of(context).padding.top,
                    children: [
                      FlexibleTextItem(
                        text: snapshot.data!.name! + ' Profile',
                        expandedStyle: GoogleFonts.ibmPlexSans(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                        collapsedStyle: GoogleFonts.ibmPlexSans(
                            color: Colors.black, fontSize: 14),
                        expandedAlignment: Alignment.bottomCenter,
                        collapsedAlignment: Alignment.center,
                        expandedPadding: const EdgeInsets.all(15),
                      ),
                    ],
                  ),
                ),
                SliverList(
                    delegate: SliverChildListDelegate([
                  RecentUserSpace(
                    user: snapshot.data!,
                  ),
                  UserProfileDetails(user: snapshot.data!),
                ]))
              ]);
            }));
  }
}

class RecentUserSpace extends StatelessWidget {
  const RecentUserSpace({Key? key, required this.user}) : super(key: key);
  final UserModel user;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<SpaceModel>>(
      future: Provider.of<TenancyProvider>(context, listen: false)
          .getUserTenancy(user),
      builder: ((context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (snapshot.data!.isEmpty) {
          return Container(
            color: Colors.white,
            margin: const EdgeInsets.all(15),
            padding: const EdgeInsets.all(50),
            child: const Center(
              child: Text('No spaces rented'),
            ),
          );
        }
        final space = snapshot.data!.first;
        return Container(
          margin: const EdgeInsets.all(15),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(5),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Tenancy Details',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              const SizedBox(
                height: 10,
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                onTap: () {
                  Get.to(() => TenantDetailsScreen(space: space));
                },
                leading: CircleAvatar(
                  backgroundColor: Colors.grey,
                  backgroundImage: NetworkImage(space.images!.first),
                ),
                title: Text(space.spaceName!),
                subtitle: Text(space.address!),
                trailing: const Icon(
                  Icons.arrow_forward_ios,
                  size: 14,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  const Text(
                    'Total due Amount: ',
                    style: TextStyle(color: Colors.grey),
                  ),
                  Text(
                    'KES ' + space.price!.toStringAsFixed(0),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  RaisedButton(
                      onPressed: () {
                        showUserPaymentDialog(context, space);
                      },
                      color: kPrimaryColor,
                      textColor: Colors.white,
                      child: const Text('Make payment')),
                  const SizedBox(width: 10),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: Colors.red.withOpacity(0.1),
                      border: Border.all(color: Colors.red),
                    ),
                    padding:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    child: const Text(
                      'Needs attention',
                      style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.w300,
                          fontSize: 12),
                    ),
                  )
                ],
              )
            ],
          ),
        );
      }),
    );
  }
}

class UserProfileDetails extends StatelessWidget {
  const UserProfileDetails({Key? key, required this.user}) : super(key: key);
  final UserModel user;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(15),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text(
          'About me',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const SizedBox(
          height: 10,
        ),
        detailWidget(Icons.person_outline, user.name!),
        detailWidget(Icons.email_outlined, user.email!),
        detailWidget(Icons.call_outlined, user.phone!),
        detailWidget(Icons.home_outlined, user.userId!),
      ]),
    );
  }

  Widget detailWidget(IconData icon, String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Row(
        children: [
          Icon(icon, size: 20, color: kPrimaryColor),
          const SizedBox(width: 10),
          Text(
            title,
          ),
        ],
      ),
    );
  }
}

showUserPaymentDialog(BuildContext context, SpaceModel space) {
  showDialog(
      context: context,
      builder: (ctx) => Dialog(
              child: UserPaymentDialog(
            space: space,
          )));
}

class UserPaymentDialog extends StatelessWidget {
  const UserPaymentDialog({Key? key, required this.space}) : super(key: key);
  final SpaceModel space;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AuthProvider>(context, listen: false).user;
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                const Text(
                  'Make Payment',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                InkWell(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: const Icon(Icons.close))
              ],
            ),
            const SizedBox(
              height: 5,
            ),
            const Divider(),
            const SizedBox(
              height: 10,
            ),
            const Text(
              'Payment For',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            MyDropDown(
              selectedOption: (val) {},
              options: [
                'Total Due Amount',
                'Custom Amount',
              ],
              hintText: 'Amount to pay',
            ),
            const SizedBox(
              height: 10,
            ),
            const Text(
              'Payment Using',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            MyDropDown(
              selectedOption: (val) {},
              options: [
                'Mpesa',
              ],
              hintText: 'Select payment method',
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const Text('Due'),
                const SizedBox(
                  width: 20,
                ),
                Text('KES ' + space.price!.toStringAsFixed(0)),
              ],
            ),
            const Divider(
              color: Colors.black,
            ),
            const SizedBox(
              height: 5,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const Text(
                  'Total Due',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  width: 20,
                ),
                Text(
                  'KES ' + space.price!.toStringAsFixed(0),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(
              height: 5,
            ),
            const Divider(
              color: Colors.black,
            ),
            const SizedBox(
              height: 5,
            ),
            Row(
              children: [
                const Spacer(),
                RaisedButton(
                    onPressed: () async {
                      await mpesaPayment(
                        amount: space.price!.toDouble(),
                        phone: user!.phone!,
                      );
                      Navigator.of(context).pop();
                    },
                    color: kPrimaryColor,
                    textColor: Colors.white,
                    child: const Text('Make payment')),
                const SizedBox(width: 10),
              ],
            )
          ],
        ),
      ),
    );
  }
}
