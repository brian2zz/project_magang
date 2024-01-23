import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fusia/widget/custom_appbar_account.dart';

InputDecoration search = InputDecoration(
  prefixIcon: Icon(
    Icons.search_sharp,
    color: Color.fromARGB(255, 144, 152, 177),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: const BorderSide(color: Color.fromARGB(255, 34, 50, 99)),
  ),
  border: new OutlineInputBorder(
      borderSide: new BorderSide(
    color: Color.fromARGB(255, 235, 240, 255),
  )),
  hintText: 'Estimasi Jumlah Tamu',
  hintStyle: TextStyle(
    color: Color.fromARGB(255, 144, 152, 177),
    fontWeight: FontWeight.bold,
    fontFamily: 'Poppins',
  ),
);
TextStyle textFormStyle = TextStyle(
  color: Color.fromRGBO(34, 50, 99, 1),
  fontWeight: FontWeight.bold,
  fontSize: 16.sp,
  fontFamily: 'Poppins',
);
TextStyle textCardStyle1 = TextStyle(
  color: Color.fromRGBO(144, 152, 177, 1),
  fontWeight: FontWeight.w700,
  fontSize: 14.sp,
  fontFamily: 'Poppins',
);
TextStyle textCardStyle2 = TextStyle(
  color: Color.fromRGBO(34, 50, 99, 1),
  fontWeight: FontWeight.w400,
  fontSize: 12.sp,
  fontFamily: 'Poppins',
);
TextStyle textCardStyle3 = TextStyle(
  color: Color.fromRGBO(34, 50, 99, 1),
  fontWeight: FontWeight.w400,
  fontSize: 12.sp,
  fontFamily: 'Poppins',
);

class OutletList extends StatelessWidget {
  const OutletList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(title: 'Avalaible Outlets In Your Location'),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
            child: SizedBox(
              height: 100.h,
              child: TextFormField(
                decoration: search,
                // controller: _jumlahOrangController,
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly,
                ],
                style: textFormStyle,
              ),
            ),
          ),
          Card(
            child: Container(
              height: 100,
              padding: EdgeInsets.only(left: 40.w, right: 20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        height: 35.h,
                        width: 35.w,
                        child:
                            Image.asset('assets/images/logo_onboarding_2.png'),
                      ),
                      SizedBox(height: 10.h),
                      Container(
                        child: Text('Gandaria City', style: textCardStyle1),
                      )
                    ],
                  ),
                  SizedBox(height: 10.h),
                  Container(
                      padding: EdgeInsets.only(left: 35.w),
                      child: Text('1901 Thornridge Cir. Shiloh, Hawaii 81063',
                          style: textCardStyle2)),
                  SizedBox(height: 10.h),
                  Container(
                      padding: EdgeInsets.only(left: 35.w),
                      child: Text('021-12345678', style: textCardStyle3)),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
