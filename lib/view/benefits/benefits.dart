import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fusia/widget/custom_appbar_account.dart';

class BenefitPage extends StatefulWidget {
  const BenefitPage({Key? key}) : super(key: key);

  @override
  State<BenefitPage> createState() => _BenefitPageState();
}

class _BenefitPageState extends State<BenefitPage> {
  TextStyle header1 = TextStyle(
    fontFamily: 'Poppins',
    fontSize: 16.sp,
    color: Colors.black,
    fontWeight: FontWeight.w500,
  );

  TextStyle header2 = TextStyle(
    fontFamily: 'Poppins',
    fontSize: 14.sp,
    color: Colors.black,
    fontWeight: FontWeight.w600,
  );

  TextStyle body1 = TextStyle(
    fontFamily: 'Poppins',
    fontSize: 12.sp,
    color: Color.fromRGBO(109, 109, 109, 1),
    fontWeight: FontWeight.w200,
  );

  @override
  Widget build(BuildContext context) {
    Widget _Body() => Container(
          child: ListView(children: [
            SizedBox(
              height: 32,
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                "Ini yang kamu dapatkan jika \nbergabung menjadi membership kami",
                style: header1,
                textAlign: TextAlign.center,
              ),
            ),
            _ListBenefit(
                header2: header2,
                body1: body1,
                judul: "Point Rewards",
                isi:
                    "Purus scelerisque arcu convallis sit\nornare. Vel aliquet est nisi, bibendum "),
            _ListBenefit(
                header2: header2,
                body1: body1,
                judul: "Food Delivery",
                isi:
                    "Purus scelerisque arcu convallis sit\nornare. Vel aliquet est nisi, bibendum "),
            _ListBenefit(
                header2: header2,
                body1: body1,
                judul: "Birthday Gift",
                isi:
                    "Purus scelerisque arcu convallis sit\nornare. Vel aliquet est nisi, bibendum "),
            _ListBenefit(
                header2: header2,
                body1: body1,
                judul: "Voucher",
                isi:
                    "Purus scelerisque arcu convallis sit\nornare. Vel aliquet est nisi, bibendum "),
            _ListBenefit(
                header2: header2,
                body1: body1,
                judul: "Reservation",
                isi:
                    "Purus scelerisque arcu convallis sit\nornare. Vel aliquet est nisi, bibendum "),
            _ListBenefit(
                header2: header2,
                body1: body1,
                judul: "Priority Queue",
                isi:
                    "Purus scelerisque arcu convallis sit\nornare. Vel aliquet est nisi, bibendum "),
            _ListBenefit(
                header2: header2,
                body1: body1,
                judul: "E-Order",
                isi:
                    "Purus scelerisque arcu convallis sit\nornare. Vel aliquet est nisi, bibendum "),
          ]),
        );
    return Scaffold(
      appBar: appBar(
        title: "Benefits",
        // press: () {
        //     Navigator.pushReplacementNamed(context, '/account');
        //   }
      ),
      body: _Body(),
    );
  }
}

class _ListBenefit extends StatelessWidget {
  const _ListBenefit({
    Key? key,
    required this.header2,
    required this.judul,
    required this.isi,
    required this.body1,
  }) : super(key: key);

  final TextStyle header2;
  final TextStyle body1;
  final String judul;
  final String isi;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.only(top: 32, right: 30, left: 30, bottom: 10),
          child: Row(
            children: [
              Container(
                child: Icon(
                  Icons.room_service_outlined,
                  color: Colors.white,
                  size: 30,
                ),
                width: 56.w,
                height: 56.h,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color.fromRGBO(80, 36, 35, 1),
                ),
              ),
              Container(
                padding: EdgeInsets.only(left: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(judul, style: header2),
                    Text(isi, style: body1),
                  ],
                ),
              )
            ],
          ),
        ),
        Divider(
          color: Colors.grey[400],
          height: 10,
        ),
      ],
    );
  }
}
