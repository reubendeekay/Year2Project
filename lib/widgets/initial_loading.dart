import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:provider/provider.dart';
import 'package:rent_space/helpers/loading_effect.dart';
import 'package:rent_space/providers/auth_provider.dart';
import 'package:rent_space/screens/admin/admin.dart';
import 'package:rent_space/screens/home/my_nav.dart';

class InitialLoadingScreen extends StatefulWidget {
  const InitialLoadingScreen({Key? key}) : super(key: key);

  @override
  State<InitialLoadingScreen> createState() => _InitialLoadingScreenState();
}

class _InitialLoadingScreenState extends State<InitialLoadingScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Future.delayed(Duration.zero, () async {
      final user = await Provider.of<AuthProvider>(context, listen: false)
          .getCurrentUser();

      if (user.isAdmin!) {
        Get.off(() => const AdminDashboard());
      } else {
        Get.off(() => const MainPage());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LoadingEffect.getSearchLoadingScreen(context),
    );
  }
}
