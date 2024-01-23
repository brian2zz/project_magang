import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fusia/color/colors_theme.dart';
import 'package:fusia/controller/login_controller.dart';
import 'package:fusia/controller/promo_controller.dart';
import 'package:fusia/model/promo_model.dart';
import 'package:fusia/server/server_base.dart';
import 'package:fusia/widget/custom_appbar.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';

class DetailPromo extends StatefulWidget {

  @override
  const DetailPromo({
    Key? key
  }) : super(key: key);

  _DetailPromoState createState() => _DetailPromoState();
}

class _DetailPromoState extends State<DetailPromo> {
  PromoController? promoController;
  LoginController? loginController;

  RxString? token;
  Future? loadData;
  bool? Loading;
  var judulPromo;
  var tglAwal;
  var tglAkhir;
  var keteranganPromo;
  var namaProduk;
  var photoPromo;

  TextStyle contentStyle1(isDescription) => TextStyle(
        fontFamily: 'Poppins',
        fontWeight: FontWeight.w400,
        fontSize: (isDescription) ? 14.sp : 12.sp,
        color: ColorsTheme.primary,
      );

  TextStyle contentDescriptionTextStyle = TextStyle(
    fontFamily: 'Poppins',
    fontSize: 14.sp,
    fontWeight: FontWeight.w400,
    color: ColorsTheme.neutralGrey,
  );

  TextStyle productNameTextStyle = TextStyle(
    fontFamily: 'Poppins',
    fontSize: 14.sp,
    fontWeight: FontWeight.w600,
    color: ColorsTheme.primary,
  );

  TextStyle periodValueTextStyle(isTitle) => TextStyle(
        fontFamily: 'Poppins',
        fontSize: 10.sp,
        fontWeight: (isTitle) ? FontWeight.w400 : FontWeight.w500,
        color: (isTitle) ? ColorsTheme.primary : ColorsTheme.lightRed,
      );

  @override
  initState() {
    super.initState();
    initConstructor();
    initData();
  }

  initConstructor() {
    promoController = Get.put(PromoController());
    loginController = Get.put(LoginController());
    judulPromo = "".obs;
    tglAwal = "".obs;
    tglAkhir = "".obs;
    keteranganPromo = "".obs;
    namaProduk = "".obs;
    photoPromo = "".obs;
  }

  initData() async {
    await loginController!.retrieveUserLocalData();
    await promoController!.retrievePromoId();

    setState(() {
      token = LoginController.userToken;
      loadData = _loadData(token, PromoController.promoId);
    });
  }

  _loadData(token, idPromo) async {
    var result = await promoController!.DetailPromo(token, idPromo);

    setState(() {
      if (result['status'] == 200) {
        Promo responseData = Promo.fromJson(result['details']['results'][0]);
        judulPromo.value = responseData.judul;
        tglAwal.value = responseData.tanggalAwal;
        tglAkhir.value = responseData.tanggalAkhir;
        keteranganPromo.value = responseData.keterangan;
        photoPromo.value = responseData.urlFoto;
        namaProduk.value = responseData.produkNama;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // setState(() {
    //   id_promo_app = widget.idPromo;
    // });
    Widget appbar(Loading) => (Loading)
        ? CustomAppBar(title: "", isAccessDetail: true)
        : CustomAppBar(
            title: "Promo: ${judulPromo.value}", isAccessDetail: true);

    Widget rowShop() => Row(
          children: [
            SizedBox(
              width: 36.w,
              height: 36.h,
              child: CircleAvatar(
                radius: 10.r,
                child: CircleAvatar(
                  child: Image.asset('assets/images/logo_onboarding_2.png'),
                  backgroundColor: ColorsTheme.white,
                ),
                backgroundColor: ColorsTheme.lightYellow,
              ),
            ),
            SizedBox(width: 14.w),
            Text("Kampoeng Timbel", style: contentStyle1(false)),
          ],
        );

    Widget contenTitle() {
      DateTime parseTglAwal = DateFormat('dd-MM-yyyy').parse(tglAwal.value);
      DateTime parseTglAkhir = DateFormat('dd-MM-yyyy').parse(tglAkhir.value);
      var inputTglAwal = DateTime.parse(parseTglAwal.toString());
      var inputTglAkhir = DateTime.parse(parseTglAkhir.toString());
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text("Nasi Timbel", style: productNameTextStyle),
          SizedBox(height: 14.h),
          RichText(
            text: TextSpan(children: [
              TextSpan(text: "Periode : ", style: periodValueTextStyle(true)),
              TextSpan(
                  text:
                      "${DateFormat('dd MMMM yyyy').format(inputTglAwal)} - ${DateFormat('dd MMMM yyyy').format(inputTglAkhir)}",
                  style: periodValueTextStyle(false)),
            ]),
          ),
        ],
      );
    }

    Widget titleDescription() => Padding(
        padding: EdgeInsets.symmetric(horizontal: 19.w, vertical: 18.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            rowShop(),
            SizedBox(height: 17.h),
            Divider(height: 1.h, color: ColorsTheme.primary!.withOpacity(0.14)),
            SizedBox(height: 26.h),
            contenTitle(),
          ],
        ));

    Widget contentDescription() => Padding(
          padding: EdgeInsets.only(top: 16.h, bottom: 19.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 19.w, bottom: 10.h),
                child: Text("Description", style: contentStyle1(true)),
              ),
              Container(height: 3.h, color: ColorsTheme.lightYellow),
              Padding(
                padding: EdgeInsets.only(left: 20.w, right: 20.w, top: 18.w),
                child: Text(
                  "${keteranganPromo.value}",
                  style: contentDescriptionTextStyle,
                ),
              ),
            ],
          ),
        );

    Widget headerImage() => SizedBox(
        width: 358.w,
        height: 271.h,
        child: FittedBox(
          fit: BoxFit.fitWidth,
          child: Image.network('${ServerBase.serverUrl}${photoPromo.value}'),
        ));

    Widget contentBody() => Expanded(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 0.h, vertical: 0.w),
              child: Column(
                children: [
                  headerImage(),
                  titleDescription(),
                  Container(height: 9.h, color: ColorsTheme.lightGrey2),
                  contentDescription(),
                ],
              ),
            ),
          ),
        );

    Widget LoadingContent() => Expanded(
          child: Container(
            child: Column(
              children: [
                SizedBox(
                    width: 358.w,
                    height: 271.h,
                    child: FittedBox(
                      fit: BoxFit.fill,
                      child: Shimmer.fromColors(
                        baseColor: ColorsTheme.lightBrown!,
                        highlightColor: ColorsTheme.darkerBrown!,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.grey,
                            border: Border.all(
                              color: ColorsTheme.primary!.withOpacity(0.14),
                              width: 1.w,
                            ),
                          ),
                        ),
                      ),
                    )),
                Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 19.w, vertical: 18.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            SizedBox(
                              width: 36.w,
                              height: 36.h,
                              child: Shimmer.fromColors(
                                baseColor: ColorsTheme.lightBrown!,
                                highlightColor: ColorsTheme.darkerBrown!,
                                child: CircleAvatar(
                                  radius: 10.r,
                                  backgroundColor: ColorsTheme.lightYellow,
                                ),
                              ),
                            ),
                            SizedBox(width: 14.w),
                            Shimmer.fromColors(
                                baseColor: ColorsTheme.lightBrown!,
                                highlightColor: ColorsTheme.darkerBrown!,
                                child: Container(
                                  height: 10.h,
                                  width: 100.w,
                                  color: Colors.grey,
                                )),
                          ],
                        ),
                        SizedBox(height: 17.h),
                        Divider(
                            height: 1.h,
                            color: ColorsTheme.primary!.withOpacity(0.14)),
                        SizedBox(height: 26.h),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Shimmer.fromColors(
                                baseColor: ColorsTheme.lightBrown!,
                                highlightColor: ColorsTheme.darkerBrown!,
                                child: Container(
                                  height: 10.h,
                                  width: 100.w,
                                  color: Colors.grey,
                                )),
                            SizedBox(height: 14.h),
                            Row(
                              children: [
                                Shimmer.fromColors(
                                    baseColor: ColorsTheme.lightBrown!,
                                    highlightColor: ColorsTheme.darkerBrown!,
                                    child: Container(
                                      height: 10.h,
                                      width: 50.w,
                                      color: Colors.grey,
                                    )),
                                SizedBox(width: 14.h),
                                Shimmer.fromColors(
                                    baseColor: ColorsTheme.lightBrown!,
                                    highlightColor: ColorsTheme.darkerBrown!,
                                    child: Container(
                                      height: 10.h,
                                      width: 70.w,
                                      color: Colors.grey,
                                    )),
                                SizedBox(width: 14.h),
                                Shimmer.fromColors(
                                    baseColor: ColorsTheme.lightBrown!,
                                    highlightColor: ColorsTheme.darkerBrown!,
                                    child: Container(
                                      height: 10.h,
                                      width: 70.w,
                                      color: Colors.grey,
                                    )),
                              ],
                            ),
                          ],
                        ),
                      ],
                    )),
                Padding(
                  padding: EdgeInsets.only(top: 16.h, bottom: 19.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 19.w, bottom: 10.h),
                        child: Shimmer.fromColors(
                            baseColor: ColorsTheme.lightBrown!,
                            highlightColor: ColorsTheme.darkerBrown!,
                            child: Container(
                              height: 15.h,
                              width: 70.w,
                              color: Colors.grey,
                            )),
                      ),
                      Container(height: 3.h, color: ColorsTheme.lightYellow),
                      Padding(
                        padding:
                            EdgeInsets.only(left: 20.w, right: 20.w, top: 18.w),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        );

    Widget body() => Container(
          child: FutureBuilder(
              future: loadData,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasData) {
                    return Column(
                      children: [
                        appbar(false),
                        contentBody(),
                      ],
                    );
                  } else {
                    return Column(
                      children: [
                        appbar(false),
                        contentBody(),
                      ],
                    );
                  }
                } else {
                  return Column(
                    children: [
                      appbar(true),
                      LoadingContent(),
                    ],
                  );
                }
              }),
        );

    return AnnotatedRegion<SystemUiOverlayStyle>(
      child: SafeArea(
          child: Scaffold(
        body: body(),
      )),
      value: SystemUiOverlayStyle(statusBarColor: ColorsTheme.primary),
    );
  }
}
