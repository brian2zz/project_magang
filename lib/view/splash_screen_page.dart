import 'dart:async';

// import 'package:coba_fusia/color/colors_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fusia/color/colors_theme.dart';
import 'package:fusia/controller/login_controller.dart';
import 'package:get/get.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  
  //controller
  LoginController? controller;
  
  //global variable  
  var isLogin;

  @override
  void initState() {
    super.initState();
    initConstructor();
    initData();
    //startTime();
  }

  initConstructor() {
    controller = Get.put(LoginController());

    isLogin = "false".obs;
  }

  initData() async {
    await controller!.retrieveUserIsLogin();
    
    if(LoginController.isLogin.value != "") {
      isLogin.value = LoginController.isLogin.value;
    } else {
      isLogin.value = "false";
    }

    startTime();
  }

  startTime() async {
    Duration timers = const Duration(seconds: 4);
    return Timer(timers, () => navigationPage());
  }

  navigationPage() async {
    if (isLogin.value == "false") {
      setState(() {
        Navigator.pushReplacementNamed(context, '/onboarding');
      });
    } else {
      setState(() {
        Navigator.pushReplacementNamed(context, '/navigation');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      child: SafeArea(
        child: Scaffold(
          body: Center(
            child: Image.asset('assets/images/logo_fusia.png'),
          ),
          backgroundColor: ColorsTheme.primary!,
        ),
      ),
      value: SystemUiOverlayStyle(statusBarColor: ColorsTheme.primary!),
    );
  }
}
