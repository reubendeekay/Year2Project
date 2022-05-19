import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:rent_space/helpers/constants.dart';
import 'package:rent_space/models/space_model.dart';
import 'package:rent_space/providers/payment_provider.dart';
import 'package:rent_space/screens/profile/user_profile.dart';
import 'package:sliver_header_delegate/sliver_header_delegate.dart';

class TenantDetailsScreen extends StatelessWidget {
  const TenantDetailsScreen({Key? key, required this.space}) : super(key: key);
  final SpaceModel space;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
        body: CustomScrollView(slivers: [
      SliverPersistentHeader(
        pinned: true,
        delegate: FlexibleHeaderDelegate(
          backgroundColor: kPrimaryColor,
          expandedHeight: size.height * 0.3,
          statusBarHeight: MediaQuery.of(context).padding.top,
          children: [
            FlexibleTextItem(
              text: space.spaceName!,
              expandedStyle: GoogleFonts.ibmPlexSans(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
              collapsedStyle:
                  GoogleFonts.ibmPlexSans(color: Colors.black, fontSize: 14),
              expandedAlignment: Alignment.bottomCenter,
              collapsedAlignment: Alignment.center,
              expandedPadding: const EdgeInsets.all(15),
            ),
          ],
        ),
      ),
      SliverList(
          delegate: SliverChildListDelegate([
        TenantDetailsRoomWidget(
          space: space,
        ),
        DaysWidget(
          space: space,
        ),
        const RentRepaymentHistory(),
      ]))
    ]));
  }
}

class TenantDetailsRoomWidget extends StatelessWidget {
  const TenantDetailsRoomWidget({Key? key, required this.space})
      : super(key: key);
  final SpaceModel space;
  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    return Container(
      margin: const EdgeInsets.all(15),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(
          children: [
            const Icon(
              Icons.location_on,
              color: kPrimaryColor,
              size: 18,
            ),
            const SizedBox(
              width: 8,
            ),
            Text(space.spaceName!),
            const SizedBox(width: 10),
            Container(
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                  color: Colors.green, borderRadius: BorderRadius.circular(20)),
              child: const Text(
                'Checked in',
                style: TextStyle(color: Colors.white, fontSize: 12),
              ),
            ),
          ],
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
              'KES ${space.price!.toStringAsFixed(0)}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        RaisedButton(
            onPressed: () {
              showUserPaymentDialog(context, space);
            },
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
            color: kPrimaryColor,
            textColor: Colors.white,
            child: const Text('Make payment')),
        const SizedBox(height: 15),
        DateField(
          value: DateFormat('dd/MM/yyyy').format(DateTime.now()),
        ),
        DateField(
          title: 'Check out',
          days: space.rentTime!,
        ),
        const SizedBox(height: 10),
        InkWell(
          onTap: () async {
            await Provider.of<PaymentProvider>(context, listen: false)
                .checkOut(uid, space);
            Navigator.of(context).pop();
            Navigator.of(context).pop();
            Get.snackbar('Checked Out',
                'You have successfully checked out from ${space.spaceName!}');
          },
          child: const Text('Checkout Now',
              style:
                  TextStyle(color: kPrimaryColor, fontWeight: FontWeight.w600)),
        ),
        const SizedBox(height: 10),
      ]),
    );
  }
}

class DateField extends StatelessWidget {
  const DateField({Key? key, this.title, this.value, this.days})
      : super(key: key);
  final String? title, value;
  final int? days;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
          color: Colors.grey[200], borderRadius: BorderRadius.circular(3)),
      child: Row(children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title ?? 'Check in',
                style: const TextStyle(color: Colors.grey, fontSize: 12),
              ),
              const SizedBox(
                height: 2,
              ),
              Text(
                value ??
                    DateFormat('dd/MM/yyyy')
                        .format(DateTime.now().add(const Duration(days: 30))),
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
        const Icon(
          Icons.calendar_month_rounded,
          color: Colors.grey,
        ),
      ]),
    );
  }
}

class DaysWidget extends StatelessWidget {
  const DaysWidget({Key? key, required this.space}) : super(key: key);
  final SpaceModel space;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(3)),
      child: Row(
        children: [
          Expanded(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
                Text(space.rentTime.toString(),
                    style: const TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 40,
                        color: kPrimaryColor)),
                const SizedBox(width: 3),
                const Text(
                  'Days',
                )
              ]),
              const SizedBox(height: 6),
              const Text('Total stay')
            ],
          )),
          SizedBox(
              height: 80,
              child: Opacity(
                opacity: 0.25,
                child: Image.asset(
                  'assets/images/logo.png',
                  fit: BoxFit.fitHeight,
                ),
              ))
        ],
      ),
    );
  }
}

class RentRepaymentHistory extends StatelessWidget {
  const RentRepaymentHistory({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(3)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Rent Repayment History',
            style: TextStyle(
                fontSize: 15,
                color: kPrimaryColor,
                fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(15),
            color: Colors.grey[200],
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text(
                  'Month',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                Text(
                  'Due date',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                Text(
                  'Status',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          rentDetails('May'),
          rentDetails('April'),
          rentDetails('March'),
        ],
      ),
    );
  }

  Widget rentDetails(String month) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('$month, 2022'),
              Text('06/$month/2022'),
              const Text(
                'Paid',
                style: const TextStyle(color: Colors.green),
              ),
            ],
          ),
        ),
        const Divider(),
      ],
    );
  }
}
