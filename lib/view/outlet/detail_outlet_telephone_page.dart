
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fusia/color/colors_theme.dart';
import 'package:fusia/widget/custom_appbar.dart';
import 'package:fusia/widget/custom_appbar_account.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailOutletTelephonePage extends StatefulWidget {

  _DetailOutletTelephonePageState createState() => _DetailOutletTelephonePageState();
}

class _DetailOutletTelephonePageState extends State<DetailOutletTelephonePage> {

  TextEditingController displayTelephone = TextEditingController();

  var data = [];

  @override
  Widget build(BuildContext context) {

    Widget appbar() => CustomAppBar(title: "Telepon", isAccessDetail: true);

    Widget displayTelephoneForm() => TextFormField(
      controller: displayTelephone,
      enabled: false,
      style: TextStyle(fontFamily: 'Poppins',fontSize: 20.sp, color: ColorsTheme.black),
    );

    Widget nodeInput(number,isApplyNumber) => SizedBox(
      width: 68.96.w,
      height: 68.98.h,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18.r),
        child: ElevatedButton(
          child: (isApplyNumber) ? const Icon(Icons.call) : Text(number,style: TextStyle(fontFamily: 'Poppins',fontSize: 15.sp,color: ColorsTheme.black)),
          onPressed: () => (isApplyNumber) ? launch("tel://${data.toString()}") : addValue(number),
          style: ElevatedButton.styleFrom(
            shape: const CircleBorder(),
            padding: EdgeInsets.all(12.0.w),
            primary: (isApplyNumber) ? ColorsTheme.lightGreen : ColorsTheme.lightGrey3,
            onPrimary: ColorsTheme.brown,
          ),
        )
      ),
    );
    
    Widget spaced() => SizedBox(width: 25.w);
    Widget spacedRow() => SizedBox(height: 15.h);

    Widget formInput() => Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            nodeInput("1",false),
            spaced(),
            nodeInput("2",false),
            spaced(),
            nodeInput("3",false),
          ],
        ),
        spacedRow(),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            nodeInput("4",false),
            spaced(),
            nodeInput("5",false),
            spaced(),
            nodeInput("6",false),
          ],
        ),
        spacedRow(),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            nodeInput("7",false),
            spaced(),
            nodeInput("8",false),
            spaced(),
            nodeInput("9",false),
          ],
        ),
        spacedRow(),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            nodeInput("*",false),
            spaced(),
            nodeInput("0",false),
            spaced(),
            nodeInput("#",false),
          ],
        ),
        SizedBox(height: 15.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            nodeInput("X",true),
          ],
        ),
      ],
    );

    Widget body() => Padding(
      padding: EdgeInsets.fromLTRB(32.w, 50.h, 32.w, 0.h),
      child: Column(
        children: [
          displayTelephoneForm(),
          SizedBox(height: 49.h),
          formInput(),
        ],
      )
    );

    /*Widget numberInput() => FlatButton(
      onPressed: () => launch("tel://0881036014226"),
      child: Text("Call me"),
    );*/

    return AnnotatedRegion<SystemUiOverlayStyle>(
      child: SafeArea(
        child: Scaffold(
          body: body(),
          appBar: PreferredSize(
            child: appbar(),
            preferredSize: Size.fromHeight(78.h),
          )
        ),
      ),
      value: SystemUiOverlayStyle(statusBarColor: ColorsTheme.primary),
    );
  }

  addValue(number) {
    data.add(number);
    
    var convert1 = data.toString().replaceAll("[", ""); 
    var convert2 = convert1.toString().replaceAll("]", "");
    var convert3 = convert2.toString().replaceAll(",", "");
    displayTelephone.text = convert3;
  }
}