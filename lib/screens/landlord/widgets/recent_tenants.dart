import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rent_space/providers/payment_provider.dart';
import 'package:rent_space/providers/tenant_model.dart';

class RecentTenantsWidget extends StatelessWidget {
  const RecentTenantsWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<TenantModel>>(
        future:
            Provider.of<PaymentProvider>(context, listen: false).fetchTenants(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return Container(
            margin: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: snapshot.data!
                    .map(
                      (e) => ListTile(
                        title: Text(e.user!.name!),
                        onTap: () {},
                        subtitle: Text(e.space!.spaceName!),
                        leading: CircleAvatar(
                          backgroundColor: Colors.grey,
                          backgroundImage: NetworkImage(e.user!.profile!),
                        ),
                      ),
                    )
                    .toList()),
          );
        });
  }
}
