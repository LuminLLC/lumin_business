import 'package:feedback/feedback.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lumin_business/common/size_and_spacing.dart';
import 'package:lumin_business/modules/accounting/accounting_provider.dart';
import 'package:lumin_business/modules/customers/customer_provider.dart';
import 'package:lumin_business/modules/general_platform/app_state.dart';
import 'package:lumin_business/modules/general_platform/menu_controller.dart';
import 'package:lumin_business/modules/inventory/inventory_provider.dart.dart';
import 'package:lumin_business/modules/login/create_business.dart';
import 'package:lumin_business/modules/login/lumin_auth_provider.dart';
import 'package:lumin_business/modules/login/login_screen.dart';
import 'package:lumin_business/modules/login/signup_screen.dart';
import 'package:lumin_business/modules/login/uplaod_data.dart';
import 'package:lumin_business/modules/suppliers/supplier_provider.dart';
import 'package:provider/provider.dart';
import 'modules/general_platform/home_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider<AccountingProvider>(
        create: (context) => AccountingProvider()),
    ChangeNotifierProvider<LuminAuthProvider>(
        create: (context) => LuminAuthProvider()),
    ChangeNotifierProvider<SupplierProvider>(
        create: (context) => SupplierProvider()),
    ChangeNotifierProvider<CustomerProvider>(
        create: (context) => CustomerProvider()),
    ChangeNotifierProvider<AppState>(create: (context) => AppState()),
    ChangeNotifierProvider<PlatformMenuController>(
        create: (context) => PlatformMenuController()),
    ChangeNotifierProvider<InventoryProvider>(
        create: (context) => InventoryProvider()),
  ], child: BetterFeedback(child: LuminBusiness())));
}

class LuminBusiness extends StatelessWidget {
  final SizeAndSpacing sp = SizeAndSpacing();

  @override
  Widget build(BuildContext context) {
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
        "/sign-in": (context) => LoginScreen(),
        "/sign-up": (context) => SignupScreen(),
        "/createBusiness": (context) => CreateBusinessScreen(),
        "/uploadData": (context) => UploadData()
      },
      initialRoute: '/sign-in',
      // home: ChartExample(),
    );
  }
}
