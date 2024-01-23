import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

showdialog(context) {
  Widget dialog() => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.r),
        ),
        insetPadding: EdgeInsets.all(110.w),
        child: SizedBox(
          width: 120.w,
          height: 120.h,
          child: FittedBox(
            fit: BoxFit.contain,
            child: Image.asset('assets/images/mascot.png'),
          ),
        ),
      );

  return showDialog(
    context: context,
    builder: (context) => dialog(),
  );
}

hidedialog(context) {
  Navigator.of(context).pop();
}
