
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fusia/color/colors_theme.dart';
import 'package:fusia/server/arguments_pass/temp_pass_detail_outlet.dart';
import 'package:fusia/server/server_base.dart';
import 'package:fusia/view/outlet/detail_fullscreen.dart';
import 'package:fusia/widget/custom_appbar.dart';
import 'package:fusia/widget/custom_appbar_account.dart';
import 'package:shimmer/shimmer.dart';

class DetailOutletMenuPage extends StatefulWidget {
  
  _DetailOutletMenuPageState createState() => _DetailOutletMenuPageState();
}

class _DetailOutletMenuPageState extends State<DetailOutletMenuPage> {

  var _currentPageNotifier;
  var _zoomPageNotifier;
  CarouselController? controllerMenu;
  Matrix4? matrix;

  @override
  void initState() {
    super.initState();
    initConstructor();
  }

  initConstructor() {
    controllerMenu = CarouselController();
    _currentPageNotifier = ValueNotifier<int>(0);
    _zoomPageNotifier = ValueNotifier<int>(0);
    matrix = Matrix4.identity();
  }

  @override
  Widget build(BuildContext context) {

    final routeMenu = ModalRoute.of(context)!.settings.arguments! as DetailOutletMenuArgumentPass;

    Widget appbar() => CustomAppBar(title: "Menu", secondtitle: "", isAccessDetail: true, isNeedTwoLines: false);

    Widget loadingBanner() => Shimmer.fromColors(
      child: Container(
        width: ScreenUtil().screenWidth,
        height: 300.h,
        color: ColorsTheme.black,
      ),
      baseColor: ColorsTheme.lightBrown!,
      highlightColor: ColorsTheme.darkerBrown!,
    );

    Widget imageMenu(index) => CachedNetworkImage(
      imageUrl: "${ServerBase.serverUrl}${routeMenu.image_menu[index]}",
      imageBuilder: (context,imageProvider) => Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: imageProvider,
          ),
        ),
      ),
      placeholder: (context,url) => loadingBanner(),
      errorWidget: (context,url,error) => Image.asset('assets/images/no_image_2.png'),
    ); 

    Widget contentMenu(index) => GestureDetector(
      // ignore: unnecessary_null_comparison
      onTap: () => (routeMenu.image_menu[index] != null || routeMenu.image_menu[index] != "")
      ? Navigator.push(
        context, 
        MaterialPageRoute(
          builder: (context) => DetailFullScreenImage(
            imageUrl: "${ServerBase.serverUrl}${routeMenu.image_menu[index]}"
          ),
        ),
      ) : {},
      child: Padding(
        padding: EdgeInsets.only(left: 5.w,right: 5.w),
        child: imageMenu(index),
      ),
    );

    Widget carouselMenu() => CarouselSlider.builder(
      carouselController: controllerMenu,
      itemBuilder: (context,index,_index) => contentMenu(index),
      itemCount: routeMenu.image_menu.length,
        options: CarouselOptions(
            autoPlay: false,
            onPageChanged: (index, reason) => scrollboard(index),
            disableCenter: false,
            viewportFraction: 1,
            height: ScreenUtil().screenHeight,
            scrollPhysics: const NeverScrollableScrollPhysics(),
        ),
    );

    Widget buttonNavigation(isLeft) => FloatingActionButton(
      onPressed: () => (isLeft) ? controllerMenu!.previousPage() : controllerMenu!.nextPage(),
      child: Icon((isLeft) ? Icons.arrow_left : Icons.arrow_right),
      backgroundColor: ColorsTheme.primary,
    );

    Widget menuView() => Stack(
      children: [
        carouselMenu(),
        Positioned(
          child: buttonNavigation(true),
          bottom: 15.h,
          left: 15.w,
        ),
        Positioned(
          child: buttonNavigation(false),
          bottom: 15.h,
          right: 15.w, 
        )
      ],
    );
    
    return AnnotatedRegion<SystemUiOverlayStyle>(
      child: SafeArea(
        child: Scaffold(
          body: menuView(),
          appBar: PreferredSize(
            child: appbar(), 
            preferredSize: Size.fromHeight(78.h),
          ),
        )
      ),
      value: SystemUiOverlayStyle(statusBarColor: ColorsTheme.primary), 
    );
  }

  scrollboard(value) {
    setState(() {
      _currentPageNotifier.value = value;
      //count = value;
      controllerMenu!.jumpToPage(value);
    });
  }
}