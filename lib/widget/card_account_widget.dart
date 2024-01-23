import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fusia/color/colors_theme.dart';

class BuildCardMember extends StatelessWidget {
  final String name;
  final double point;

  const BuildCardMember({Key? key, required this.name, required this.point})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10.h),
      child: Column(
        children: [
          (point >= 0 && point <= 125)
              ? CardMember(
                  point: point,
                  name: name,
                  tier: 'Bronze',
                  medal: const AssetImage('assets/icons/ic_bronze_medal.png'),
                  color: const LinearGradient(
                      colors: [Color(0xFFDEC598), Color(0xFFBC9B68)]),
                )
              : (point > 125 && point <= 250)
                  ? CardMember(
                      point: point,
                      name: name,
                      tier: 'Gold',
                      medal: const AssetImage('assets/icons/ic_gold_medal.png'),
                      color: const LinearGradient(colors: [
                        Color.fromARGB(255, 254, 201, 25),
                        Color.fromARGB(255, 228, 161, 18),
                      ]),
                    )
                  : (point > 250 && point <= 375)
                      ? CardMember(
                          point: point,
                          name: name,
                          tier: 'Platinum',
                          medal: const AssetImage('assets/icons/ic_silver_medal.png'),
                          color: const LinearGradient(colors: [
                            Color.fromARGB(255, 166, 166, 166),
                            Color.fromARGB(255, 108, 108, 108),
                          ]),
                        )
                      : CardMember(
                          point: point,
                          name: name,
                          tier: "Vvip",
                          medal: const AssetImage('assets/icons/ic_vvip_trophy.png'),
                          color: const LinearGradient(colors: [
                            Color.fromARGB(255, 152, 144, 227),
                            Color.fromARGB(255, 177, 244, 207),
                          ]),
                        ),
        ],
      ),
    );
  }
}

class CardMember extends StatelessWidget {
  const CardMember({
    Key? key,
    required this.point,
    required this.name,
    required this.tier,
    required this.color,
    required this.medal,
  }) : super(key: key);

  final AssetImage medal;
  final double point;
  final String name;
  final String tier;
  final Gradient color;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 192.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0.r),
        gradient: color,
      ),
      child: Stack(
        children: <Widget>[
          LayerComponentCard2(),
          LayerComponentCard1(),
        ],
      ),
    );
  }

  Widget LayerComponentCard2() => Transform.translate(
        offset: const Offset(30, 0.0),
        child: Stack(
          children: <Widget>[
            Positioned(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    tier,
                    style: TextStyle(
                        color: Colors.brown.shade600,
                        fontSize: 16.sp,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w900),
                  ),
                  SizedBox(height: 6.h),
                  Text(
                    '${(point).toStringAsFixed(0)} pts',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 12.sp,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w900),
                  ),
                ],
              ),
              left: 0.w,
              top: 24.h,
            ),
            Positioned(
              child: SizedBox(
                height: 37.h,
                width: 37.w,
                child: FittedBox(
                  fit: BoxFit.cover,
                  child: Image(
                    image: medal,
                  ),
                ),
              ),
              right: 56.w,
              top: 24.h,
            ),
            Positioned(
              child: Text(
                name,
                style: TextStyle(
                    color: ColorsTheme.whiteCream,
                    fontSize: 14.sp,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w700),
              ),
              bottom: 19.h,
              left: 0.w,
            ),
          ],
        ),
      );

  Widget LayerComponentCard1() => Positioned(
        child: Transform.translate(
          offset: const Offset(-30, 0.0),
          child: SizedBox(
            width: 120.w,
            height: 145.h,
            child: FittedBox(
              fit: BoxFit.cover,
              child: Opacity(
                opacity: 0.3,
                child: Image.asset('assets/images/mascot.png'),
              ),
            ),
          ),
        ),
        right: -29.w,
        bottom: -38.h,
      );
}
