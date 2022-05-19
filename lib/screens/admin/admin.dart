import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:get/route_manager.dart';
import 'package:provider/provider.dart';
import 'package:rent_space/helpers/loading_effect.dart';
import 'package:rent_space/models/space_model.dart';
import 'package:rent_space/providers/invoice_provider.dart';
import 'package:rent_space/providers/payment_provider.dart';
import 'package:rent_space/providers/post_provider.dart';
import 'package:rent_space/screens/admin/all_landlords.dart';
import 'package:rent_space/screens/admin/alll_users_screen.dart';
import 'package:rent_space/screens/auth/login_page.dart';
import 'package:rent_space/screens/chat/chat_screen.dart';
import 'package:rent_space/screens/landlord/landlord_analytics.dart';
import 'package:rent_space/widgets/space_tile.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('System Administration'),
        actions: [
          IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                Get.offAll(() => const LoginPage());
              }),
        ],
      ),
      body: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            buildActionButton(
              color: Colors.green,
              icon: Icons.person_outline,
              onPressed: () {
                Get.to(() => const AllUsersScreen());
              },
              title: 'Manage\nUsers',
            ),
            buildActionButton(
              color: Colors.orange,
              icon: Icons.house_outlined,
              onPressed: () {
                Get.to(() => const AllLandlordsScreen());
              },
              title: 'Manage\nLandlords',
            ),
            buildActionButton(
              color: Colors.blue,
              icon: Icons.show_chart,
              onPressed: () async {
                final invoice =
                    await Provider.of<PaymentProvider>(context, listen: false)
                        .getTransactions();

                final pdfFile = await PdfInvoiceApi.generate(invoice);

                PdfApi.openFile(pdfFile);
              },
              title: 'System\nAnalytics',
            ),
            buildActionButton(
              color: Colors.red,
              icon: Icons.people_outline_outlined,
              onPressed: () {
                Get.to(() => const ChatScreen());
              },
              title: 'Users\nSupport',
            ),
          ],
        ),
        const SizedBox(
          height: 20,
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            'Recent Spaces',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ),
        Expanded(
          child: FutureBuilder<List<SpaceModel>>(
            future:
                Provider.of<PostProvider>(context, listen: false).getSpaces(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return LoadingEffect.getSearchLoadingScreen(context);
              }

              return ListView(
                  children: snapshot.data!
                      .map((e) => Container(
                          margin: const EdgeInsets.all(10),
                          child: SpacerTile(space: e)))
                      .toList());
            },
          ),
        ),
      ]),
    );
  }

  Widget buildActionButton({
    required IconData? icon,
    required Function? onPressed,
    required String? title,
    required Color? color,
  }) {
    return GestureDetector(
      onTap: () => onPressed!(),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
                color: color!.withOpacity(0.5),
                borderRadius: BorderRadius.circular(5)),
            child: Icon(
              icon,
              color: color,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            title!,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }
}
