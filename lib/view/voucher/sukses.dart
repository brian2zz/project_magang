import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fusia/view/voucher/pembayaran.dart';
import 'package:fusia/view/voucher/voucher_page.dart';

class Sukses extends StatefulWidget {
  Sukses({Key? key}) : super(key: key);

  @override
  State<Sukses> createState() => _SuksesState();
}

class _SuksesState extends State<Sukses> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // SizedBox(height: 200.h),
          SizedBox(height: 40.h),
          Center(
            child: Icon(
              Icons.check_circle_rounded,
              size: 100.sp,
              color: Colors.green,
            ),
          ),
          Center(
              child: Text(
            "Success",
            style: TextStyle(
                color: Color.fromRGBO(34, 50, 99, 1),
                fontSize: 30.sp,
                fontWeight: FontWeight.bold),
          )),
          Center(child: Text("See you at our outlets")),
          SizedBox(height: 80.h),
          Container(
            margin: EdgeInsets.all(16),
            child: SizedBox(
              width: 500.w,
              height: 50.h,
              child: ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        Color.fromRGBO(80, 36, 35, 1)),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.h),
                            side: BorderSide(
                              color: // color:
                                  Color.fromRGBO(80, 36, 35, 1),
                            )))),
                onPressed: () {
                  //   Navigator.pushReplacement(context, MaterialPageRoute(
                  //     builder: (context) {
                  //       return VoucherPage();
                  //     },
                  //   ));
                  // },
                  Navigator.popUntil(context, ModalRoute.withName('/vouchers'));
                },
                child: Text('See My Voucher',
                    style: TextStyle(
                        fontSize: 14.sp, fontWeight: FontWeight.bold)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
