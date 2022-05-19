import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:provider/provider.dart';
import 'package:rent_space/helpers/constants.dart';
import 'package:rent_space/helpers/mpesa_helper.dart';
import 'package:rent_space/helpers/my_loader.dart';
import 'package:rent_space/models/space_model.dart';
import 'package:rent_space/models/user_model.dart';
import 'package:rent_space/providers/auth_provider.dart';
import 'package:rent_space/providers/payment_provider.dart';
import 'package:rent_space/providers/post_provider.dart';
import 'package:rent_space/screens/payment/payment_successfu_screen.dart';
import 'package:rent_space/widgets/space_tile.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({Key? key, required this.space}) : super(key: key);
  final SpaceModel space;

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AuthProvider>(context, listen: false).user;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Payment Details',
          style: TextStyle(color: Colors.black),
        ),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        backgroundColor: Colors.transparent,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          SpacerTile(space: widget.space),
          const SizedBox(height: 15),
          const Text(
            'Your Details',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(15),
            width: double.infinity,
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.person_outline,
                      size: 18,
                      color: kPrimaryColor,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      user!.name!,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                buildUserDetail(Icons.email_outlined, user.email!),
                const SizedBox(height: 10),
                buildUserDetail(Icons.call_outlined, user.phone!),
                const SizedBox(height: 10),
                Text(user.name!),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Landlord Details',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          FutureBuilder<UserModel>(
              future: Provider.of<PostProvider>(context, listen: false)
                  .fetchLandLordDetails(widget.space.ownerId!),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const MyLoader();
                }
                final owner = snapshot.data!;
                return Container(
                  padding: const EdgeInsets.all(15),
                  width: double.infinity,
                  color: Colors.white,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.person_outline,
                            size: 18,
                            color: kPrimaryColor,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(
                            owner.name!,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      buildUserDetail(Icons.email_outlined, owner.email!),
                      const SizedBox(height: 10),
                      buildUserDetail(Icons.call_outlined, owner.phone!),
                      const SizedBox(height: 10),
                      Text(user.name!),
                    ],
                  ),
                );
              }),
          const Spacer(),
          SizedBox(
              width: double.infinity,
              height: 48,
              child: RaisedButton(
                onPressed: () async {
                  setState(() {
                    isLoading = true;
                  });
                  await mpesaPayment(amount: 1, phone: user.phone!);

                  await Provider.of<PaymentProvider>(context, listen: false)
                      .rentSpace(
                    FirebaseAuth.instance.currentUser!.uid,
                    widget.space,
                  );

                  setState(() {
                    isLoading = false;
                  });

                  Get.off(() => const PaymentSuccessfulScreen());
                },
                color: kPrimaryColor,
                child: isLoading
                    ? const MyLoader()
                    : Text(
                        'Pay via Mpesa + KES ${widget.space.price!.toStringAsFixed(0)}',
                        style: const TextStyle(color: Colors.white),
                      ),
              )),
          const SizedBox(height: 15),
        ]),
      ),
    );
  }

  Widget buildUserDetail(
    IconData icon,
    String title,
  ) {
    return Row(
      children: [
        Icon(
          icon,
          size: 18,
          color: kPrimaryColor,
        ),
        const SizedBox(
          width: 10,
        ),
        Text(
          title,
        ),
      ],
    );
  }
}
