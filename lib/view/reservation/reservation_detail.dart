import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fusia/view/home_dashboard_page.dart';
import 'package:fusia/view/home_navigation_menu_page.dart';
import 'package:fusia/view/voucher/get_voucher.dart';
import 'package:fusia/widget/custom_appbar_account.dart';

TextStyle LabelStyle = TextStyle(
  color: Color.fromARGB(255, 144, 152, 177),
  fontSize: 10.sp,
  fontWeight: FontWeight.bold,
);
TextStyle Text1 = TextStyle(
  color: Colors.black,
  fontSize: 12.sp,
  fontWeight: FontWeight.bold,
);
TextStyle Text2 = TextStyle(
  color: Colors.black,
  fontSize: 16.sp,
  fontWeight: FontWeight.bold,
);

class reservationDetail extends StatelessWidget {
  final String Tanggal;
  final String Waktu;
  final String JumlahOrang;
  final String Keterangan;
  // final String Nama;
  // final int Tamu;
  // final String Durasi;
  // final String Keterangan;
  // final String NamaRestaurant;
  // final String AlamatRestaurant;
  // final String NomorRestaurant;

  const reservationDetail({
    Key? key,
    // required this.IdBanner,
    required this.Tanggal,
    required this.Waktu,
    required this.JumlahOrang,
    required this.Keterangan,
    //     required this.Tamu,
    //     required this.Durasi,
    //     required this.Keterangan,
    //     required this.NamaRestaurant,
    //     required this.AlamatRestaurant,
    //     required this.NomorRestaurant
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(title: 'Reservation Details'),
      body: _body(),
      bottomNavigationBar: _buttonBack(context),
    );
  }

  Padding _buttonBack(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
      child: SizedBox(
        height: 60.h,
        width: double.infinity,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(5),
          child: RaisedButton(
            padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 40.w),
            color: Color.fromARGB(255, 80, 36, 35),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(
                builder: (context) {
                  return HomeNavigationMenu()
                  ;
                },
              ));
            },
            child: Text(
              'Back To Menu',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14.sp,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _body() => Container(
        child: Column(
          children: [
            new SingleChildScrollView(
              padding: EdgeInsets.only(left: 20.w, right: 20.w, top: 20.h),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _detailDateTime(),
                  SizedBox(height: 40.h),
                  Divider(color: Color.fromARGB(255, 218, 218, 218)),
                  SizedBox(height: 20.h),
                  _personalDetail(),
                  SizedBox(height: 20.h),
                  Divider(color: Color.fromARGB(255, 218, 218, 218)),
                  SizedBox(height: 20.h),
                  _detailRestaurant(),
                ],
              ),
            ),
          ],
        ),
      );

  Widget _detailRestaurant() => Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Restaurant Details', style: Text2),
          SizedBox(height: 10.h),
          Row(children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.asset(
                'assets/images/logo_onboarding_2.png',
                height: 50.0.h,
                width: 70.0.w,
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Gandaria City',
                  style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 34, 50, 99)),
                ),
                Text(
                  '1901 Thornridge Cir. Shiloh, Hawaii 81063',
                  style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 144, 152, 177)),
                ),
                Text(
                  '021-12345678',
                  style: TextStyle(
                      fontSize: 12.sp, color: Color.fromARGB(255, 34, 50, 99)),
                ),
              ],
            ),
          ]),
          SizedBox(height: 20.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.location_on,
                    color: Color.fromARGB(255, 111, 111, 112),
                  ),
                  SizedBox(width: 10.h),
                  Text('Open Map',
                      style: TextStyle(
                        fontSize: 13.sp,
                        color: Color.fromARGB(255, 111, 111, 112),
                      )),
                ],
              ),
              Row(
                children: [
                  Icon(
                    Icons.call_outlined,
                    color: Color.fromARGB(255, 111, 111, 112),
                  ),
                  SizedBox(width: 10.h),
                  Text('Call',
                      style: TextStyle(
                        fontSize: 13.sp,
                        color: Color.fromARGB(255, 111, 111, 112),
                      )),
                ],
              ),
            ],
          ),
          SizedBox(height: 20.h),
        ],
      );

  Widget _personalDetail() => Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Personal Details', style: Text2),
          SizedBox(height: 30.h),
          Row(children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Nama', style: LabelStyle),
                SizedBox(height: 10.h),
                Text('Jono Maximum', style: Text1),
              ],
            ),
            Spacer(),
            Column(
              children: [
                Text('Tamu', style: LabelStyle),
                SizedBox(height: 10.h),
                Text("$JumlahOrang", style: Text1),
              ],
            ),
            Spacer(),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text('Durasi', style: LabelStyle),
                SizedBox(height: 10.h),
                Text('90 Menit', style: Text1),
              ],
            ),
          ]),
          SizedBox(height: 30.h),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Keterangan', style: LabelStyle),
              SizedBox(height: 10.h),
              Text("$Keterangan", style: Text1),
            ],
          ),
        ],
      );

  Widget _detailDateTime() => Row(children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Date', style: LabelStyle),
            SizedBox(height: 10.h),
            Row(
              children: [
                Icon(
                  Icons.date_range_outlined,
                  color: Color.fromARGB(255, 144, 152, 177),
                ),
                SizedBox(width: 10.h),
                Text('$Tanggal', style: Text1),
              ],
            ),
          ],
        ),
        Spacer(),
        Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text('Pukul', style: LabelStyle),
            SizedBox(height: 10.h),
            Row(
              children: [
                Icon(
                  Icons.access_time,
                  color: Color.fromARGB(255, 144, 152, 177),
                ),
                SizedBox(width: 10.h),
                Text('$Waktu', style: Text1),
              ],
            ),
          ],
        )
      ]);
}
