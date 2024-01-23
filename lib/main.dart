import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fusia/server/arguments_pass/temp_pass_detail_outlet.dart';

import 'package:fusia/view/account/account_information_screen.dart';
import 'package:fusia/view/account/account_page.dart';
import 'package:fusia/view/account/camera_preview.dart';
import 'package:fusia/view/account/change_password_page.dart';
import 'package:fusia/view/account/memberhip_screen.dart';

import 'package:fusia/view/auth/login_page.dart';
import 'package:fusia/view/auth/otp_verification_page.dart';
import 'package:fusia/view/auth/register_page.dart';
import 'package:fusia/view/benefits/benefits.dart';
import 'package:fusia/view/home_dashboard_page.dart';
import 'package:fusia/view/home_navigation_menu_page.dart';
import 'package:fusia/view/onboarding_page.dart';
import 'package:fusia/view/outlet/detail_outlet_menu_page.dart';
import 'package:fusia/view/outlet/detail_outlet_page.dart';
import 'package:fusia/view/outlet/detail_outlet_telephone_page.dart';
import 'package:fusia/view/outlet/outlet_page.dart';
import 'package:fusia/view/promo/detail_promo_page.dart';
import 'package:fusia/view/promo/promo_page.dart';
import 'package:fusia/view/reservation/reservation_detail.dart';
import 'package:fusia/view/reservation/reservation_page.dart';
import 'package:fusia/view/splash_screen_page.dart';
import 'package:fusia/view/voucher/voucher_page.dart';

import 'view/reservation/reservation_history.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  static GlobalKey<NavigatorState> navKey = GlobalKey<NavigatorState>();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: const Size(360, 690),
        minTextAdapt: true,
        builder: () {
          return MaterialApp(
            title: 'Fusia App',
            navigatorKey: navKey,
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              visualDensity: VisualDensity.adaptivePlatformDensity,
            ),
            builder: (context, widget) {
              ScreenUtil.setContext(context);
              return MediaQuery(
                  data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
                  child: widget!);
            },
            home: const SplashScreen(),
            routes: {
              '/navigation': (BuildContext context) => const HomeNavigationMenu(),
              '/onboarding': (BuildContext context) => const OnboardingPage(),
              '/home_dashboard': (BuildContext context) =>
                  const HomeDashboardPage(),
              '/promo': (BuildContext context) => const PromoPage(),
              '/reward': (BuildContext context) => const RewardPage(),
              '/account': (BuildContext context) => const AccountPage(),
              '/login': (BuildContext context) => const LoginPage(),
              '/register': (BuildContext context) => const RegisterPage(),
              '/verification': (BuildContext context) =>
                  const OtpVerification(),
              '/vouchers': (BuildContext context) => VoucherPage(),
              '/membership': (BuildContext context) => const membership(),
              '/editaccount': (BuildContext context) => AccountInformation(),
              // '/changepassword': (BuildContext context) =>
              //     const ChangePassword(havePassword:),
              '/detailpromo': (BuildContext context) => DetailPromo(),
              '/benefit': (BuildContext context) => const BenefitPage(),
              '/detail_outlet': (BuildContext context) => DetailOutletPage(),
              '/outlet_menu': (BuildContext context) => DetailOutletMenuPage(),
              '/outlet_telephone': (BuildContext context) =>
                  DetailOutletTelephonePage(),
              '/reservation': (BuildContext context) => const Reservation(),
              // '/reservation_detail': (BuildContext context) =>
              //     reservationDetail(),
              '/camera_preview': (BuildContext context) => PreviewCamera()
            },
          );
        });
  }
}
