import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:rent_space/firebase_options.dart';
import 'package:rent_space/models/chat_provider.dart';
import 'package:rent_space/providers/admin_provider.dart';
import 'package:rent_space/providers/auth_provider.dart';
import 'package:rent_space/providers/location_provider.dart';
import 'package:rent_space/providers/payment_provider.dart';
import 'package:rent_space/providers/post_provider.dart';
import 'package:rent_space/providers/tenancy_provider.dart';
import 'package:rent_space/providers/wishlist_provider.dart';
import 'package:rent_space/screens/auth/login_page.dart';
import 'package:rent_space/screens/chat/chat_room.dart';
import 'package:rent_space/screens/home/my_nav.dart';
import 'package:rent_space/widgets/initial_loading.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (ctx) => LocationProvider()),
        ChangeNotifierProvider(create: (ctx) => AuthProvider()),
        ChangeNotifierProvider(create: (ctx) => PostProvider()),
        ChangeNotifierProvider(create: (ctx) => WishlistProvider()),
        ChangeNotifierProvider(create: (ctx) => PaymentProvider()),
        ChangeNotifierProvider(create: (ctx) => ChatProvider()),
        ChangeNotifierProvider(create: (ctx) => TenancyProvider()),
        ChangeNotifierProvider(create: (ctx) => AdminProvider()),
      ],
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          visualDensity: VisualDensity.adaptivePlatformDensity,
          backgroundColor: const Color(0xFFF5F6F6),
          primaryColor: const Color(0xFF811B83),
          colorScheme: ColorScheme.fromSwatch().copyWith(
            secondary: const Color(0xFFFA5019),
          ),
          appBarTheme: AppBarTheme(
            elevation: 0,
            iconTheme: const IconThemeData(
              color: Colors.black,
            ),
            titleTextStyle: GoogleFonts.ibmPlexSans(
              color: Colors.black,
              fontSize: 18,
            ),
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          ),
          textTheme: GoogleFonts.ibmPlexSansTextTheme(
            Theme.of(context).textTheme,
          ).copyWith(
            headline1: GoogleFonts.ibmPlexSans(
              color: const Color(0xFF100E34),
            ),
            bodyText1: GoogleFonts.ibmPlexSans(
              color: const Color(0xFF100E34).withOpacity(0.5),
            ),
          ),
        ),
        home: StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return const InitialLoadingScreen();
              } else {
                return const LoginPage();
              }
            }),
        routes: {
          ChatRoom.routeName: (ctx) => ChatRoom(),
        },
      ),
    );
  }
}
