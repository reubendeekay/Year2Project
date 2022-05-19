import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:lottie/lottie.dart';
import 'package:rent_space/helpers/constants.dart';
import 'package:rent_space/screens/home/my_nav.dart';

class PaymentSuccessfulScreen extends StatelessWidget {
  const PaymentSuccessfulScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: SizedBox(
                height: 200,
                child: Transform.scale(
                    scale: 2, child: Lottie.asset('assets/pay_success.json'))),
          ),
          const Text(
            'Payment Successful',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 20,
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 30),
            child: const Text(
              'You have successfully paid for the space. Contact the space owner for more information on checking in. Thank you for using SpaceScape.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
          ),
          const SizedBox(
            height: 50,
          ),
          Container(
              width: double.infinity,
              margin: const EdgeInsets.symmetric(horizontal: 20),
              height: 48,
              child: RaisedButton(
                onPressed: () {
                  Get.offAll(() => const MainPage());
                },
                color: kPrimaryColor,
                child: const Text(
                  'Back to Home',
                  style: TextStyle(color: Colors.white),
                ),
              )),
        ],
      ),
    );
  }
}
