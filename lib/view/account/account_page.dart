import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fusia/color/colors_theme.dart';
import 'package:fusia/controller/dashboard_controller.dart';
import 'package:fusia/controller/login_controller.dart';
import 'package:fusia/model/data_account_model.dart';
import 'package:fusia/model/foto_model.dart';
import 'package:fusia/server/server_base.dart';
import 'package:fusia/widget/card_account_widget.dart';
import 'package:fusia/widget/custom_appbar.dart';
import 'package:fusia/widget/custom_toast.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({Key? key}) : super(key: key);

  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  //controller
  LoginController? userController;
  DashboardController? dashboardController;

  Future? _loadData;

  //global variable
  var namaUser;
  var membershipUser;
  var pointUser;
  var token, customerId;
  var photoUrlUser;
  var photoId;

  TextStyle headerStyle = TextStyle(
    fontFamily: 'Poppins',
    fontSize: 15.sp,
    fontWeight: FontWeight.w700,
    color: ColorsTheme.white,
  );

  TextStyle contentStyle1 = TextStyle(
    fontFamily: 'Poppins',
    fontSize: 14.sp,
    fontWeight: FontWeight.w400,
    color: ColorsTheme.black,
  );

  TextStyle contentStyleAlert(isNoOption) => TextStyle(
        fontFamily: 'Poppins',
        fontSize: 14.sp,
        fontWeight: FontWeight.w400,
        color: (isNoOption) ? ColorsTheme.lightRed : ColorsTheme.lightGreen,
      );

  TextStyle contentStyle2 = TextStyle(
    fontFamily: 'Poppins',
    fontSize: 12.sp,
    fontWeight: FontWeight.w500,
    color: ColorsTheme.black,
  );

  TextStyle alertErrorTextStyle = TextStyle(
    fontFamily: 'Poppins',
    fontSize: 12.sp,
    fontWeight: FontWeight.w400,
    color: ColorsTheme.white,
  );

  TextStyle membershipStatusTextStyleMenu = TextStyle(
    fontFamily: 'Poppins',
    fontSize: 10.sp,
    fontWeight: FontWeight.w500,
    color: ColorsTheme.darkGrey,
  );

  @override
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
    token = "";
    customerId = "";
    pointUser = "".obs;
    photoUrlUser = "".obs;
    photoId = "".obs;
  }

  initData() async {
    await userController!.retrieveUserLocalData();

    setState(() {
      token = LoginController.userToken.value;
      customerId = LoginController.customerId.value;

      _loadData = retrieveDashboard(token, customerId);
    });
  }

  retrieveDashboard(token, customerId) async {
    var result =
        await dashboardController!.retrieveDashboard(token, customerId);

    setState(() {
      if (result['status'] == 200) {
        DataAccountModel responsedata =
            DataAccountModel.fromJson(result['details']['databody']);
        Foto responsefoto =
            Foto.fromJson(result['details']['databody']['foto']);

        namaUser.value = responsedata.custNama;
        membershipUser.value = responsedata.custMembership;
        pointUser.value = responsedata.custPrewardTotal;
        photoUrlUser.value = responsefoto.fotoUrl;
        photoId.value = responsefoto.fotoId;
        // print(photoUrlUser.value);
      }
    });
  }

  Future refreshItem() async {
    setState(() {
      _loadData = retrieveDashboard(token, customerId);
    });
  }

  @override
  Widget build(BuildContext context) {
    void awaitUpdateAccount(BuildContext context) async {
      final result = await Navigator.pushNamed(context, '/editaccount');
      setState(() {
        _loadData = retrieveDashboard(token, customerId);
      });
    }

    Widget itemMenuList(context, status, isMembership) => SizedBox(
          height: 60.h,
          child: InkWell(
            onTap: () {
              if (status == "account") {
                awaitUpdateAccount(context);
              } else if (status == "membership") {
                Navigator.pushNamed(context, '/membership');
              } else if (status == "benefit") {
                Navigator.pushNamed(context, '/benefit');
              } else if (status == "exit") {
                setState(() {
                  alertExitDialog();
                });
              } else {
                showToast(context, "Fitur masih dalam tahap pengembangan");
              }
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Image.asset(
                      (status == "account")
                          ? 'assets/icons/ic_menu_account.png'
                          : (status == "membership")
                              ? 'assets/icons/ic_menu_reward.png'
                              : (status == "benefit")
                                  ? 'assets/icons/ic_menu_promo.png'
                                  : 'assets/icons/ic_keluar.png',
                      color: ColorsTheme.neutralDark,
                    ),
                    SizedBox(
                      width: 15.h,
                    ),
                    Text(
                      (status == "account")
                          ? "Account Information"
                          : (status == "membership")
                              ? "Membership"
                              : (status == "benefit")
                                  ? "Benefit"
                                  : "Exit",
                      style: TextStyle(
                          color: ColorsTheme.neutralDark,
                          fontSize: 14.sp,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w900),
                    ),
                  ],
                ),
                Row(
                  children: [
                    (isMembership)
                        ? Row(children: [
                            Obx(() => Text(
                                  membershipUser.value,
                                  style: membershipStatusTextStyleMenu,
                                )),
                            SizedBox(width: 6.w),
                          ])
                        : Container(),
                    SizedBox(
                      width: 20.w,
                      child: Icon(
                        Icons.arrow_forward_ios,
                        color: ColorsTheme.neutralGrey,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        );

    Widget _buildMenu(context) => Container(
          margin: EdgeInsets.only(left: 10.w, right: 10.w),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                itemMenuList(context, "account", false),
                itemMenuList(context, "membership", true),
                itemMenuList(context, "benefit", false),
                itemMenuList(context, "exit", false),
              ]),
        );

    Widget _buildCard() => Obx(() => BuildCardMember(
        name: (namaUser.value.isEmpty) ? "Guest User" : namaUser.value,
        point: double.parse(pointUser.value)));

    Widget _avatarProfile(isLoading) {
      Widget loadingUserAccount(_width) => Shimmer.fromColors(
            child: Container(
              width: _width,
              height: 22.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4.r),
                color: ColorsTheme.black,
              ),
            ),
            baseColor: ColorsTheme.lightBrown!,
            highlightColor: ColorsTheme.darkerBrown!,
          );

      Widget loadingAvatar() => Shimmer.fromColors(
            child:
                CircleAvatar(backgroundColor: ColorsTheme.black, radius: 30.r),
            baseColor: ColorsTheme.lightBrown!,
            highlightColor: ColorsTheme.darkerBrown!,
          );

      Widget emptyImage() => Container(
            width: 55.w,
            height: 55.h,
            decoration: ShapeDecoration(
              shape: CircleBorder(
                  side: BorderSide(color: ColorsTheme.primary!, width: 5.w)),
            ),
            child: FittedBox(
              fit: BoxFit.cover,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(30.r),
                child: CircleAvatar(
                  radius: 30.r,
                  backgroundColor: ColorsTheme.primary,
                  child: Image.asset("assets/images/mascot_siluet.jpg"),
                ),
              ),
            ),
          );

      return Container(
        margin: EdgeInsets.fromLTRB(0.w, 10.0.h, 0.w, 20.0.h),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  (isLoading)
                      ? loadingAvatar()
                      : CachedNetworkImage(
                          imageUrl:
                              "${ServerBase.serverUrl}/${photoUrlUser.value}",
                          imageBuilder: (context, imageProvider) => ClipRRect(
                            borderRadius: BorderRadius.circular(30.r),
                            child: CircleAvatar(
                              radius: 30.r,
                              backgroundImage: imageProvider,
                            ),
                          ),
                          placeholder: (context, url) => loadingAvatar(),
                          errorWidget: (context, url, error) => emptyImage(),
                        ),
                  Padding(
                    padding: EdgeInsets.only(
                      left: 10.0.h,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        (isLoading)
                            ? loadingUserAccount(100.w)
                            : Obx(() => Text(
                                  (namaUser.value.isEmpty)
                                      ? "Guest User"
                                      : namaUser.value,
                                  style: TextStyle(
                                      color: ColorsTheme.neutralDark,
                                      fontSize: 14.sp,
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w900),
                                )),
                        (isLoading) ? SizedBox(height: 5.h) : Container(),
                        (isLoading)
                            ? loadingUserAccount(80.w)
                            : Obx(() => Text(
                                  "${pointUser.value} points",
                                  style: TextStyle(
                                      color: ColorsTheme.neutralGrey,
                                      fontSize: 12.sp,
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w900),
                                )),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    }

    Widget contentbody(context, isLoading) => Expanded(
          child: RefreshIndicator(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(20.0.w),
                child: Column(
                  children: <Widget>[
                    SizedBox(height: 5.h),
                    _avatarProfile(isLoading),
                    SizedBox(height: 5.h),
                    (isLoading)
                        ? Shimmer.fromColors(
                            child: Container(
                              height: 194.h,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8.r),
                                color: ColorsTheme.white,
                              ),
                            ),
                            baseColor: ColorsTheme.lightBrown!,
                            highlightColor: ColorsTheme.darkerBrown!,
                          )
                        : _buildCard(),
                    SizedBox(height: 40.h),
                    Container(
                      height: 10,
                      decoration: BoxDecoration(color: ColorsTheme.lightGrey2),
                    ),
                    SizedBox(height: 20.h),
                    _buildMenu(context),
                  ],
                ),
              ),
            ),
            onRefresh: refreshItem,
          ),
        );

    Widget body(context) => Column(
          children: [
            CustomAppBar(title: "Account", secondtitle: "", isAccessDetail: false, isNeedTwoLines: false),
            FutureBuilder(
                future: _loadData,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.hasData) {
                      SchedulerBinding.instance!.addPostFrameCallback((_) {
                        var snackbar = SnackBar(
                          content: Text(
                              "Data user gagal terupload. Pastikan jaringan internet dalam kondisi baik.",
                              style: alertErrorTextStyle),
                          backgroundColor: ColorsTheme.lightRed,
                          behavior: SnackBarBehavior.floating,
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackbar);
                      });

                      return contentbody(context, false);
                    } else {
                      return contentbody(context, false);
                    }
                  } else {
                    return contentbody(context, true);
                  }
                }),
          ],
        );

    return AnnotatedRegion<SystemUiOverlayStyle>(
      child: SafeArea(
        child: Scaffold(
          body: body(context),
        ),
      ),
      value: SystemUiOverlayStyle(statusBarColor: ColorsTheme.primary),
    );
  }

  alertExitDialog() async {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => Center(
        child: Container(
          width: 280.w,
          height: 120.h,
          decoration: BoxDecoration(
            color: ColorsTheme.white,
          ),
          child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Text("Apakah anda yakin untuk keluar?",
                        style: contentStyle1),
                    SizedBox(height: 55.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Text("Tidak", style: contentStyleAlert(true)),
                        ),
                        SizedBox(width: 12.w),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              Navigator.pop(context);
                              userController!.clearData();
                              Navigator.pushReplacementNamed(context, '/login');
                            });
                          },
                          child: Text("Ya", style: contentStyleAlert(false)),
                        )
                      ],
                    ),
                  ])),
        ),
      ),
    );
  }
}
