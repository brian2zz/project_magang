// import 'package:coba_fusia/color/colors_theme.dart';
import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fusia/controller/login_controller.dart';
import 'package:fusia/server/arguments_pass/temp_pass_otp.dart';
import 'package:fusia/widget/custom_progress_loading.dart';
import 'package:intl/intl.dart';

import '../../color/colors_theme.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();

  DateFormat dateFormat = DateFormat('yyyyMMdd');
  DateFormat displayDateFormat = DateFormat('dd-MMM-yyyy');
  var now = DateTime.now();

  LoginController controller = new LoginController();

  var serverdatebirth = "";

  TextStyle alertStyle = TextStyle(
    fontFamily: 'Poppins',
    fontSize: 12.sp,
    fontWeight: FontWeight.w400,
    color: ColorsTheme.white,
  );

  TextStyle contentLabelTextStyle = TextStyle(
    color: ColorsTheme.neutralDark,
    fontSize: 15.sp,
    fontFamily: 'Poppins',
    fontWeight: FontWeight.w900,
  );

  TextStyle contentLabelTextStyle2 = TextStyle(
    color: ColorsTheme.neutralGrey,
    fontSize: 12.sp,
    fontFamily: 'Poppins',
    fontWeight: FontWeight.w900,
  );

  TextStyle contentButtonLabelTextStyle = TextStyle(
      color: Colors.white,
      fontSize: 14.sp,
      fontFamily: 'Poppins',
      fontWeight: FontWeight.w900
  );

  @override
  Widget build(BuildContext context) {
    
    Widget logo() => SizedBox(
      height: 99.h,
      child: Image.asset(
        'assets/images/mascot.png',
      ),
    );

    Widget title() => Container(
      margin: EdgeInsets.only(top: 2.h, bottom: 5.h),
      child: Text(
        "Fumily by Fusia",
        style: contentLabelTextStyle,
      ),
    );

    Widget labelStarted() => Column(
      children: [
        Container(
          alignment: Alignment.topLeft,
          margin: EdgeInsets.only(top: 10.h, bottom: 1.h),
          child: Text(
            "Let's Get Started",
            style: contentLabelTextStyle,
          ),
        ),
        Container(
          alignment: Alignment.topLeft,
          margin: EdgeInsets.only(top: 10.h, bottom: 10.h),
          child: Text(
            "Create an new Account",
            style: contentLabelTextStyle2,
          ),
        ),
      ],
    );

    Widget birthdayInputField() => TextFormField(
      controller: _startDateController,
      onTap: () => showDatePicker1(context),
      keyboardType: TextInputType.none,
      decoration: InputDecoration(
          border: const OutlineInputBorder(),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: ColorsTheme.neutralGrey!),
          ),
          hintText: "Birthday",
          suffixIcon: SizedBox(
            width: 24.w,
            height: 24.h,
            child: Image.asset('assets/icons/ic_date.png'),
          ), 
          hintStyle: contentLabelTextStyle,
          labelStyle: contentLabelTextStyle,
          labelText: "Birthday"
        ),
        style: contentLabelTextStyle,
    );

    Widget generalInputField(statusField) => TextFormField(
      controller: (statusField == "fullname") ? _fullNameController : (statusField == "email") ? _emailController : _phoneNumberController,
      decoration: InputDecoration(
          border: const OutlineInputBorder(),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: ColorsTheme.neutralGrey!),
          ),
          prefixIcon: SizedBox(
            width: 24.w,
            height: 24.h,
            child: Image.asset(
              (statusField == "fullname") ? 
                'assets/icons/ic_fullname.png' : 
              (statusField == "email") ? 
                'assets/icons/ic_email.png' :
                'assets/icons/ic_phone.png'
            ),
          ),
          /*Icon(
            Icons.person,
            size: 30.w,
          ),*/
          hintText: (statusField == "fullname") ? "Full Name" : (statusField == "email") ? "Your Email" : "Phone Number",
          hintStyle: contentLabelTextStyle,
          //labelStyle: contentLabelTextStyle,
      ),
      style: contentLabelTextStyle,
      keyboardType: (statusField == "fullname") ? TextInputType.text : (statusField == "email") ? TextInputType.emailAddress : TextInputType.number,
      textInputAction: (statusField == "fullname" || statusField == "email") ? TextInputAction.next : TextInputAction.done,
    );

    Widget _buildButton() => Column(
      children: <Widget>[
        SizedBox(height: 16.h),
        InkWell(
          onTap: () => validateForm(),
          splashColor: ColorsTheme.white,
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 8.0.h),
            width: 400.w,
            height: 57.h,
            child: Center(
              child: Text(
                'Sign Up',
                style: contentButtonLabelTextStyle,
                textAlign: TextAlign.center,
              ),
            ),
            decoration: BoxDecoration(
              color: ColorsTheme.primary,
              borderRadius: BorderRadius.circular(6.0),
            ),
          ),
          
        ),
        SizedBox(height: 25.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "Have a account? ",
              style: contentLabelTextStyle2,
            ),
            GestureDetector(
              onTap: () => {Navigator.pushReplacementNamed(context, '/login')},
              child: Text(
                'Sign In',
                style: contentLabelTextStyle2,
              ),
            ),
          ],
        ),
      ],
    );

    Widget body() => SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 30.w,vertical: 10.h),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            logo(),
            title(),
            labelStarted(),
            SizedBox(
              height: 20.h,
            ),
            generalInputField("fullname"),
            SizedBox(
              height: 20.h,
            ),
            generalInputField("email"),
            SizedBox(
              height: 20.h,
            ),
            birthdayInputField(),
            SizedBox(
              height: 20.h,
            ),
            generalInputField(""),
            SizedBox(
              height: 6.h,
            ),
            _buildButton(),
          ],
        ),
      ),
    );

    return AnnotatedRegion<SystemUiOverlayStyle>(
      child: SafeArea(
        child: Scaffold(
          backgroundColor: ColorsTheme.white,
          body: body(), 
        ),
      ),
      value: SystemUiOverlayStyle(statusBarColor: ColorsTheme.white),
    );
  }

  validateForm() {
    if(_fullNameController.text.isEmpty) {
      alertSnacbar("Nama Lengkap tidak boleh Kosong.",ColorsTheme.black);
    } else if(_emailController.text.isEmpty) {
      alertSnacbar("Email tidak boleh Kosong.", ColorsTheme.black);
    } else if(!_emailController.text.contains("@")) {
      alertSnacbar("Pastikan Email yang anda masukkan sudah sesuai dengan format email.", ColorsTheme.black);
    } else if(_startDateController.text.isEmpty) {
      alertSnacbar("Tanggal Lahir tidak boleh Kosong.", ColorsTheme.black);
    } else if(_phoneNumberController.text.isEmpty) {
      alertSnacbar("No.Telp tidak boleh Kosong.", ColorsTheme.black); 
    } else {
      setState(() {
        registerAccount();
      });
    }
  }

  registerAccount() async {
      showdialog(context);

      Map<String,dynamic> paramsdata = {
        "fullname": _fullNameController.text,
        "email": _emailController.text,
        "datebirth": serverdatebirth,
        "phone": _phoneNumberController.text,
      };
      
      var result = await controller.registerAccountController(paramsdata);

      if(result['details']['code'] == 200) {
        setState(() {
          hidedialog(context);

          Navigator.of(context).pushNamed(
            '/verification',
            arguments: OTPArgumentsPassingData(phoneNumber: _phoneNumberController.text),
          );
        });
      } else if (result['details']['code'] == 400) {
        hidedialog(context);
        alertSnacbar(result['details']['status'], ColorsTheme.lightRed);
      } else {
        hidedialog(context);
        alertSnacbar(result['details'], ColorsTheme.lightRed);
      }
  }

  alertSnacbar(alertText,color) async {
    var snackbar = SnackBar(
        content: Text(alertText,style: alertStyle),
        backgroundColor: color,
        duration: const Duration(milliseconds: 1000),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackbar);
  }

  Future showDatePicker1(context) async {
    final DateTime? date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2025),
    );

    if(date != null) {
      setState(() {
        DateFormat format = DateFormat("dd-MM-yyyy");
        DateFormat serverFormat = DateFormat("yyyy-MM-dd");

        _startDateController.text = format.format(date);
        serverdatebirth = serverFormat.format(date);
      });
    }                    
  }

}

Expanded buildDivider() {
  return Expanded(
      child: Divider(
    color: ColorsTheme.neutralGrey,
    height: 1.5,
  ));
}
