import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fusia/color/colors_theme.dart';
import 'package:fusia/widget/custom_appbar_account.dart';
import 'package:get/get.dart';

class ChangePassword extends StatelessWidget {
  const ChangePassword({Key? key, required this.havePassword})
      : super(key: key);
  final bool havePassword;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(title: 'Change Password',
      // press: () {
      //       Navigator.pushReplacementNamed(context, '/editaccount');
      //     }
          ),
      body: Container(
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          children: [
            if (havePassword == true) ...[
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 40.h),
                    Label(
                      text: 'Old Password',
                    ),
                    SizedBox(height: 10.h),
                    textField(),
                  ],
                ),
              ),
            ],
            SizedBox(height: 40.h),
            Label(
              text: 'new Password',
            ),
            SizedBox(height: 10.h),
            textField(),
            SizedBox(height: 40.h),
            Label(
              text: 'New Password Again',
            ),
            SizedBox(height: 10.h),
            textField(),
            SizedBox(height: 25.h),
            ClipRRect(
              borderRadius: BorderRadius.circular(5.r),
              child: FlatButton(
                padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 40.w),
                color: ColorsTheme.brown,
                onPressed: () {},
                child: Text(
                  'Save',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20.sp,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// class body extends StatelessWidget {
//   const body({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       child: ListView(
//         padding: EdgeInsets.symmetric(horizontal: 20.w),
//         children: [
//           SizedBox(height: 40.h),
//           Label(
//             text: 'Old Password',
//           ),
//           SizedBox(height: 10.h),
//           textField(),
//           SizedBox(height: 40.h),
//           Label(
//             text: 'New Password',
//           ),
//           SizedBox(height: 10.h),
//           textField(),
//           SizedBox(height: 40.h),
//           Label(
//             text: 'New Password Again',
//           ),
//           SizedBox(height: 10.h),
//           textField(),
//           SizedBox(height: 25.h),
//           ClipRRect(
//             borderRadius: BorderRadius.circular(5.r),
//             child: FlatButton(
//               padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 40.w),
//               color: ColorsTheme.brown,
//               onPressed: () {},
//               child: Text(
//                 'Save',
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontWeight: FontWeight.bold,
//                   fontSize: 20.sp,
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

class textField extends StatelessWidget {
  const textField({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      obscureText: true,
      decoration: InputDecoration(
        prefixIcon: Icon(
          Icons.lock_outlined,
          color: ColorsTheme.neutralGrey,
        ),
        border: new OutlineInputBorder(
            borderSide: new BorderSide(
          color: ColorsTheme.whiteCream!,
        )),
      ),
      style: TextStyle(
        color: ColorsTheme.neutralDark,
        fontWeight: FontWeight.bold,
        fontFamily: 'Poppins',
      ),
    );
  }
}

class Label extends StatelessWidget {
  final String text;
  const Label({
    Key? key,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        color: ColorsTheme.neutralDark,
        fontWeight: FontWeight.bold,
        fontFamily: 'Poppins',
      ),
    );
  }
}
