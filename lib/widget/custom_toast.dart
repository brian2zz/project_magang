import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fusia/color/colors_theme.dart';

FToast? toast;

showToast(context, message) {
  toast = FToast();
  toast!.init(context);

  Widget _toast() => Container(
        padding: EdgeInsets.all(6.w),
        child: Text(
          message,
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 12.sp,
            fontWeight: FontWeight.w500,
            color: ColorsTheme.white,
          ),
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.r),
          color: ColorsTheme.black!,
        ),
      );

  toast!.showToast(
    child: _toast(),
    gravity: ToastGravity.BOTTOM,
    toastDuration: const Duration(seconds: 2),
  );
}
