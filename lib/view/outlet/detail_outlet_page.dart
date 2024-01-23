
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fusia/color/colors_theme.dart';
import 'package:fusia/controller/login_controller.dart';
import 'package:fusia/controller/outlet_controller.dart';
import 'package:fusia/model/outlet_model/detail_outlet_model.dart';
import 'package:fusia/server/arguments_pass/temp_pass_detail_outlet.dart';
import 'package:fusia/server/server_base.dart';
import 'package:fusia/widget/custom_appbar.dart';
import 'package:fusia/widget/custom_toast.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailOutletPage extends StatefulWidget {
  
  @override
  _DetailOutletPageState createState() => _DetailOutletPageState();
}

class _DetailOutletPageState extends State<DetailOutletPage> {

  LoginController? loginController;
  OutletController? outletController;

  Future? loadData;

  TextStyle outletStatusTextStyle = TextStyle(
    fontFamily: 'Poppins',
    fontSize: 12.sp,
    fontWeight: FontWeight.w700,
    color: ColorsTheme.primary,
  );

  TextStyle outletLabelTextStyle = TextStyle(
    fontFamily: 'Poppins',
    fontSize: 12.sp,
    fontWeight: FontWeight.w500,
    color: ColorsTheme.white,
  );

  TextStyle generalLabelTextStyle(isTitle) => TextStyle(
    fontFamily: 'Poppins',
    fontSize: 12.sp,
    fontWeight: (isTitle) ? FontWeight.w500 : FontWeight.w400,
    color: ColorsTheme.black,
  );

  var phone;
  var latitude,longitude;
  var bannerPhoto, bannerLogo;
  var addressToko, locatedOutlet, nameOutlet, cabangKota;
  var jamBuka, jamTutup, statusToko;
  List<String>? urlFotoMenu;

  @override
  void initState() {
    super.initState();

    initConstructor();
    initData();
  }

  initConstructor() {
    loginController = Get.put(LoginController());
    outletController = Get.put(OutletController());

    addressToko = "".obs;
    cabangKota = "".obs;
    phone = "".obs;
    nameOutlet = "".obs;
    locatedOutlet = "".obs;
    jamBuka = "".obs;
    jamTutup = "".obs;
    statusToko = "".obs;
    bannerLogo = "";
    bannerPhoto = "";
    urlFotoMenu = [];
  }

  initData() async {
    await loginController!.retrieveUserLocalData();
    await outletController!.retrieveMasterId();

    setState(() {
      
      var _token = LoginController.userToken;
      var _masterId = OutletController.masterIdOutlet1;

      loadData = loadDetailOutlet(_masterId,_token);
    });

  }

  loadDetailOutlet(masterId,token) async {
    var result = await outletController!.retrieveDetailOutletController(masterId, token);

    if(result['status'] == 200) {
      DetailOutletModel responsedata = result['details'];

      setState(() {

          phone.value = (responsedata.results![0].cabangTelp == "") ? "Tidak Tersedia" : responsedata.results![0].cabangTelp;
        
          //for base shop identity
          nameOutlet.value = responsedata.results![0].cabangNama;
          jamBuka.value = responsedata.results![0].jamBuka;
          jamTutup.value = responsedata.results![0].jamTutup;
          statusToko.value = responsedata.results![0].statusBuka;
          addressToko.value = responsedata.results![0].cabangAlamat;
          cabangKota.value = responsedata.results![0].cabangKota;

          //for photo image
          for(int i = 0; i < responsedata.results![0].foto!.length; i++) {
            if(responsedata.results![0].foto![i].jenis == "Header") {
              bannerPhoto = responsedata.results![0].foto![i].urlFoto!.replaceAll(" ", "%20");
            } else if(responsedata.results![0].foto![i].jenis == "Logo") {
              bannerLogo = responsedata.results![0].foto![i].urlFoto!.replaceAll(" ", "%20");
            } else if(responsedata.results![0].foto![i].jenis == "Menu") {
              urlFotoMenu!.add(responsedata.results![0].foto![i].urlFoto!.replaceAll(" ", "%20"));
            }
          }
          
      });

    }
  }

  @override
  Widget build(BuildContext context) {

    Widget appbar() => CustomAppBar(title: "Cabang Kota ${cabangKota.value}", secondtitle: nameOutlet.value, isAccessDetail: true,isNeedTwoLines: true);

    Widget loadingBanner() => Shimmer.fromColors(
      child: Container(
        width: ScreenUtil().screenWidth,
        height: 283.h,
        color: ColorsTheme.black,
      ),
      baseColor: ColorsTheme.lightBrown!,
      highlightColor: ColorsTheme.darkerBrown!,
    );

    Widget image(isLoading) => SizedBox(
        width: ScreenUtil().screenWidth,
        height: 185.h,
        child: SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              (isLoading) 
              ? loadingBanner()
              : CachedNetworkImage(
                imageUrl: "${ServerBase.serverUrl}/$bannerPhoto",
                placeholder: (context,url) => loadingBanner(),
                errorWidget: (context,url,error) => Image.asset('assets/images/no_image.png'),
              ),
            ],
          ),
        ),
      );

    Widget outletStatus() => Container(
      height: 24.h,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 18.w,vertical: 3.h),
        child: Center(child: Text((statusToko.value == "") ? "TUTUP" : "${statusToko.value}".toUpperCase(),style: outletStatusTextStyle)),
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        color: ColorsTheme.white,
      ),
    );

    Widget labelOutlet() => Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(nameOutlet.value,style: outletLabelTextStyle),
            Text((jamBuka.value == "" && jamTutup.value == "") ? "Tidak Tersedia" : "${jamBuka.value} - ${jamTutup.value}",style: outletLabelTextStyle),
          ],
        ),
      ],
    );
    
    Widget descriptionOutlet(isLoading) {

      Widget loadingList(lines) => Shimmer.fromColors(
        child: Container(
          width: (lines == 1) ? 80.w : 60.h,
          height: 15.h,
          color: ColorsTheme.black,
        ),
        baseColor: ColorsTheme.lightBrown!,
        highlightColor: ColorsTheme.darkerBrown!,
      );

      return Positioned(
        child: Container(
          height: 56.h,
          child: Padding(
            padding: EdgeInsets.only(left: 91.w,right: 20.w,top: 7.h,bottom: 9.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: (isLoading)
              ?
              [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    loadingList(1),
                    SizedBox(height: 2.h),
                    loadingList(2)
                  ],
                ),
                loadingList(2),
              ] : [
                labelOutlet(),
                outletStatus(),
              ],
            ),
          ),
          decoration: BoxDecoration(
            border: Border.all(color: ColorsTheme.white!.withAlpha(80)),
            boxShadow: [
              BoxShadow(
                color: ColorsTheme.black!.withAlpha(100),
                blurRadius: 4.6.r,
                spreadRadius: 0.0.r,
              )
            ],
            color: ColorsTheme.black!.withOpacity(0.1)
          ),
        ),
        bottom: 0.h,
        left: 0.w,
        right: 0.w,
      );
    }

    Widget logoOutlet(isLoading) {

      Widget loadingAvatar() => SizedBox(
        width: 52.w,
        height: 52.h,
        child: Shimmer.fromColors(
          child:
              CircleAvatar(backgroundColor: ColorsTheme.black, radius: 30.r),
          baseColor: ColorsTheme.lightBrown!,
          highlightColor: ColorsTheme.darkerBrown!,
        ),
      );

      Widget emptyImage() => Container(
        width: 52.w,
        height: 52.h,
        decoration: ShapeDecoration(
          shape: CircleBorder(
              side: BorderSide(color: ColorsTheme.lightYellow!, width: 4.w)),
        ),
        child: FittedBox(
          fit: BoxFit.cover,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(30.r),
            child: CircleAvatar(
              radius: 30.r,
              child: Image.asset("assets/images/mascot_siluet.jpg"),
            ),
          ),
        ),
      );

      return Positioned(
        child: (isLoading)
        ? loadingAvatar()
        : CachedNetworkImage(
            imageUrl: "${ServerBase.serverUrl}/$bannerLogo",
            imageBuilder: (context,imageProvider) => SizedBox(
              width: 52.w,
              height: 52.h,
              child:  CircleAvatar(
                backgroundColor: ColorsTheme.lightYellow,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(13.r),
                  child: SizedBox(
                    width: 49.w,
                    height: 49.h,
                    child: CircleAvatar(
                      backgroundImage: imageProvider,
                    ),
                  )
                ),
              )
            ),
            placeholder: (context,url) => loadingAvatar(),
            errorWidget: (context,url,error) => emptyImage(),
          ),
        left: 31.w,
        bottom: 14.h,
      );
    }

    Widget btnAccessSubMenu(status, isLoading) {
      
      Widget loadingBox() => Shimmer.fromColors(
        child: Container(
          width: 80.w,
          height: 120.h,
          color: ColorsTheme.black,
        ),
        baseColor: ColorsTheme.lightBrown!,
        highlightColor: ColorsTheme.darkerBrown!,
      );

      Widget contentMenu() => Column(
        children: [
          SizedBox(
            child: FittedBox(
              fit: BoxFit.cover,
              child: Image.asset( (status == "menu") 
                ? 'assets/icons/ic_menu_book.png' 
                : (status == "maps") 
                  ? 'assets/icons/ic_maps.png' 
                  : 'assets/icons/ic_telephone.png'
              ),
            ),
            width: 24.w,
            height: 24.h,
          ),
          SizedBox(height: 12.h),
          Text((status == "menu") 
          ? "Menu" 
            : (status == "maps") 
            ? "Maps" 
              : "Telepon", 
          style: generalLabelTextStyle(false)
          ),
        ],
      );

      return InkWell(
        onTap: () => actionButton(status),
        child: Container(
          height: 88.h,
          child: Padding(
            padding: EdgeInsets.fromLTRB(41.w, 20.h, 41.w, 12.h),
            child: (isLoading) ? loadingBox() : contentMenu(),
          ),
          decoration: BoxDecoration(
            border: Border.symmetric(
              vertical: BorderSide(
                color: ColorsTheme.primary!.withOpacity(0.14),
                width: 0.5.w,
              ),
              horizontal: BorderSide(
                color: ColorsTheme.primary!.withOpacity(0.14),
                width: 1.w,
              )
            ),
          ),
        ),
      );
    }

    Widget labelDescription(labelTitle,labelValue,status,) => Row(
      children: [
        Text(labelTitle, style: generalLabelTextStyle(true)),
        SizedBox(width: (status == "location") ? 21.w : (status == "address") ? 35.w : 46.w),
        Text(" : ",style: generalLabelTextStyle(true)),
        SizedBox(width: 21.w),
        Flexible(
          child: Text(labelValue,style: generalLabelTextStyle(false),maxLines: 5),
        ),
      ],
    );

    Widget contentBody(isLoading) {

      Widget loadingList() => Shimmer.fromColors(
        child: Container(
          width: 200.w,
          height: 15.h,
          color: ColorsTheme.black,
        ),
        baseColor: ColorsTheme.lightBrown!,
        highlightColor: ColorsTheme.darkerBrown!,
      );

      return Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Stack(
            children: <Widget>[
              image(isLoading),
              descriptionOutlet(isLoading),
              logoOutlet(isLoading),
            ],
          ),
          FittedBox(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                btnAccessSubMenu("menu",isLoading),
                btnAccessSubMenu("maps",isLoading),
                btnAccessSubMenu("",isLoading),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 27.h,left: 21.w,right: 21.w),
            child: (isLoading) 
            ? Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                loadingList(),
                SizedBox(height: 12.h),
                loadingList(),
                SizedBox(height: 12.h),
                loadingList(),
              ],
            ) : Obx(() => Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                labelDescription("Located in", nameOutlet.value,"location"),
                SizedBox(height: 12.h),
                labelDescription("Address", addressToko.value,"address"),
                SizedBox(height: 12.h),
                labelDescription("Phone", phone.value,"phone"),
              ]),
            ),
          )
        ],
      );
    }

    Widget body() => FutureBuilder(
      future: loadData,
      builder: (context,snapshot) {
        if(snapshot.connectionState == ConnectionState.done) {
          if(snapshot.hasData) {
            return Center(
              child: Text("Data Outlet Kosong",style: outletStatusTextStyle),
            );
          } else {
            return contentBody(false);
          }
        }
        return contentBody(true);
      },
    );
    
    return AnnotatedRegion<SystemUiOverlayStyle>(
      child: SafeArea(
        child: Scaffold(
          body: body(),
          appBar: PreferredSize(
            child: appbar(),
            preferredSize: Size.fromHeight(78.h),
          ),
        ),
      ), 
      value: SystemUiOverlayStyle(statusBarColor: ColorsTheme.primary),
    );
  }

  actionButton(status) async {
    if(status == "menu") {
      if(urlFotoMenu != null) {
        Navigator.pushNamed(context, '/outlet_menu',arguments: DetailOutletMenuArgumentPass(image_menu: urlFotoMenu!));
      } else {
        showToast(context, "Menu tidak tersedia untuk cabang ini.");
      }
    } else if(status == "maps") {
      showToast(context, "Fitur Maps masih dalam tahap pengembangan.");
    } else {
      if(phone.value == "Tidak Tersedia") {
        showToast(context, "Akses Telp. tidak tersedia untuk cabang ini.");
      } else {
        launch("tel://${phone.value}");
      }
    }
  }
}