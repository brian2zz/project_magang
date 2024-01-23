import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fusia/color/colors_theme.dart';
import 'package:fusia/controller/login_controller.dart';
import 'package:fusia/controller/promo_controller.dart';
import 'package:fusia/model/promo_model.dart';
import 'package:fusia/widget/custom_appbar.dart';
import 'package:fusia/widget/product_widget.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

class PromoPage extends StatefulWidget {
  const PromoPage({Key? key}) : super(key: key);

  @override
  _PromoPageState createState() => _PromoPageState();
}

class _PromoPageState extends State<PromoPage> {
  PromoController? promoController;
  LoginController? loginController;

  RxString? token;
  Future? loadData;

  List<Promo>? PromoList;

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

  TextStyle contentStyle2 = TextStyle(
    fontFamily: 'Poppins',
    fontSize: 12.sp,
    fontWeight: FontWeight.w500,
    color: ColorsTheme.black,
  );

  @override
  void initState() {
    super.initState();

    initConstructor();
    initData();
  }

  initConstructor() {
    promoController = Get.put(PromoController());
    loginController = Get.put(LoginController());

    token = "".obs;
  }

  initData() async {
    await loginController!.retrieveUserLocalData();
    setState(() {
      token = LoginController.userToken;
      loadData = _loadData(token);
    });
  }

  _loadData(token) async {
    var result = await promoController!.retrievePromoList(token);

    if (result['status'] == 200) {
      // PromoModel responsedata = result['details'];
      // print(responsedata);
      // if (responsedata.total != "0") {
      //   responsedata.results!.forEach((element) {
      //     PromoList!.add(element);
      //   });
      // } else {
      //   PromoList = [];
      // }

      return (result['details']);
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget appbar() => CustomAppBar(title: "Promo", secondtitle: "", isAccessDetail: false, isNeedTwoLines: false);

    Widget emptyItem() => Center(
      child: Text(
        "Promo tidak tersedia",
        style: TextStyle(                        
          fontSize: 14.sp,
          color: ColorsTheme.black,
          fontWeight: FontWeight.w500,
        ),
      ),
    );

    Widget itemPromoGridList() => Expanded(
          child: Padding(
            padding: EdgeInsets.fromLTRB(17.w, 20.h, 17.w, 20.h),
            child: FutureBuilder(
                future: loadData,
                builder: (context, AsyncSnapshot snapshot) {
                  if(snapshot.connectionState == ConnectionState.done) {
                    if (!snapshot.hasData) {
                      var result = snapshot.data['results'];

                      return GridView.builder(
                        itemCount: result.length,
                        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 276.h,
                          crossAxisSpacing: 19.w,
                          mainAxisSpacing: 10.h,
                          childAspectRatio: 3.3.h / 5.4.h,
                        ),
                        shrinkWrap: true,
                        itemBuilder: (context, index) => CustomItemCard(
                          imageItem: '${result[index]['url_foto']}',
                          description: "${result[index]['judul']}",
                          idPromo: '${result[index]['id_promo_app']}',
                          imageShopItem: 'assets/images/logo_onboarding_2.png',
                          isProductHome: false,
                        ),
                      );
                    } else {
                      return emptyItem();
                    }
                  }
                  return loadingPromoGridList();
                }),
          ),
        );

    Widget body() => Column(
          children: [
            appbar(),
            itemPromoGridList(),
          ],
        );

    return AnnotatedRegion<SystemUiOverlayStyle>(
      child: SafeArea(
        child: Scaffold(
          body: body(),
        ),
      ),
      value: SystemUiOverlayStyle(statusBarColor: ColorsTheme.primary),
    );
  }

  Widget itemLoading() => Shimmer.fromColors(
      baseColor: ColorsTheme.lightBrown!,
      highlightColor: ColorsTheme.darkerBrown!,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey,
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(
            color: ColorsTheme.primary!.withOpacity(0.14),
            width: 1.w,
          ),
        ),
      ),
    );

  Widget loadingPromoGridList() => Container(
    padding: EdgeInsets.only(left: 17.w, top: 20.h, right: 17.w),
    child: GridView.builder(
      itemCount: 6,
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 240.h,
        crossAxisSpacing: 24.w,
        mainAxisSpacing: 12.h,
        childAspectRatio: 3.5.h / 5.4.w,
      ),
      shrinkWrap: true,
      itemBuilder: (context, index) => itemLoading(),
    ),
  );
}
