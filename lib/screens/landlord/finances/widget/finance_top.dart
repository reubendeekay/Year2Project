import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:rent_space/helpers/constants.dart';
import 'package:rent_space/providers/auth_provider.dart';
import 'package:rent_space/screens/landlord/finances/widget/withdraw_widget.dart';

class FinanceTop extends StatelessWidget {
  const FinanceTop({Key? key}) : super(key: key);

  String amount(String amount) {
    return amount.replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},');
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final balance = Provider.of<AuthProvider>(context).user!.balance;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Container(
        height: 70,
        width: size.width,
        decoration: BoxDecoration(
            color: kPrimaryColor.withOpacity(0.2),
            borderRadius: BorderRadius.circular(30)),
        child: Container(
          padding: const EdgeInsets.all(15),
          child: Row(
            children: [
              SizedBox(
                  height: 30,
                  width: 30,
                  child: Image.asset('assets/images/coin.png')),
              const SizedBox(width: 10),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Account Balance',
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                  Text(
                    'KES ' + balance!.toStringAsFixed(2),
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              // ),
              const Spacer(),

              GestureDetector(
                onTap: () {
                  showModalBottomSheet(
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      context: context,
                      builder: (ctx) {
                        return const WithdrawWidget();
                      });
                },
                child: Container(
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      color: Colors.black12,
                      borderRadius: BorderRadius.circular(5)),
                  child: const Icon(
                    Icons.credit_card,
                    color: Colors.pinkAccent,
                    size: 22,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
