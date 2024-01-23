import 'dart:convert';
// import 'package:progress_timeline/progress_timeline.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fusia/color/colors_theme.dart';
import 'package:fusia/controller/dashboard_controller.dart';
import 'package:fusia/controller/login_controller.dart';
import 'package:fusia/model/data_account_model.dart';
import 'package:fusia/widget/card_account_widget.dart';
import 'package:fusia/widget/custom_appbar_account.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

TextStyle benefitStyle = TextStyle(
  color: Color.fromARGB(255, 100, 100, 100),
  fontWeight: FontWeight.bold,
  fontFamily: 'Poppins',
);

class membership extends StatelessWidget {
  const membership({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(
        title: 'Membership',
        // press: () {
        //       Navigator.pushReplacementNamed(context, '/account');
        //     }
      ),
      body: body(),
    );
  }
}

class body extends StatefulWidget {
  const body({Key? key}) : super(key: key);

  @override
  _bodyState createState() => _bodyState();
}

class _bodyState extends State<body> {
  LoginController? userController;
  DashboardController? dashboardController;

  //global variable
  var namaUser;
  var membershipUser;

  void initState() {
    super.initState();
    initConstructor();
    initData();
  }

  initConstructor() {
    userController = Get.put(LoginController());
    dashboardController = Get.put(DashboardController());

    namaUser = "".obs;
    membershipUser = "".obs;
  }

  initData() async {
    await userController!.retrieveUserLocalData();

    setState(() {
      var token = LoginController.userToken.value;
      var customerId = LoginController.customerId.value;

      retrieveDashboard(token, customerId);
    });
  }

  retrieveDashboard(token, customerId) async {
    var result =
        await dashboardController!.retrieveDashboard(token, customerId);

    setState(() {
      if (result['status'] == 200) {
        DataAccountModel responsedata =
            DataAccountModel.fromJson(result['details']['databody']);

        namaUser.value = responsedata.custNama;
        membershipUser.value = responsedata.custMembership;
      }
    });
  }

  double value = 0;
  final List<String> titles = ['Bronze', 'Gold', 'Platinum', 'Vvip'];
  int _curStep = 0;

  Widget build(BuildContext context) {
    return Container(
      child: ListView(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        children: [
          StepProgressView(
              width: MediaQuery.of(context).size.width,
              curStep: _curStep,
              titles: titles),
          SizedBox(height: 30.h),
          Container(
            // margin: EdgeInsets.only(top: 10.h),
            child: BuildCardMember(
              point: value,
              name: namaUser.value,
            ),
          ),
          _indicatorPoint(),
          _progressMembership(),
          SizedBox(height: 60.h),
          Benefit(),
        ],
      ),
    );
  }

  Widget Benefit() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Benefits',
          style: TextStyle(
            color: ColorsTheme.black,
            fontWeight: FontWeight.bold,
            fontFamily: 'Poppins',
          ),
        ),
        SizedBox(height: 20.h),
        (value >= 0 && value <= 125)
            ? BuildBenefit(
                text1:
                    'Spent IDR 3,000,000 - IDR 6,000,000 for the last 3 months',
                text2:
                    'Additional Benefit : Every 10,000 purchase will be gained 2 points',
                text3:
                    'For Catering Service, every IDR 100,000 purchase will be gained 4 points',
                text4: '')
            : (value >= 125 && value <= 250)
                ? BuildBenefit(
                    text1:
                        'Spent IDR 6,000,000 - IDR 15,000,000 for the last 3 months',
                    text2:
                        'Additional Benefit : Every 10,000 purchase will be gained 3 points',
                    text3:
                        'For Catering Service, every IDR 100,000 purchase will be gained 5 points',
                    text4: '')
                : (value > 250 && value <= 375)
                    ? BuildBenefit(
                        text1:
                            'Spent IDR 6,000,000 - IDR 15,000,000 for the last 3 months',
                        text2:
                            'Additional Benefit : Every 10,000 purchase will be gained 3 points',
                        text3:
                            'For Catering Service, every IDR 100,000 purchase will be gained 5 points',
                        text4: '')
                    : BuildBenefit(
                        text1:
                            'Spent over IDR 15,000,000 for the last 3 months',
                        text2:
                            'Additional Benefit : Every 10,000 purchase will be gained 4 points',
                        text3: 'Gain 5 points per every visit',
                        text4:
                            'For Catering Service, every IDR 100,000 purchase will be gained 6 points')
      ],
    );
  }

  Widget _progressMembership() {
    return Column(
      children: [
        Slider(
          value: value,
          min: 0,
          max: 500,
          activeColor: ColorsTheme.lightDark,
          inactiveColor: ColorsTheme.whiteCream,
          thumbColor: ColorsTheme.lightDark,
          onChanged: (value) => setState(
            () {
              this.value = value;
              (value >= 0 && value <= 125)
                  ? _curStep = 1
                  : (value >= 125 && value <= 250)
                      ? _curStep = 2
                      : (value >= 250 && value <= 375)
                          ? _curStep = 3
                          : _curStep = 4;
            },
          ),
        ),
        ListTile(
          leading: Text(
              (value >= 0 && value <= 125)
                  ? "bronze"
                  : (value >= 125 && value <= 250)
                      ? "Gold"
                      : "Platinum",
              style: TextStyle(
                color: ColorsTheme.black,
                fontWeight: FontWeight.bold,
                fontFamily: 'Poppins',
              )),
          trailing: Text(
              (value >= 0 && value <= 125)
                  ? "Gold"
                  : (value >= 125 && value <= 250)
                      ? "Platinum"
                      : "Vvip",
              style: TextStyle(
                color: ColorsTheme.black,
                fontWeight: FontWeight.bold,
                fontFamily: 'Poppins',
              )),
        ),
        Center(
          child: Text(
              (value >= 0 && value <= 125)
                  ? 'Earn 125 points more to reach GOLD tier'
                  : (value >= 125 && value <= 250)
                      ? 'Earn 125 points more to reach Platinum tier'
                      : 'Earn 125 points more to reach Vvip tier',
              style: TextStyle(
                color: ColorsTheme.lightGrey,
                fontWeight: FontWeight.bold,
                fontFamily: 'Poppins',
              )),
        ),
      ],
    );
  }

  Widget _indicatorPoint() {
    return ListTile(
      leading: Text('Your Point',
          style: TextStyle(
            color: ColorsTheme.black,
            fontWeight: FontWeight.bold,
            fontFamily: 'Poppins',
          )),
      trailing: Text('${(value).toStringAsFixed(0)}',
          style: TextStyle(
            color: ColorsTheme.black,
            fontWeight: FontWeight.bold,
            fontFamily: 'Poppins',
          )),
    );
  }
}

class BuildBenefit extends StatelessWidget {
  final String text1;
  final String text2;
  final String text3;
  final String text4;
  const BuildBenefit({
    Key? key,
    required this.text1,
    required this.text2,
    required this.text3,
    required this.text4,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(text1, style: benefitStyle),
        SizedBox(height: 20.h),
        Text(text2, style: benefitStyle),
        SizedBox(height: 20.h),
        Text(text3, style: benefitStyle),
        SizedBox(height: 20.h),
        Text(text4, style: benefitStyle),
      ],
    );
  }
}

class StepProgressView extends StatelessWidget {
  final double width;

  final List<String> titles;
  final int curStep;
  final Color _activeColor = Color(0xff502423);
  final Color _inactiveColor = Color.fromARGB(255, 230, 238, 243);
  final double lineWidth = 3.0;

  StepProgressView({
    Key? key,
    required this.curStep,
    required this.titles,
    required this.width,
  }) : super(key: key);

  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(top: 20.h),
        width: this.width,
        child: Column(
          children: <Widget>[
            Row(
              children: _iconViews(),
            ),
            SizedBox(
              height: 8.h,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: _titleViews(),
            ),
          ],
        ));
  }

  List<Widget> _iconViews() {
    var list = <Widget>[];
    titles.asMap().forEach((i, icon) {
      var circleColor = (i == 0 || curStep > i) ? _activeColor : _inactiveColor;
      var lineColor = curStep > i + 1 ? _activeColor : _inactiveColor;
      var iconColor = (i == 0 || curStep > i) ? _activeColor : _inactiveColor;

      list.add(
        Container(
          width: 20.h,
          height: 20.w,
          padding: EdgeInsets.all(0),
          decoration: new BoxDecoration(
            /* color: circleColor,*/
            borderRadius: new BorderRadius.all(new Radius.circular(22.0)),
            border: new Border.all(
              color: circleColor,
              width: 2.w,
            ),
          ),
          child: Icon(
            Icons.circle,
            color: iconColor,
            size: 12.sp,
          ),
        ),
      );

      //line between icons
      if (i != titles.length - 1) {
        list.add(Expanded(
            child: Container(
          height: lineWidth,
          color: lineColor,
        )));
      }
    });

    return list;
  }

  List<Widget> _titleViews() {
    var list = <Widget>[];
    titles.asMap().forEach((i, text) {
      list.add(Text(text, style: TextStyle(color: Colors.black)));
    });
    return list;
  }
}
