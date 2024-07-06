import 'package:adss_machine_test_e_commerce/providers/cart_provider.dart';
import 'package:adss_machine_test_e_commerce/providers/dishes_provider.dart';
import 'package:adss_machine_test_e_commerce/view/checkout_screen.dart';
import 'package:adss_machine_test_e_commerce/view/phone_auth.dart';
import 'package:adss_machine_test_e_commerce/view/user_home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String? user;

  @override
  void initState() {
    super.initState();
    checkAuthStatus();
  }

  void checkAuthStatus() async {
    //Sample persistence of user data

    SharedPreferences prefs = await SharedPreferences.getInstance();
    user = prefs.getString('user');
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<DishesProvider>(
            create: (context) => DishesProvider()),
        ChangeNotifierProvider<CartProvider>(
            create: (context) => CartProvider())
      ],
      child: ScreenUtilInit(
          designSize: const Size(392.72, 850.90),
          minTextAdapt: true,
          builder: (BuildContext context, Widget? child) {
            Widget screenToDisplay;

            if (user == null) {
              screenToDisplay = const AuthenticationScreen();
            } else {
              screenToDisplay = const ScreenUserHome();
            }

            return MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Machine-Test',
              theme: ThemeData(
                colorSchemeSeed: const Color(0xFF4CAC52),
                useMaterial3: true,
              ),
              routes: {
                '/homeScreen': (BuildContext ctx) => const ScreenUserHome(),
                '/phoneAuth': (BuildContext ctx) =>
                    const AuthenticationScreen(),
                '/checkoutScreen': (BuildContext ctx) => const ScreenCheckout(),
              },
              home: screenToDisplay,
            );
          }),
    );
  }
}
