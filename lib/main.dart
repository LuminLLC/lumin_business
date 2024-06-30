import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lumin_business/common/size_and_spacing.dart';
import 'package:lumin_business/providers/app_state.dart';
import 'package:lumin_business/providers/menu_controller.dart';
import 'package:lumin_business/providers/order_controller.dart';
import 'package:lumin_business/providers/product_controller.dart';
import 'package:provider/provider.dart';
import 'modules/general_platform/home_page.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider<AppState>(create: (context) => AppState()),
    ChangeNotifierProvider<PlatformMenuController>(
        create: (context) => PlatformMenuController()),
    ChangeNotifierProvider<ProductController>(
        create: (context) => ProductController()),
  ], child: LuminBusiness()));
}

class LuminBusiness extends StatelessWidget {
  final SizeAndSpacing sp = SizeAndSpacing();

  @override
  Widget build(BuildContext context) {
    final providers = [EmailAuthProvider()];
    return MaterialApp(
      title: 'Lumin Business',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
          scaffoldBackgroundColor: Color(0xFF1E1E1E),
          primaryColor: Colors.white,
          textTheme: GoogleFonts.dmSansTextTheme(Theme.of(context)
              .textTheme
              .copyWith(
                  bodyLarge: TextStyle(color: Colors.white),
                  bodyMedium: TextStyle(color: Colors.white),
                  displayLarge: TextStyle(color: Colors.white),
                  displayMedium: TextStyle(color: Colors.white),
                  displaySmall: TextStyle(color: Colors.white),
                  headlineMedium: TextStyle(color: Colors.white),
                  headlineLarge: TextStyle(color: Colors.white),
                  headlineSmall: TextStyle(color: Colors.white),
                  titleMedium: TextStyle(color: Colors.white),
                  titleLarge: TextStyle(color: Colors.white),
                  titleSmall: TextStyle(color: Colors.white),
                  bodySmall: TextStyle(color: Colors.white),
                  labelSmall: TextStyle(color: Colors.white)))),
      routes: {
        "/platform": (context) => HomePage(),
        '/sign-in': (context) {
          // duplicateDocument();
          return SignInScreen(
            showPasswordVisibilityToggle: true,
            subtitleBuilder: (context, action) {
              return const Text(
                "Hi to Lumin Business! Please sign in to continue.",
                style: TextStyle(color: Colors.white),
              );
            },
            providers: providers,
            headerBuilder: (context, constraint, _) => Image.asset(
              'assets/logo_nobg.png',
              fit: BoxFit.fitWidth,
              width: 200,
            ),
            sideBuilder: (
              context,
              constraint,
            ) =>
                Image.asset('assets/logo_white_nobg.png'),
            actions: [
              AuthStateChangeAction<SignedIn>((context, state) {
                Navigator.pushReplacementNamed(context, '/platform');
              }),
            ],
          );
        },
      },
      initialRoute: '/sign-in',
    );
  }
}
