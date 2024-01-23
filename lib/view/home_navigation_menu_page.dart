import 'package:flutter/material.dart';
import 'package:fusia/view/account/account_page.dart';
//import 'package:fusia/view/outlet/outlet_page.dart';
import 'package:fusia/view/promo/promo_page.dart';
import 'package:fusia/widget/custom_toast.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../color/colors_theme.dart';
import 'home_dashboard_page.dart';
import 'outlet/outlet_page.dart';

class HomeNavigationMenu extends StatefulWidget {
  const HomeNavigationMenu({Key? key}) : super(key: key);

  @override
  _HomeNavigationMenu createState() => _HomeNavigationMenu();
}

class _HomeNavigationMenu extends State<HomeNavigationMenu> {
  DateTime? currentBackPressedTime;
  static const backPressedDuration = Duration(seconds: 2);
  var selectedIndex = 0.obs;
  var data = false.obs;

  TextStyle menuTextStyle(isSelectable) => TextStyle(
        fontFamily: 'Poppins',
        fontSize: 10.sp,
        fontWeight: (isSelectable) ? FontWeight.w700 : FontWeight.w400,
        color: ColorsTheme.black,
      );

  @override
  Widget build(BuildContext context) {
    
    Widget navigationMenu() {
      return Obx(
          () => WillPopScope(
            child: (selectedIndex.value == 0)
                ? const HomeDashboardPage()
                : (selectedIndex.value == 1)
                    ? const PromoPage()
                    : (selectedIndex.value == 2)
                        ? const RewardPage()
                        : const AccountPage(),
            onWillPop: onBackPressed,
          ),
        );
    }

    Widget itemNavigation(index, status) => Expanded(
          child: SizedBox(
            height: 60.h,
            child: InkWell(
              onTap: () => moveToMenu(index),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: 20.w,
                    height: 20.h,
                    child: FittedBox(
                      fit: BoxFit.cover,
                      child: Image.asset(
                        (status == "home")
                            ? 'assets/icons/ic_menu_home.png'
                            : (status == "promo")
                                ? 'assets/icons/ic_menu_promo.png'
                                : (status == "reward")
                                    ? 'assets/icons/ic_menu_reward.png'
                                    : 'assets/icons/ic_menu_account.png',
                        color: (selectedIndex.value == index)
                            ? ColorsTheme.primary
                            : ColorsTheme.neutralGrey,
                      ),
                    ),
                  ),
                  SizedBox(height: 9.h),
                  Text(
                    (status == "home")
                        ? "Home"
                        : (status == "promo")
                            ? "Promo"
                            : (status == "reward")
                                ? "Outlets"
                                : "Account",
                    style: (selectedIndex.value == index)
                        ? menuTextStyle(true)
                        : menuTextStyle(false),
                  ),
                ],
              ),
            ),
          ),
        );

    Widget fabItem() => Expanded(
          child: SizedBox(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: 29.h),
                  Text("Reservation", style: menuTextStyle(false)),
                ]),
          ),
        );

    List<Widget> items = List.generate(4, (index) {
      if (index == 0) {
        return itemNavigation(index, "home");
      } else if (index == 1) {
        return itemNavigation(index, "promo");
      } else if (index == 2) {
        return itemNavigation(index, "reward");
      } else {
        return itemNavigation(index, "account");
      }
    });
    items.insert(4 >> 1, fabItem());

    return Scaffold(
      body: navigationMenu(),
      floatingActionButton: SizedBox(
        height: 58.h,
        width: 58.w,
        child: FloatingActionButton(
          onPressed: () => Navigator.pushNamed(context, '/reservation'),
          child: Icon(Icons.add, color: ColorsTheme.white),
          backgroundColor: ColorsTheme.primary,
          shape: CircleBorder(
            side: BorderSide(color: ColorsTheme.neutralGrey!, width: 2.h),
          ),
          elevation: 0.h,
        ),
      ),
      resizeToAvoidBottomInset: false,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: EdgeInsets.only(top: 2.h),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: items,
          ),
        ),
        color: ColorsTheme.white,
      ),
    );
  }

  moveToMenu(index) {
    setState(() {
      selectedIndex.value = index;
    });
  }

  Future<bool> onBackPressed() async {
    final now = DateTime.now();

    if (currentBackPressedTime == null ||
        now.difference(currentBackPressedTime!) > backPressedDuration) {
      setState(() {
        currentBackPressedTime = now;
      });

      var snackbar = const SnackBar(content: Text("Tekan sekali lagi untuk keluar..."),behavior: SnackBarBehavior.floating);
      ScaffoldMessenger.of(context).showSnackBar(snackbar);

      return Future.value(false);
    }
    return Future.value(true);
  }
}
