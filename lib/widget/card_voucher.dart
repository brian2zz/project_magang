import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fusia/color/colors_theme.dart';
import 'package:fusia/view/voucher/get_voucher.dart';
import 'package:shimmer/shimmer.dart';

class CardVoucher extends StatelessWidget {
  // final int IdBanner;
  final Map TanggalBerlaku;
  final String TanggalAwal;
  final String TanggalAkhir;
  final String TanggalAwalFormat;
  final String TanggalAkhirFormat;
  final String Banner;
  final int Poin;
  final String formatHargaVoucher;
  final String HargaVoucher;
  final String Keterangan;
  final bool Identity;
  const CardVoucher(
      {Key? key,
      // required this.IdBanner,
      required this.TanggalBerlaku,
      required this.TanggalAwal,
      required this.TanggalAkhir,
      required this.TanggalAwalFormat,
      required this.TanggalAkhirFormat,
      required this.formatHargaVoucher,
      required this.HargaVoucher,
      required this.Banner,
      required this.Identity,
      required this.Keterangan,
      required this.Poin})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    print("Tanggal Awal/Akhir $TanggalAwal / $TanggalAkhir");

    TextStyle boldBlack12 = TextStyle(
      fontFamily: 'Poppins',
      fontSize: 12.sp,
      fontWeight: FontWeight.w600,
      color: Colors.black,
    );

    TextStyle normalBlack10 = TextStyle(
      fontFamily: 'Poppins',
      fontSize: 10.sp,
      fontWeight: FontWeight.normal,
      color: Colors.black,
    );

    TextStyle normalWhite10 = TextStyle(
      fontFamily: 'Poppins',
      fontSize: 10.sp,
      fontWeight: FontWeight.normal,
      color: Colors.white,
    );

    TextStyle boldRed10 = TextStyle(
      fontFamily: 'Poppins',
      fontSize: 10.sp,
      fontWeight: FontWeight.bold,
      color: Colors.red,
    );

    return Container(
      child: GestureDetector(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(
            builder: (context) {
              return getVoucher(
                TanggalBerlaku: TanggalBerlaku,
                TanggalAwal: TanggalAwal,
                TanggalAkhir: TanggalAkhir,
                TanggalAwalFormat: TanggalAwalFormat,
                TanggalAkhirFormat: TanggalAkhirFormat,
                Banner: Banner,
                HargaVoucher: HargaVoucher,
                Poin: Poin,
                Keterangan: Keterangan,
                Identity: Identity,
              );
            },
          ));
        },
        child: Container(
          padding: EdgeInsets.only(left: 20.w, right: 20.w, bottom: 16.h),
          width: 335.w,
          height: 260.h,
          child: Card(
            clipBehavior: Clip.antiAlias,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.h),
            ),
            child: Column(
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Ink.image(
                      image: NetworkImage(Banner),
                      height: 111.h,
                      fit: BoxFit.cover,
                    ),
                    (Identity == true)
                        ? Positioned(
                            top: 82.h,
                            right: 30.8.w,
                            child: Stack(
                              children: [
                                Container(
                                  padding: EdgeInsets.all(8.h),
                                  child: Center(
                                    child: Text(
                                      "${(Poin).toStringAsFixed(0)}\npoint",
                                      textAlign: TextAlign.center,
                                      style: normalWhite10,
                                    ),
                                  ),
                                  width: 56.w,
                                  height: 56.h,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      width: 2.w,
                                      color: Colors.white,
                                      style: BorderStyle.solid,
                                    ),
                                    color: Colors.red,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : Container()
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 16.w, top: 12.h),
                      child: Column(
                        children: [
                          Text('Voucher Rp ${(formatHargaVoucher)}',
                              style: boldBlack12),
                        ],
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: EdgeInsets.only(top: 30.h),
                  child: Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                          left: 16.w,
                        ),
                        child: RichText(
                          text: TextSpan(
                            text: 'Valid until : ',
                            style: normalBlack10,
                            children: <TextSpan>[
                              TextSpan(
                                text: (Identity == true)
                                    ? '${TanggalAkhirFormat}'
                                    : '${TanggalBerlaku[1]}',
                                style: boldRed10,
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 85.w),
                        child: SizedBox(
                          width: 85.w,
                          height: 28.h,
                          child: ElevatedButton(
                            style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Color.fromRGBO(80, 36, 35, 1)),
                                shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(15.h),
                                        side: BorderSide(
                                          color: // color:
                                              Color.fromRGBO(80, 36, 35, 1),
                                        )))),
                            onPressed: () {
                              // Respond to button press
                            },
                            child: Text(
                                'Pakai',
                                style: TextStyle(fontSize: 10.sp)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
