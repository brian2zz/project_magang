// import 'package:coba_fusia/color/colors_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fusia/color/colors_theme.dart';
import 'package:fusia/controller/login_controller.dart';
import 'package:fusia/server/arguments_pass/temp_pass_otp.dart';
import 'package:fusia/widget/custom_progress_loading.dart';
import 'package:fusia/widget/custom_toast.dart';
import 'package:get/get.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  //server controller
  LoginController? loginController;

  //input controller
  TextEditingController? phoneInput;

  TextStyle style2 = TextStyle(
    fontFamily: 'Poppins',
    color: ColorsTheme.neutralGrey,
    fontSize: 12.sp,
    fontWeight: FontWeight.w400,
  );

  TextStyle style3(isHeader) => TextStyle(
    fontFamily: 'Poppins',
    color: ColorsTheme.neutralDark,
    fontSize: (isHeader) ? 16.sp : 12.sp,
    fontWeight: FontWeight.w700,
  );

  @override
  void initState() {
    super.initState();
    initConstructor();
  }

  initConstructor() {
    phoneInput = TextEditingController();
    loginController = Get.put(LoginController());
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    Widget mascot() => SizedBox(
          height: 99.h,
          child: Image.asset(
            'assets/images/mascot.png',
          ),
        );

    Widget header() => Container(
          margin: EdgeInsets.only(top: 2.h, bottom: 5.h),
          child: Text(
            "Fumily by Fusia",
            style: style3(true),
          ),
        );

    Widget labelPhone() => Container(
          alignment: Alignment.topLeft,
          margin: EdgeInsets.only(top: 10.h, bottom: 10.h),
          child: Text(
            "Sign in to continue",
            style: style2,
          ),
        );

    Widget formPhone() => TextFormField(
          controller: phoneInput,
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: ColorsTheme.neutralGrey!),
            ),
            prefixIcon: SizedBox(
              width: 24.w,
              height: 24.h,
              child: Image.asset('assets/icons/ic_phone.png'),
            ),
            hintText: "Phone Number",
            hintStyle: style2,
            labelStyle: style2,
            labelText: "Phone Number",
          ),
          style: style2,
          keyboardType: TextInputType.number,
        );

    return AnnotatedRegion<SystemUiOverlayStyle>(
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white,
          body: ListView(
            children: [
              Container(
                height: size.height * 0.9,
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    mascot(),
                    header(),
                    labelPhone(),
                    formPhone(),
                    SizedBox(
                      height: 6.h,
                    ),
                    _buildButton(context, phoneInput!, loginController!),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      value: SystemUiOverlayStyle(statusBarColor: ColorsTheme.white),
    );
  }
}

Widget _buildButton(BuildContext context, TextEditingController phoneInput,
    LoginController controller) {
  
  TextStyle alertStyle = TextStyle(
    fontFamily: 'Poppins',
    fontSize: 14.sp,
    fontWeight: FontWeight.w700,
    color: ColorsTheme.white,
  );

  requesttoLogin() async {
    showdialog(context);
    var result = await controller.requestLoginController(phoneInput.text);

    if (result['status'] == 200) {
      if (result['details']['status'] == "Success") {
        hidedialog(context);
        Navigator.of(context).pushNamed(
          '/verification',
          arguments: OTPArgumentsPassingData(phoneNumber: phoneInput.text),
        );
      } else if(result['details']['success'] == false) {
        hidedialog(context);
        var snackbar = SnackBar(
          content: Text(
                  "No. Telepon tidak terdaftar. Silahkan buat akun terlebih dahulu.",
                  style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500,
                      color: ColorsTheme.white,
                  ),
               ),
          backgroundColor: ColorsTheme.black,
          duration: const Duration(milliseconds: 1000),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackbar);
      } else {
        hidedialog(context);
        var snackbar = SnackBar(
          content: Text(
              "Gagal melakukan Login. Silahkan menghubungi Administrator untuk lebih lanjut.",
              style: alertStyle),
          backgroundColor: ColorsTheme.black,
          duration: const Duration(milliseconds: 1000),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackbar);
      }
    }
  }

  validatePhoneInput() async {
    if (phoneInput.text.isEmpty) {
      snackbar() => SnackBar(
            content: Text(
              "Silahkan masukkan no.hp terlebih dahulu",
              style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                  color: ColorsTheme.white,
               ),
            ),
            backgroundColor: ColorsTheme.black,
            duration: const Duration(milliseconds: 1000),
          );
      ScaffoldMessenger.of(context).showSnackBar(snackbar());
    } else {
      await requesttoLogin();
    }
  }

  Widget accountSignIn(title, status) => InkWell(
      onTap: () {
        var snackbar = SnackBar(
          content: Text(
            "Fitur dalam Tahap Pengembangan",
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 12.sp,
              fontWeight: FontWeight.w400,
              color: ColorsTheme.black,
            ),
          ),
          backgroundColor: ColorsTheme.lightYellow,
          behavior: SnackBarBehavior.fixed,
        );
        ScaffoldMessenger.of(context).showSnackBar(snackbar);
      },
      child: Container(
        decoration: ShapeDecoration(
            shape: RoundedRectangleBorder(
          side: BorderSide(color: ColorsTheme.neutralGrey!, width: 1.w),
          borderRadius: BorderRadius.circular(5.r),
        )),
        padding: EdgeInsets.all(16.w),
        child: Row(
          children: [
            SizedBox(
              width: 24.w,
              height: 24.h,
              child: Image.asset((status == "google")
                  ? 'assets/icons/ic_google.png'
                  : 'assets/icons/ic_facebook.png'),
            ),
            SizedBox(width: (status == "google") ? 65.w : 58.w),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: ColorsTheme.neutralGrey,
                fontSize: 14.sp,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ));

  Widget forgotPasswordButton() => GestureDetector(
        onTap: () {
          var snackbar = SnackBar(
            content: Text(
              "Fitur dalam Tahap Pengembangan",
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 12.sp,
                fontWeight: FontWeight.w400,
                color: ColorsTheme.black,
              ),
            ),
            backgroundColor: ColorsTheme.lightYellow,
            behavior: SnackBarBehavior.fixed,
          );
          ScaffoldMessenger.of(context).showSnackBar(snackbar);
        },
        child: Text(
          'Forgot Password?',
          style: TextStyle(
            color: ColorsTheme.secondary,
            fontSize: 12.sp,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w700,
          ),
        ),
      );

  Widget registerButton() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            "Don't have a account? ",
            style: TextStyle(
              color: ColorsTheme.neutralGrey,
              fontSize: 12.sp,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w400,
            ),
          ),
          GestureDetector(
            onTap: () => {Navigator.pushReplacementNamed(context, '/register')},
            child: Text(
              'Register',
              style: TextStyle(
                color: ColorsTheme.neutralDark,
                fontSize: 12.sp,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      );

  Widget customDivider() => Row(
        children: [
          buildDivider(),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w),
            child: Text(
              'OR',
              style: TextStyle(
                color: ColorsTheme.neutralGrey,
                fontSize: 14.sp,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          buildDivider(),
        ],
      );

  Widget buttonSubmission() => InkWell(
        onTap: () => validatePhoneInput(),
        splashColor: ColorsTheme.white,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 8.0.h),
          width: 400,
          height: 57,
          child: Center(
            child: Text(
              'Sign In',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 14.sp,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w700),
              textAlign: TextAlign.center,
            ),
          ),
          decoration: BoxDecoration(
            color: ColorsTheme.primary,
            borderRadius: BorderRadius.circular(6.0.r),
          ),
        ),
      );

  return Column(
    children: <Widget>[
      Padding(padding: EdgeInsets.only(top: 16.0.h)),
      buttonSubmission(),
      Padding(padding: EdgeInsets.only(top: 16.0.h)),
      customDivider(),
      Padding(padding: EdgeInsets.only(top: 16.0.h)),
      accountSignIn("Login with Google", "google"),
      Padding(padding: EdgeInsets.only(top: 5.0.h)),
      accountSignIn("Login with facebook", "facebook"),
      Padding(padding: EdgeInsets.only(top: 30.0.h)),
      forgotPasswordButton(),
      Padding(padding: EdgeInsets.only(top: 10.0.h)),
      registerButton(),
    ],
  );
}

Expanded buildDivider() {
  return Expanded(
      child: Divider(
    color: ColorsTheme.neutralGrey,
    height: 1.5.h,
  ));
}
