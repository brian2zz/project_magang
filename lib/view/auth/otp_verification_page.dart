// import 'package:coba_fusia/color/colors_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fusia/controller/login_controller.dart';
import 'package:fusia/server/arguments_pass/temp_pass_otp.dart';
import 'package:fusia/widget/custom_progress_loading.dart';
import 'package:get/get.dart';
import 'package:sms_autofill/sms_autofill.dart';

import '../../color/colors_theme.dart';

class OtpVerification extends StatefulWidget {
  const OtpVerification({Key? key}) : super(key: key);

  @override
  _OtpVerificationState createState() => _OtpVerificationState();
}

class _OtpVerificationState extends State<OtpVerification> {
  LoginController? controller;
  
  var kodeotp;

  TextStyle style1 = TextStyle(
      color: ColorsTheme.neutralDark,
      fontSize: 18.sp,
      fontFamily: 'Poppins',
      fontWeight: FontWeight.w400,
  );

  TextStyle style2 = TextStyle(
      color: ColorsTheme.black!.withOpacity(0.6),
      fontSize: 12.sp,
      fontFamily: 'Poppins',
      fontWeight: FontWeight.w400,
  );

  TextStyle style3 = TextStyle(
    color: ColorsTheme.black!.withOpacity(0.7),
    fontSize: 14.sp,
    fontFamily: 'Open Sans',
    fontWeight: FontWeight.w400,
  );

  TextStyle style4 = TextStyle(
    color: ColorsTheme.black!.withOpacity(0.6),
    fontSize: 14.sp,
    fontFamily: 'SF Pro Display',
    fontWeight: FontWeight.w300,
  );

  TextStyle style5 = TextStyle(
    color: ColorsTheme.primary,
    fontSize: 14.sp,
    fontFamily: 'Poppins',
    fontWeight: FontWeight.w600,
  );

  @override
  void initState() {
    super.initState();
    initConstructor();
  }

  initConstructor() {
    controller = Get.put(LoginController());
    kodeotp = "".obs;
  }

  resendOTP(_phone) async {
    //print(_phone);
    await controller!.reSendOTPController(_phone);
  }

  @override
  Widget build(BuildContext context) {
    final otpargs =
        ModalRoute.of(context)!.settings.arguments as OTPArgumentsPassingData;

    var convertoFormatNumber = otpargs.phoneNumber.replaceFirst("0", "+62 ");

    Widget section1() => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
          SizedBox(
            height: 50.h,
          ),
          Text("Verify your Phone Number",
              style: style1,
          ),
          SizedBox(
            height: 25.h,
          ),
          Text("We sent you a code to verify \n your phone number",
              style: style2,
          ),
          SizedBox(
            height: 25.h,
          ),
          Text("Sent to $convertoFormatNumber",
              style: style3,
          ),
          SizedBox(
            height: 50.h,
          ),
      ],
    );

    Widget section2() => Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text("I didn't get the code",
            style: style4,
        ),
        SizedBox(
          height: 35.h,
        ),
        InkWell(
          onTap: () => resendOTP(otpargs.phoneNumber),
          child: Text("Resend",
            style: style5,
          ),
        ),
        SizedBox(
          height: 35.h,
        ),
      ],
    );

    Widget body() => Container(
      margin: EdgeInsets.only(left: 10.w, right: 10.w),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            section1(),
            _buildPinText(context, otpargs.phoneNumber, controller!),
            SizedBox(
              height: 35.h,
            ),
            section2(),
          ],
        ),
      ),
    );

    return AnnotatedRegion<SystemUiOverlayStyle>(
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            leading: InkWell(
              onTap: () => Navigator.of(context).pop(),
              child: Icon(
                Icons.arrow_back,
                color: ColorsTheme.darkGrey,
              ),
            ),
          ),
          body: body(),
        ),
      ),
      value: SystemUiOverlayStyle(statusBarColor: ColorsTheme.primary),
    );
  }

  Widget body = Container();
}

verifyAccount1(phone, code,context,controller) async {
    showdialog(context);
    var result = await controller.verifyOTPController(phone, code);
    //showToast(context, result['details']);
    if (result['status'] == 200) {
      hidedialog(context);
      Navigator.of(context).pushNamed('/navigation');
    }
}

Widget _buildPinText(
    BuildContext context, String phoneNumber, LoginController controller) {
  verifyAccount(phone, code) async {
    showdialog(context);
    var result = await controller.verifyOTPController(phone, code);
    
    print(result['details']['code'].toString());

    if (result['details']['code'] == 1) {
      hidedialog(context);

      controller.storedUserLocalData("true",result['details']['databody']['token'], result['details']['databody']['cust_id'].toString());

      Navigator.of(context).pushNamed('/navigation');
    } else if(result['details']['code'] == 0) {
      hidedialog(context);

      var snackbar = SnackBar(
        content: Text(
          "Kode OTP yang anda masukkan salah. Pastikan kembali Kode OTP yang anda masukkan sudah benar.",
          style: TextStyle(
            color: ColorsTheme.white,
            fontSize: 12.sp,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w900,
          ),
        ),
        backgroundColor: ColorsTheme.lightRed,
      );

      ScaffoldMessenger.of(context).showSnackBar(snackbar);
    }
  }

  return Container(
    padding: EdgeInsets.symmetric(horizontal: 40.0.w, vertical: 10.0.h),
    child: PinFieldAutoFill(
      codeLength: 4,
      onCodeSubmitted: (val) => verifyAccount(phoneNumber, val),
    ),
  );
}
