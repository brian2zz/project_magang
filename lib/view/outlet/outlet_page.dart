// import 'package:coba_fusia/color/colors_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fusia/controller/login_controller.dart';
import 'package:fusia/controller/outlet_controller.dart';
import 'package:fusia/model/outlet_model.dart';
import 'package:fusia/server/arguments_pass/temp_pass_detail_outlet.dart';
import 'package:fusia/widget/custom_appbar.dart';
import 'package:get/get.dart';

import '../../color/colors_theme.dart';

class RewardPage extends StatefulWidget {
  const RewardPage({Key? key}) : super(key: key);

  @override
  _RewardPageState createState() => _RewardPageState();
}

class _RewardPageState extends State<RewardPage> {
  
  OutletController? controller;
  LoginController? loginController;

  List<Result> allOutletData = [];
  List<Result> filteredOutletData = [];

  var token;

  Future? loadData;
  
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

  TextStyle itemListTextStyle = TextStyle(
    fontFamily: 'Poppins',
    fontSize: 12.sp,
    fontWeight: FontWeight.w400,
    color: ColorsTheme.black,
  );

  TextStyle textFormTextStyle = TextStyle(
    fontFamily: 'Poppins',
    fontSize: 12.sp,
    fontWeight: FontWeight.w400,
    color: ColorsTheme.neutralDark,
  );

  @override
  initState() {
    super.initState();

    initConstructor();
    initData();
  }

  initConstructor() async {
    controller = Get.put(OutletController());
    loginController = Get.put(LoginController());

    token = "".obs;
  }

  initData() async {
    await loginController!.retrieveUserLocalData();

    setState(() {
      token.value = LoginController.userToken.value;

      loadData = loadDataOutlet(token.value);
    });
  }

  loadDataOutlet(token) async {
    var result = await controller!.retrieveOutletListController(token);

    if(result['status'] == 200) {
      var responsedata = OutletModel.fromJson(result['details']);
      
      for (var element in responsedata.results!) {
        print(element.cabangNama);
        allOutletData.add(element);
      }

      setState(() {
        filteredOutletData = allOutletData;
      });
    }
  }

  searchInput(String query) {
    List<Result> temporarySearch = [];

    if(query.isEmpty) {
      setState(() {
        filteredOutletData = allOutletData;
      });
    } else {
      temporarySearch = allOutletData.where((element) => element.cabangNama!.toLowerCase().contains(query.toLowerCase())).toList();
      setState(() {
        filteredOutletData = temporarySearch;
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    Widget appbar() => CustomAppBar(title: "Outlets", secondtitle: "",isAccessDetail: false,isNeedTwoLines: false);

    Widget itemList(Result datalist) => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: () {
            setState(() {
              controller!.storedMasterId(datalist.cabangId);
              Navigator.pushNamed(context, '/detail_outlet');
            });
          }, 
          child: Padding(
            padding: EdgeInsets.only(top: 21.h,bottom: 21.h,right: 10.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(datalist.cabangNama.toString(),style: itemListTextStyle),
                RotatedBox(
                  quarterTurns: 2,
                  child: SizedBox(
                    width: 6.w,
                    height: 12.h,
                    child: FittedBox(
                      fit: BoxFit.cover,
                      child: Image.asset('assets/icons/ic_arrow_back.png'),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Divider(color: ColorsTheme.neutralGrey),
      ],
    );

    Widget searchForm() => TextFormField(
      textInputAction: TextInputAction.search,
      keyboardType: TextInputType.text,
      onFieldSubmitted: (value) => searchInput(value),
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: BorderSide(color: ColorsTheme.neutralDark!, width: 1.w),
        ),
        prefixIcon: Image.asset('assets/icons/ic_search.png'),
        hintText: "Search Outlet",
        hintStyle: textFormTextStyle,
      ),
      style: textFormTextStyle,
    );

    Widget body() => Padding(
      padding: EdgeInsets.only(top: 9.h,left: 20.w,right: 20.w),
      child: FutureBuilder(
        future: loadData,
        builder: (context,snapshot) {
          if(snapshot.connectionState == ConnectionState.done) {
              if(snapshot.hasData) {
                return Center(
                  child: Text("Data Outlet tidak tersedia.",style: contentStyle1),
                );
              } else {
                return Container(
                  height: ScreenUtil().screenHeight,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        searchForm(),
                        (filteredOutletData.isEmpty) ?
                        Container(
                          margin: EdgeInsets.only(top: 220.h),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text("Pencarian Data Outlet tidak tersedia.",style: contentStyle1),
                            ],
                          ),
                        ) : Container(
                          padding: EdgeInsets.only(top:20.h),
                          height: 480.h,
                          child: ListView.builder(
                            itemCount: filteredOutletData.length,
                            shrinkWrap: true,
                            itemBuilder: (context,index) => itemList(filteredOutletData[index]),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      )
    );

    return AnnotatedRegion<SystemUiOverlayStyle>(
      child: SafeArea(
        child: Scaffold(
          body: body(),
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(78.h),
            child: appbar(),
          ),
        ),
      ),
      value: SystemUiOverlayStyle(statusBarColor: ColorsTheme.primary),
    );
  }
}
