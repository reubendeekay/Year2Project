import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:provider/provider.dart';
import 'package:rent_space/providers/auth_provider.dart';
import 'package:rent_space/screens/home/view_all_screen.dart';
import 'package:rent_space/screens/landlord/add_space.dart';
import 'package:rent_space/screens/landlord/all_tenants_screen.dart';
import 'package:rent_space/screens/landlord/finances/finance_overview_screen.dart';
import 'package:rent_space/screens/landlord/landlord_analytics.dart';
import 'package:rent_space/screens/landlord/landlord_spaces.dart';
import 'package:rent_space/screens/landlord/widgets/recent_tenants.dart';

class LandlordDashboard extends StatelessWidget {
  const LandlordDashboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AuthProvider>(context, listen: false).user;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Landlord Dashboard'),
      ),
      body: ListView(
        children: [
          Container(
            margin: const EdgeInsets.all(20),
            child: Column(
              children: [
                const Text(
                  'BALANCE',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                const SizedBox(height: 10),
                Text('KES ' + user!.balance!.toStringAsFixed(2)),
              ],
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              buildActionButton(
                color: Colors.green,
                icon: Icons.add,
                onPressed: () {
                  Get.to(() => const AddSpaceScreen());
                },
                title: 'List\nSpace',
              ),
              buildActionButton(
                color: Colors.orange,
                icon: Icons.house_outlined,
                onPressed: () {
                  Get.to(() => const LandlordSpaces());
                },
                title: 'View\nSpaces',
              ),
              buildActionButton(
                color: Colors.blue,
                icon: Icons.show_chart,
                onPressed: () {
                  Get.to(() => const FinanceOverviewScreen());
                },
                title: 'Your\nAnalytics',
              ),
              buildActionButton(
                color: Colors.red,
                icon: Icons.people_outline_outlined,
                onPressed: () {
                  Get.to(() => const AllTenantsScreen());
                },
                title: 'Your\nTenants',
              ),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          Container(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: const Text(
                'Recent Tenants',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              )),
          const RecentTenantsWidget(),
        ],
      ),
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
