import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fusia/color/colors_theme.dart';

class appBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  // final VoidCallback press;
  const appBar({
    required this.title,
    // required this.press,
    Key? key,
  }) : super(key: key);
  @override
  Size get preferredSize => Size.fromHeight(65.h);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Colors.white,
      title: Padding(
        padding: EdgeInsets.only(top: 22.h),
        child: Text(
          title,
          style: TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.bold,
              fontSize: 16.sp,
              color: ColorsTheme.neutralDark),
        ),
      ),
      elevation: 0.0,
      bottomOpacity: 0.0,
      titleSpacing: -10.w,
      leadingWidth: 63.w,
      leading: Builder(
        builder: (context) => Container(
          padding: EdgeInsets.only(top: 20.h),
          child: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: Color.fromARGB(255, 144, 152, 177),
              size: 18.h,
            ),
            onPressed: () => Navigator.pop(context),
          ),
        ),
      ),
    );
  }
}
