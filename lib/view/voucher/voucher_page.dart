import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fusia/color/colors_theme.dart';
import 'package:fusia/controller/login_controller.dart';
import 'package:fusia/controller/voucher_controller.dart';
import 'package:fusia/model/voucher_model.dart';
import 'package:fusia/server/server_base.dart';
import 'package:fusia/widget/card_voucher.dart';
import 'package:fusia/widget/custom_appbar.dart';
import 'package:fusia/widget/custom_appbar_account.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';

class VoucherPage extends StatefulWidget {
  VoucherPage({Key? key}) : super(key: key);

  @override
  State<VoucherPage> createState() => _VoucherPageState();
}

class _VoucherPageState extends State<VoucherPage> {
  //controller
  LoginController? userController;
  VoucherController? voucherController;

  //utils
  NumberFormat? hargaFormat;

  //future
  Future? _loadData;

  //temporary datasets
  List<Voucher>? voucherList;

  //global variable
  var userToken;
  var customerId;
  var idVoucher;
  var nilaiVoucher;
  var tanggalAkhir;
  var voucher;

  TextStyle headerStyle = TextStyle(
    fontFamily: 'Poppins',
    fontSize: 14.sp,
    fontWeight: FontWeight.w700,
    color: Color.fromRGBO(80, 36, 35, 1),
  );

  @override
  initState() {
    super.initState();

    initConstructor();
    initData();
  }

  initConstructor() {
    // controllerPromo = CarouselController();
    // _currentPageNotifier = ValueNotifier<int>(0);

    userController = Get.put(LoginController());
    // dashboardController = Get.put(DashboardController());
    voucherController = Get.put(VoucherController());

    userToken = "".obs;
    customerId = "".obs;
    nilaiVoucher = "".obs;
    // namaUser = "".obs;
    // membershipUser = "".obs;
    // pointUser = "".obs;
    // photoUrlUser = "".obs;
    // pointUser = "".obs;
    // photoId = "".obs;

    // bannerPromoList = [];
    voucherList = [];

    hargaFormat = NumberFormat('#,###');
  }

  initData() async {
    await userController!.retrieveUserLocalData();

    setState(() {
      userToken.value = LoginController.userToken.value;
      customerId.value = LoginController.customerId.value;
      // print(customerId);

      // _loadData = chainingRequest(userToken.value, customerId.value);
    });
  }

  loadVoucherUser() async {
    await userController!.retrieveUserLocalData();

    var token = LoginController.userToken.value;
    var customerId = LoginController.customerId.value;
    var result =
        await voucherController!.retrieveVoucherUser(token, customerId);
    return (result['details']);
  }

  loadVoucher() async {
    await userController!.retrieveUserLocalData();
    var token = LoginController.userToken.value;
    var customerId = LoginController.customerId.value;
    var result = await voucherController!.retrieveVouchers(token, customerId);
    return (result['details']);
  }

  Widget Garis1() => Container(
      height: 2.h, decoration: BoxDecoration(color: Colors.grey[200]));

  Widget _tabBar() => TabBar(
        indicatorColor: Color.fromARGB(255, 230, 122, 11),
        labelColor: Color.fromARGB(255, 80, 36, 35),
        unselectedLabelColor: Colors.black,
        tabs: [
          Tab(
            child: Text("Vouchers to be Claimed",
                textAlign: TextAlign.center, style: headerStyle),
          ),
          Tab(
            child: Text("My Vouchers",
                textAlign: TextAlign.center, style: headerStyle),
          ),
        ],
      );

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: appBar(title: "Vouchers"),
        body: Column(
          children: <Widget>[
            Garis1(),
            // the tab bar with two items
            SizedBox(
              height: 70.h,
              child: ColoredBox(color: Colors.white, child: _tabBar()),
            ),
            SizedBox(height: 20.h),
            Expanded(
              child: TabBarView(
                children: [
                  // first tab bar view widget
                  FutureBuilder(
                    future: loadVoucher(),
                    builder: (context, AsyncSnapshot snapshot) {
                      if (snapshot.hasData) {
                        var result = snapshot.data['results'];

// Map strarray = tanggalBerlaku.map.split(" ");
// print(strarray);
                        return ListView.builder(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemCount: result.length,
                          itemBuilder: (BuildContext context, int index) {
                            return CardVoucher(
                              TanggalBerlaku: {},
                              TanggalAwal: result[index]['tanggal_awal'],
                              TanggalAkhir: result[index]['tanggal_akhir'],
                              TanggalAwalFormat: result[index]['tanggal_awal_new'],
                              TanggalAkhirFormat: result[index]['tanggal_akhir_new'],
                              // TanggalBerlaku: ,
                              HargaVoucher: "${result[index]['nilai_rp']}",
                              // HargaVoucher: "${nilaiVoucher.value}",
                              formatHargaVoucher: hargaFormat!.format(double.parse(result[index]['nilai_rp'])),
                              Poin: 0,
                              Banner: ("${result[index]['url_foto']}" == "null")
                                  ? "https://images.unsplash.com/photo-1523800378286-dae1f0dae656?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1076&q=80"
                                  : "${ServerBase.serverUrl}${result[index]['url_foto']}",
                              Identity: true,
                              Keterangan: "${result[index]['keterangan']}",
                            );
                          },
                        );
                      } else {
                        return ListView(
                            physics: const BouncingScrollPhysics(
                                parent: NeverScrollableScrollPhysics()),
                            children: [
                              Shimmer.fromColors(
                                baseColor: ColorsTheme.lightBrown!,
                                highlightColor: ColorsTheme.darkerBrown!,
                                child: Container(
                                  margin: EdgeInsets.symmetric(
                                      horizontal: 20.w, vertical: 16.h),
                                  width: 335.w,
                                  height: 260.h,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.r),
                                    color: ColorsTheme.white,
                                  ),
                                ),
                              ),
                              Shimmer.fromColors(
                                baseColor: ColorsTheme.lightBrown!,
                                highlightColor: ColorsTheme.darkerBrown!,
                                child: Container(
                                  margin: EdgeInsets.symmetric(
                                      horizontal: 20.w, vertical: 16.h),
                                  width: 335.w,
                                  height: 260.h,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.r),
                                    color: ColorsTheme.white,
                                  ),
                                ),
                              ),
                            ]);
                      }
                    },
                  ),

                  // second tab bar view widget
                  FutureBuilder(
                    future: loadVoucherUser(),
                    builder: (context, AsyncSnapshot snapshot) {
                      // print(snapshot.hasData);
                      if (snapshot.hasData) {
                        // print(snapshot.data['results']);
                        var result = snapshot.data['results'];
                        return ListView.builder(
                          itemCount: result.length,
                          itemBuilder: (BuildContext context, int index) {
                            String tanggalBerlakuFull =
                                "${result[index]['tanggal_berlaku']}";
                            var tanggalBerlakuSplit =
                                tanggalBerlakuFull.split(' s/d ');
                            var split = tanggalBerlakuFull.split(' s/d ');
                            Map<int, String> values = {
                              for (int i = 0; i < split.length; i++) i: split[i]
                            };
                            print(values);

                            return CardVoucher(
                                TanggalBerlaku: values,
                                TanggalAwal: '',
                                TanggalAkhir: '',
                                TanggalAwalFormat: '',
                                TanggalAkhirFormat: '',
                                HargaVoucher: "Rp 50000",
                                // "${result[index]['nilai_rp']}",
                                // HargaVoucher: "${nilaiVoucher.value}",
                                formatHargaVoucher: "Rp 50000",
                                Poin: 0,
                                Banner: ("${result[index]['url_foto']}" ==
                                        "null")
                                    ? "https://images.unsplash.com/photo-1523800378286-dae1f0dae656?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1076&q=80"
                                    : "${ServerBase.serverUrl}${result[index]['url_foto']}",
                                Identity: false,
                                Keterangan: "${result[index]['keterangan']}");
                          },
                        );
                      } else {
                        return ListView(
                            physics: const BouncingScrollPhysics(
                                parent: NeverScrollableScrollPhysics()),
                            children: [
                              Shimmer.fromColors(
                                baseColor: ColorsTheme.lightBrown!,
                                highlightColor: ColorsTheme.darkerBrown!,
                                child: Container(
                                  margin: EdgeInsets.symmetric(
                                      horizontal: 20.w, vertical: 16.h),
                                  width: 335.w,
                                  height: 260.h,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.r),
                                    color: ColorsTheme.white,
                                  ),
                                ),
                              ),
                              Shimmer.fromColors(
                                baseColor: ColorsTheme.lightBrown!,
                                highlightColor: ColorsTheme.darkerBrown!,
                                child: Container(
                                  margin: EdgeInsets.symmetric(
                                      horizontal: 20.w, vertical: 16.h),
                                  width: 335.w,
                                  height: 260.h,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.r),
                                    color: ColorsTheme.white,
                                  ),
                                ),
                              ),
                            ]);
                      }
                    },
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
