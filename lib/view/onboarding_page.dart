// import 'package:coba_fusia/color/colors_theme.dart';
// import 'package:coba_fusia/widget/custom_toast.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fusia/color/colors_theme.dart';
import 'package:fusia/widget/custom_toast.dart';
import 'package:page_view_indicators/circle_page_indicator.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({Key? key}) : super(key: key);

  @override
  _OnboardingPageState createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  List<String>? imageList = [
    'assets/images/logo_onboarding_1.png',
    'assets/images/logo_onboarding_2.png',
    'assets/images/logo_onboarding_3.png',
  ];

  final _currentPageNotifier = ValueNotifier<int>(0);
  final PageController scrollcontroller =
      PageController(keepPage: true, initialPage: 0);

  TextStyle style1 = TextStyle(
    fontFamily: 'Poppins',
    color: ColorsTheme.white,
    fontSize: ScreenUtil().setSp(15),
    fontWeight: FontWeight.w500,
  );

  TextStyle style2 = TextStyle(
    fontFamily: 'Poppins',
    color: ColorsTheme.primary,
    fontSize: ScreenUtil().setSp(15),
    fontWeight: FontWeight.w500,
  );

  var count = 0;

  @override
  void initState() {
    super.initState();
  }

  scrollboard(value) {
    setState(() {
      _currentPageNotifier.value = value;
      count = value;
      scrollcontroller.animateToPage(value,
          duration: const Duration(microseconds: 1), curve: Curves.linear);
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget buttonMovetoPage() => Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(23.r),
          ),
          color: ColorsTheme.primary,
          child: InkWell(
            onTap: () {
              setState(() {
                count += 1;
                if (count >= 3) {
                  login();
                } else {
                  scrollboard(count);
                }
              });
            },
            borderRadius: BorderRadius.circular(23.r),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(62), vertical: ScreenUtil().setHeight(12)),
              child: Text(
                "Next",
                style: style1,
              ),
            ),
          ),
        );

    // Widget buttonLogin() => TextButton();

    Widget buttonSkip() => TextButton(
          onPressed: () => Navigator.pushReplacementNamed(context, '/login'),
          child: Text(
            "Skip",
            style: style2,
          ),
        );

    Widget bodyContent() => PageView.builder(
          controller: scrollcontroller,
          itemCount: imageList!.length,
          onPageChanged: (value) => scrollboard(value),
          itemBuilder: (context, index) {
            return Image.asset(imageList![index]);
          },
        );

    return AnnotatedRegion<SystemUiOverlayStyle>(
      child: SafeArea(
        child: Scaffold(
          body: Stack(
            children: [
              bodyContent(),
              Positioned(
                child: CirclePageIndicator(
                  itemCount: 3,
                  currentPageNotifier: _currentPageNotifier,
                  selectedDotColor: ColorsTheme.primary,
                  dotColor: Colors.grey,
                ),
                top: ScreenUtil().setHeight(410),
                left: ScreenUtil().setWidth(100),
                right: ScreenUtil().setWidth(100),
              ),
              Positioned(
                child: buttonMovetoPage(),
                bottom: ScreenUtil().setHeight(42),
                right: ScreenUtil().setWidth(20),
              ),
              Positioned(
                child: buttonSkip(),
                bottom: ScreenUtil().setHeight(42),
                left: ScreenUtil().setWidth(20),
              ),
            ],
          ),
        ),
      ),
      value: SystemUiOverlayStyle(statusBarColor: ColorsTheme.white),
    );
  }

  void login() async {
    Navigator.pushReplacementNamed(context, '/login');
  }
}
