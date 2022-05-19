import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rent_space/helpers/loading_effect.dart';
import 'package:rent_space/providers/payment_provider.dart';
import 'package:rent_space/providers/tenant_model.dart';

class AllTenantsScreen extends StatelessWidget {
  const AllTenantsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Tenants'),
      ),
      body: FutureBuilder<List<TenantModel>>(
          future: Provider.of<PaymentProvider>(context, listen: false)
              .fetchTenants(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return LoadingEffect.getSearchLoadingScreen(context);
            }

            return ListView(
                children: snapshot.data!
                    .map(
                      (e) => ListTile(
                        title: Text(e.user!.name!),
                        onTap: () {
                          userDetailsDialog(context, e);
                        },
                        subtitle: Text(e.space!.spaceName!),
                        leading: CircleAvatar(
                          backgroundColor: Colors.grey,
                          backgroundImage: NetworkImage(e.user!.profile!),
                        ),
                      ),
                    )
                    .toList());
          }),
    );
  }

  void userDetailsDialog(BuildContext context, TenantModel tenant) {
    showDialog(
        context: context,
        builder: (context) => Dialog(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      const Text(
                        'Tenant Details',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.grey,
                            backgroundImage:
                                NetworkImage(tenant.user!.profile!),
                            radius: 26,
                          ),
                          const SizedBox(width: 15),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                tenant.user!.name!,
                                style: const TextStyle(fontSize: 16),
                              ),
                              const SizedBox(height: 5),
                              Text(tenant.user!.phone!),
                              const SizedBox(height: 2.5),
                              Text(tenant.user!.email!),
                            ],
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ));
  }
}
