// import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fusia/color/colors_theme.dart';
import 'package:fusia/controller/dashboard_controller.dart';
import 'package:fusia/controller/login_controller.dart';
import 'package:fusia/controller/reservation_controller.dart';
import 'package:fusia/view/account/change_password_page.dart';
import 'package:fusia/view/outlet/outlet_page.dart';
import 'package:fusia/view/reservation/outlet_list.dart';
import 'package:fusia/view/reservation/reservation_detail.dart';
import 'package:fusia/widget/custom_appbar.dart';
import 'package:fusia/widget/custom_appbar_account.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:searchfield/searchfield.dart';

class Reservation extends StatefulWidget {
  const Reservation({Key? key}) : super(key: key);

  @override
  _ReservationState createState() => _ReservationState();
}

class Order {
  String? makanan;
  int? jumlahPesanan;
  Order(this.makanan, this.jumlahPesanan);
  @override
  String toString() {
    return '{ ${this.makanan}, ${this.jumlahPesanan} }';
  }
}

String? _chosenValue;

class _ReservationState extends State<Reservation> {

  InputDecoration tamu = InputDecoration(
  prefixIcon: Icon(
    Icons.person_outline,
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

  InputDecoration outlet = InputDecoration(
    prefixIcon: Icon(
      Icons.place_outlined,
      color: Color.fromARGB(255, 144, 152, 177),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: const BorderSide(color: Color.fromARGB(255, 34, 50, 99)),
    ),
    border: new OutlineInputBorder(
        borderSide: new BorderSide(
      color: Color.fromARGB(255, 235, 240, 255),
    )),
    hintText: 'Outlet',
    hintStyle: TextStyle(
      color: Color.fromARGB(255, 144, 152, 177),
      fontWeight: FontWeight.bold,
      fontFamily: 'Poppins',
    ),
  );

  TextStyle textFormStyle = TextStyle(
    color: Color.fromARGB(255, 2, 2, 2),
    fontWeight: FontWeight.bold,
    fontSize: 16.sp,
    fontFamily: 'Poppins',
  );

  TextStyle dialogHeaderTextStyle = TextStyle(
    fontFamily: 'Poppins',
    fontSize: 16.sp,
    fontWeight: FontWeight.bold,
    color: ColorsTheme.neutralDark,
  );


  DateTime? date;
  TimeOfDay? time;
  LoginController? userController;
  DashboardController? dashboardController;
  ReservationController? reservationController;
  // MenuController? menuController;
  int value = 1;
  // List<String>? menu;

  //future
  Future? _loadData;

  List<String> duration = [
    "30 Menit",
    "60 Menit",
    "90 Menit",
    "120 Menit",
  ];

  List<Order> orderList = [];
  var fruits = ['Apple', 'Banana', 'Mango', 'Orange'];
  var userToken;
  var customerId;

  var produkId, satuanId, produkNama, satuanKode;

  var tanggal, waktu, jumlahOrang, keterangan, pesanan, jumlahPesanan;
  final TextEditingController _jumlahOrangController = TextEditingController();
  final TextEditingController _outletController = TextEditingController();
  final TextEditingController _keteranganController = TextEditingController();
  final TextEditingController _pesananController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  final _searchController = TextEditingController();

  TextStyle textFormTextStyle = TextStyle(
    fontFamily: 'Poppins',
    fontSize: 12.sp,
    fontWeight: FontWeight.w400,
    color: ColorsTheme.neutralDark,
  );

  initState() {
    super.initState();

    initConstructor();
    initData();
  }

  initConstructor() {
    userController = Get.put(LoginController());
    dashboardController = Get.put(DashboardController());
    reservationController = Get.put(ReservationController());
    reservationController = Get.put(ReservationController());

    userToken = "".obs;
    customerId = "".obs;

    tanggal = "".obs;
    waktu = "".obs;
    jumlahOrang = "".obs;
    keterangan = "".obs;
    pesanan = "".obs;
    jumlahPesanan = "".obs;

    // produkId = "".obs;
    // satuanId = "".obs;
    // produkNama = "".obs;
    // satuanKode = "".obs;
  }

  initData() async {
    await userController!.retrieveUserLocalData();

    var token = LoginController.userToken.value;
    var customerId = LoginController.customerId.value;

  }

  /*loadMenu() async {
    await userController!.retrieveUserLocalData();

    var token = LoginController.userToken.value;
    var customerId = LoginController.customerId.value;
    var result = await reservationController!.retrieveMenuList(token, customerId);
    return (result['details']);
  }*/

  // loadVoucher() async {
  //   await userController!.retrieveUserLocalData();
  //   var token = LoginController.userToken.value;
  //   var customerId = LoginController.customerId.value;
  //   var result = await voucherController!.retrieveVouchers(token, customerId);
  //   return (result['details']);
  // }

  initReservation(token,customerId) async {
    await userController!.retrieveUserLocalData();

    setState(() {
      
      tanggal.value = dateReservation();
      waktu.value = timeReservation();
      jumlahOrang.value = _jumlahOrangController.text;
      keterangan.value = _keteranganController.text;
      pesanan.value = _pesananController.text;
      jumlahPesanan = value;

      /*PostReservation(token, customerId, tanggal.value, waktu.value,
          jumlahOrang.value, keterangan.value);*/
    });
  }

  PostReservation(token, customerId, tanggal, waktu, jumlahTamu, keterangan) async {
    Map<String, dynamic> paramsdata = {
      "token": token,
      "customerId": customerId,
      "tanggal": tanggal,
      "waktu": waktu,
      "jumlahTamu": jumlahTamu,
      "keterangan": keterangan,
      // "durasi": durasi,
    };
    // print(paramsdata);

    var result = await reservationController!.SendReservation(paramsdata);

    print(result['details']);
    setState(() {
      if (result['status'] == 200) {
        print("Success");
        print(tanggal);
      } else {
        print("Failed");
      }
    });
  }

  String dateReservation() {
    if (date == null) {
      return '';
    } else {
      var bulan;
      if (date?.month == 1) {
        bulan = "Januari";
      } else if (date?.month == 2) {
        bulan = "Februari";
      } else if (date?.month == 3) {
        bulan = "Maret";
      } else if (date?.month == 4) {
        bulan = "April";
      } else if (date?.month == 5) {
        bulan = "Mei";
      } else if (date?.month == 6) {
        bulan = "Juni";
      } else if (date?.month == 7) {
        bulan = "Juli";
      } else if (date?.month == 8) {
        bulan = "Agustus";
      } else if (date?.month == 9) {
        bulan = "September";
      } else if (date?.month == 10) {
        bulan = "Oktober";
      } else if (date?.month == 11) {
        bulan = "November";
      } else if (date?.month == 12) {
        bulan = "Desember";
      }

      var hari = DateFormat('dd').format(date!);
      var tahun = DateFormat('yyyy').format(date!);
      return '${hari} ${bulan} ${tahun}';
    }
  }

  String timeReservation() {
    if (time == null) {
      return '';
    } else if (time!.minute < 10) {
      return '${time!.hour}:0${time!.minute} WIB';
    } else {
      return '${time!.hour}:${time!.minute} WIB';
    }
  }

  @override
  Widget build(BuildContext context) {
    
    // orderList.add(Order("kue", 2));
    // orderList.add(Order("kua", 10));
    // print(orderList);
    // print(orderList[0].makanan);

    Widget appbar() => CustomAppBar(
      title: "Reservation",
      secondtitle: "",
      isAccessDetail: true,
      isNeedTwoLines: false
    );

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(72.h),
        child: appbar(),
      ),
      body: _body(context),
      bottomNavigationBar: _makeReservationButton(),
    );
  }

  Widget _makeReservationButton() => Padding(
    padding: EdgeInsets.only(left: 20.w, right: 20.w, bottom: 10.h),
    child: SizedBox(
      height: 60.h,
      width: double.infinity,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(5),
        child: RaisedButton(
          padding: EdgeInsets.symmetric(vertical: 20.w, horizontal: 40.h),
          color: Color.fromARGB(255, 80, 36, 35),
          onPressed: () {
            Navigator.pushReplacement(context, MaterialPageRoute(
              builder: (context) {
                return reservationDetail(
                  Tanggal: tanggal.toString(),
                  Waktu: waktu.toString(),
                  JumlahOrang: jumlahOrang.toString(),
                  Keterangan: keterangan.toString(),
                );
              },
            ));
          },
          child: Text(
            'Make Reservation',
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

  Widget _body(BuildContext context) => SingleChildScrollView(
    padding: EdgeInsets.symmetric(horizontal: 20.w),
    child: _formReservation(context),
  );

  Widget _formReservation(BuildContext context) {
    
    void _incrementCounter() {
      setState(() {
        value++;
      });
    }

    void _decrementCounter() {
      setState(() {
        value--;
      });
    }

    Widget space(height) => SizedBox(height: height);

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        space(60.h),
        FormDateTime(
          press: () => pickDate(context),
          text: dateReservation(),
          icon: Icons.date_range_outlined,
          hint: 'Tanggal',
        ),
        space(10.h),
        FormDateTime(
          press: () => pickTime(context),
          text: timeReservation(),
          icon: Icons.access_time,
          hint: 'Pukul',
        ),
        space(10.h),
        _formDuration(),
        space(10.h),
        _formGuest(),
        space(10.h),
        _formOutlet(),
        space(50.h),
        Text(
          'Menu',
          style: textFormStyle,
        ),
        space(20.h),
        _formMenu(),
        space(20.h),
        _quantity(_decrementCounter, _incrementCounter),
        space(20.h),
        _formDescription(),
        space(20.h),
      ],
    );
  }

  Widget _quantity(_decrementCounter,_incrementCounter) => Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(
        'QTY',
        style: textFormStyle,
      ),
      Container(
        height: 35.h,
        width: 120.w,
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 80, 36, 35),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            InkWell(
              onTap: (value > 0) ? _decrementCounter : null,
              child: Container(
                  height: 35.h,
                  width: 40.w,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Icon(Icons.remove)),
            ),
            Text('${value}', style: TextStyle(color: Colors.white)),
            InkWell(
              onTap: _incrementCounter,
              child: Container(
                  height: 35.h,
                  width: 40.w,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Icon(Icons.add)),
            ),
          ],
        ),
      ),
    ],
  );

  Widget _formDescription() => TextFormField(
        controller: _keteranganController,
        decoration: const InputDecoration(
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Color.fromARGB(255, 34, 50, 99)),
          ),
          border: OutlineInputBorder(
              borderSide: BorderSide(
            color: Color.fromARGB(255, 235, 240, 255),
          )),
          hintText: 'Keterangan',
          hintStyle: TextStyle(
            color: Color.fromARGB(255, 144, 152, 177),
            fontWeight: FontWeight.bold,
            fontFamily: 'Poppins',
          ),
        ),
        minLines: 10,
        keyboardType: TextInputType.multiline,
        maxLines: null,
      );

  Widget _formDuration() => DropdownButtonFormField(
        decoration: InputDecoration(
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Color.fromARGB(255, 34, 50, 99)),
            ),
            border: const OutlineInputBorder(
                borderSide: BorderSide(
              color: Color.fromARGB(255, 235, 240, 255),
            )),
            hintText: 'Durasi',
            hintStyle: TextStyle(
              color: Color.fromARGB(255, 144, 152, 177),
              fontWeight: FontWeight.bold,
              fontFamily: 'Poppins',
              fontSize: 16.sp,
            )),
        value: _chosenValue,
        onChanged: (String? Value) {
          setState(() {
            _chosenValue = Value;
            //print(_chosenValue);
          });
        },
        items: duration
            .map((cityTitle) =>
                DropdownMenuItem(value: cityTitle, child: Text("$cityTitle")))
            .toList(),
      );

  Widget _formMenu() => Form(
      key: _formKey,
      child: SearchField(
        controller: _pesananController,
        suggestions: fruits.map((e) => SearchFieldListItem(e)).toList(),
        suggestionState: Suggestion.expand,
        textInputAction: TextInputAction.next,
        // hint: 'SearchField Example 2',
        hasOverlay: false,
        searchStyle: TextStyle(
          fontSize: 18,
          color: Colors.black.withOpacity(0.8),
        ),
        validator: (x) {
          if (!fruits.contains(x) || x!.isEmpty) {
            return 'Please Enter a valid State';
          }
          return null;
        },
        searchInputDecoration: InputDecoration(
          focusedBorder: OutlineInputBorder(
            borderSide:
                const BorderSide(color: Color.fromARGB(255, 34, 50, 99)),
          ),
          border: new OutlineInputBorder(
              borderSide: new BorderSide(
            color: Color.fromARGB(255, 235, 240, 255),
          )),
          hintText: 'Menu',
          hintStyle: TextStyle(
            color: Color.fromARGB(255, 144, 152, 177),
            fontWeight: FontWeight.bold,
            fontFamily: 'Poppins',
            fontSize: 16.sp,
          ),
        ),
        maxSuggestionsInViewPort: 6,
        itemHeight: 50,
        onTap: (x) {},
      ));

  // SizedBox(
  //       height: 80.h,
  //       child: DropdownSearch<String>(
  //         mode: Mode.MENU,
  //         showSelectedItems: true,
  //         items: _myFriends,
  //         onChanged: print,
  //         selectedItem: _myFriends[0],
  //         dropdownSearchDecoration: InputDecoration(
  //           focusedBorder: OutlineInputBorder(
  //             borderSide:
  //                 const BorderSide(color: Color.fromARGB(255, 34, 50, 99)),
  //           ),
  //           border: new OutlineInputBorder(
  //               borderSide: new BorderSide(
  //             color: Color.fromARGB(255, 235, 240, 255),
  //           )),
  //           hintText: 'Menu',
  //           hintStyle: TextStyle(
  //             color: Color.fromARGB(255, 144, 152, 177),
  //             fontWeight: FontWeight.bold,
  //             fontFamily: 'Poppins',
  //           ),
  //         ),
  //       ),
  //     );

  Widget _formOutlet() => SizedBox(
          width: 320.w,
          height: 80.h,
          child: OutlinedButton(
            onPressed: () => showOutletDialog(context),
            /*{
              Navigator.pushReplacement(context, MaterialPageRoute(
                builder: (context) {
                  return OutletList();
                },
              ));
            }*/
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  child: Icon(
                    Icons.place_outlined,
                    color: Color.fromARGB(255, 144, 152, 177),
                  ),
                ),
                SizedBox(
                  width: 10.w,
                ),
                Text(
                  'Outlet',
                  style: TextStyle(color: Color.fromARGB(255, 144, 152, 177)),
                ),
              ],
            ),
            style: OutlinedButton.styleFrom(
                side: BorderSide(
              width: 1, color: Color.fromARGB(255, 144, 152, 177),
              // focusedBorder: OutlineInputBorder(
              //   borderSide:
              //       const BorderSide(color: Color.fromARGB(255, 34, 50, 99)),
              // ),
              // border: new OutlineInputBorder(
              //     borderSide: new BorderSide(
              //   color: Color.fromARGB(255, 235, 240, 255),
              // )),
              // hintText: 'Estimasi Jumlah Tamu',
            )),
          ));
          
  Widget _formGuest() => TextFormField(
        decoration: tamu,
        controller: _jumlahOrangController,
        keyboardType: TextInputType.number,
        inputFormatters: <TextInputFormatter>[
          FilteringTextInputFormatter.digitsOnly,
        ],
        style: textFormStyle,
      );

  pickDate(BuildContext context) async {
    final initialDate = DateTime.now();
    final newDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(DateTime.now().year - 5),
        lastDate: DateTime(DateTime.now().year + 5));
    if (newDate == null) return;
    setState(() => date = newDate);
  }

  pickTime(BuildContext context) async {
    final newTimeFormat;
    final initialTime = TimeOfDay(hour: 12, minute: 0);
    final newTime = await showTimePicker(
        context: context, initialTime: time ?? initialTime);
    // final format = DateFormat('hh:nn').format(initialTime);
    // if (newTime!.minute < 10) {
    //   newTimeFormat = "${newTime.hour}:0${newTime.minute}";
    //   print(newTimeFormat);
    // }
    // else{
    //   newTimeFormat = "${newTime.hour}:${newTime.minute}";
    // }
    // print(newTime);

    if (newTime == null) return;
    setState(() => time = newTime);
  }

  showOutletDialog(context) async {
    
    Widget searchOutlet() => TextFormField(
      textInputAction: TextInputAction.search,
      onFieldSubmitted: (value){},
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: BorderSide(color: ColorsTheme.neutralGrey!,width: 1.w)
        ),
        prefixIcon: Image.asset('assets/icons/ic_search.png'),
        hintText: "Search Outlet",
        hintStyle: textFormTextStyle,
      ),
      style: textFormTextStyle,
    );

    /*Widget listOutlet() => ListView.builder(
      itemCount: ,
      itemBuilder: (context,index) =>
    );*/

    Widget space() => SizedBox(height: 5.w);

    Widget dialogOutletList() => Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
      insetPadding: EdgeInsets.symmetric(horizontal: 30.w,vertical: 120.h),
      child: Container(
        width: ScreenUtil().screenWidth,
        padding: EdgeInsets.symmetric(horizontal: 8.0.w,vertical: 5.0.h),
        height: ScreenUtil().screenHeight,
        child: Column(
          children: [
            space(),
            Text("Available Outlets In Your Location",style: dialogHeaderTextStyle),
            space(),
            searchOutlet(),
            space(),

          ],
        ),
      ),
    );
    
    return showDialog(
      context: context, 
      barrierDismissible: false,
      builder: (context) => dialogOutletList(),
    );
  }
}

class FormDateTime extends StatelessWidget {
  final VoidCallback press;
  final String text;
  final IconData icon;
  final String hint;
  const FormDateTime({
    Key? key,
    required this.text,
    required this.press,
    required this.icon,
    required this.hint,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    
    return TextFormField(
      onTap: press,
      decoration: InputDecoration(
        suffixIcon: Icon(
          icon,
          color: Color.fromARGB(255, 144, 152, 177),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Color.fromARGB(255, 34, 50, 99)),
        ),
        border: new OutlineInputBorder(
            borderSide: new BorderSide(
          color: Color.fromARGB(255, 235, 240, 255),
        )),
        hintText: hint,
        hintStyle: TextStyle(
          color: Color.fromARGB(255, 144, 152, 177),
          fontWeight: FontWeight.bold,
          fontFamily: 'Poppins',
        ),
      ),
      controller: TextEditingController(text: text),
      style: textFormStyle,
    );
  }
}
