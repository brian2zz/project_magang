import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fusia/view/voucher/voucher_page.dart';
import 'package:fusia/view/voucher/sukses.dart';
import 'package:fusia/widget/custom_appbar_account.dart';

class pembayaran extends StatelessWidget {
  final Map TanggalBerlaku;

  final String Banner;
  final int Poin;
  final String Keterangan;
  final String HargaVoucher;
  final bool Identity;
  final String TanggalAkhir;

  const pembayaran({
    Key? key,
    required this.TanggalBerlaku,
    required this.TanggalAkhir,
    required this.HargaVoucher,
    required this.Banner,
    required this.Keterangan,
    required this.Poin,
    required this.Identity,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget _VoucherDetail() => Container(
          height: 150.h,
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Card(
            // elevation: 5,
            margin: EdgeInsets.all(10.h),
            semanticContainer: true,
            clipBehavior: Clip.antiAliasWithSaveLayer,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.h),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(left: 14.w),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10.h),
                    child: Ink.image(
                      image: NetworkImage(Banner),
                      height: 100.h,
                      width: 130.w,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    left: 10.w,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 17.h),
                        child: Text(
                          "Kampoeng Timbel",
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.normal,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 4.h),
                        child: Text(
                          "Voucher Rp $HargaVoucher",
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        (Identity == true)
                            ? "Valid until ${TanggalAkhir}"
                            : "${TanggalBerlaku[1]}",
                        style: TextStyle(
                          fontSize: 7.sp,
                          fontWeight: FontWeight.normal,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        "$Poin pts",
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      IncrementDecrement(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );

    Widget _PointBar() => Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          height: 65.h,
          decoration: BoxDecoration(color: Color.fromRGBO(80, 36, 35, 1)),
          child: Row(children: [
            Text("Your Points Now", style: TextStyle(color: Colors.white)),
            Container(
              padding: EdgeInsets.only(left: 110.w),
              child: Stack(
                children: [
                  Container(
                    // padding: EdgeInsets.only(right: 20.w),
                    height: 40.h,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(36.h))),
                    width: 100.w,
                    child: Row(
                      children: [
                        SizedBox(
                          width: 10.w,
                        ),
                        Image.asset("assets/icons/ic_point.png"),
                        SizedBox(width: 10.w),
                        RichText(
                          text: TextSpan(
                            text: '15',
                            style: TextStyle(
                                fontSize: 15.sp,
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                            children: const <TextSpan>[
                              TextSpan(
                                  text: ' pts',
                                  style: TextStyle(
                                    fontWeight: FontWeight.normal,
                                    color: Colors.black,
                                    fontSize: 12,
                                  )),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ]),
        );
    Widget _Point() => Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Total points :"),
              Text("0 pts"),
            ],
          ),
        );

    Widget _AmbilVoucherButton() => Container(
          height: 50.h,
          width: 500.w,
          margin: EdgeInsets.only(left: 16.0.w, right: 16.w, bottom: 30.h),
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
              Navigator.push(context, MaterialPageRoute(
                builder: (context) {
                  return Sukses();
                },
              ));
            },
            child: Text('Ambil Voucher',
                style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold)),
          ),
        );

    return Scaffold(
      appBar: appBar(
          title: "Voucher to be Claimed",
          // press: () {
          //   Navigator.pop(context);
          // }
          ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _PointBar(),
          SizedBox(height: 20.h),
          Container(
            padding: EdgeInsets.only(left: 16.w),
            child: Text("Voucher Details",
                style: TextStyle(
                  fontSize: 16,
                )),
          ),
          SizedBox(height: 16.h),
          _VoucherDetail(),
          Container(
              margin: EdgeInsets.only(top: 22.h),
              width: 380.w,
              height: 2.h,
              decoration: BoxDecoration(color: Colors.grey[200])),
          SizedBox(height: 16.h),
          _Point(),
          SizedBox(height: 167.h),
          _AmbilVoucherButton()
        ],
      ),
    );
  }
}

class IncrementDecrement extends StatefulWidget {
  IncrementDecrement({Key? key}) : super(key: key);

  @override
  State<IncrementDecrement> createState() => _IncrementDecrementState();
}

class _IncrementDecrementState extends State<IncrementDecrement> {
  @override
  int counter = 0;
  Widget build(BuildContext context) {
    return Container(
      child: Container(
        padding: EdgeInsets.only(left: 50.w),
        child: Container(
          // padding:
          //     EdgeInsets.symmetric(horizontal: 20, vertical: 2),
          height: 20.h,
          decoration: BoxDecoration(
            border:
                Border.all(width: 1.w, color: Color.fromRGBO(80, 36, 35, 1)),
            borderRadius: BorderRadius.circular(5.h),
          ),
          child: Row(
            children: [
              InkWell(
                  onTap: () {
                    (counter >= 1)
                        ? setState(() {
                            counter--;
                          })
                        : null;
                  },
                  child: Container(
                    height: 20.h,
                    padding: EdgeInsets.symmetric(horizontal: 5),
                    child: Icon(
                      Icons.remove,
                      color: Colors.black,
                      size: 10,
                    ),
                  )),
              Container(
                height: 20.h,
                padding: EdgeInsets.symmetric(horizontal: 15.w),
                // margin: EdgeInsets.symmetric(horizontal: 3),
                decoration: BoxDecoration(
                  border: Border(
                    right: BorderSide(width: 1.w, color: Colors.black),
                    left: BorderSide(width: 1.w, color: Colors.black),
                  ),
                  // borderRadius: BorderRadius.circular(10),
                ),

                child: Center(
                  child: Text(
                    "$counter",
                    style: TextStyle(color: Colors.black, fontSize: 12.sp),
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  setState(() {
                    counter++;
                  });
                },
                child: Container(
                  height: 20,
                  padding: EdgeInsets.symmetric(horizontal: 5.w),
                  child: Icon(
                    Icons.add,
                    color: Colors.black,
                    size: 10.sp,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
