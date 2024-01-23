import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fusia/color/colors_theme.dart';
import 'package:fusia/controller/login_controller.dart';
import 'package:fusia/controller/outlet_controller.dart';
import 'package:fusia/controller/reservation_controller.dart';
import 'package:fusia/model/outlet_model/outlet_model.dart';
import 'package:fusia/model/reservation_model/menu_model.dart';
import 'package:fusia/view/reservation/reservation_detail.dart';
import 'package:fusia/widget/custom_appbar.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

  //utils field component
  TextStyle textFormStyle = TextStyle(
    color: ColorsTheme.black,
    fontWeight: FontWeight.bold,
    fontSize: 12.sp,
    fontFamily: 'Poppins',
  );

  TextStyle subHeaderTextStyle = TextStyle(
    color: ColorsTheme.black,
    fontWeight: FontWeight.w600,
    fontSize: 12.sp,
    fontFamily: 'Poppins',
  );

  TextStyle textFormHintStyle = TextStyle(
    color: ColorsTheme.neutralGrey,
    fontWeight: FontWeight.bold,
    fontSize: 12.sp,
    fontFamily: 'Poppins',
  );

  InputDecoration fieldStyle(isPrefixIcon,typeField,isSuffixIcon) => InputDecoration(
    contentPadding: EdgeInsets.symmetric(vertical: 13.0.h,horizontal: 16.w),
    prefixIcon: (isPrefixIcon) 
      ? (typeField == "tamu") 
        ? Image.asset('assets/icons/ic_fullname.png')
        : Image.asset('assets/icons/ic_maps_2.png')
      : null,
    suffixIcon: (isSuffixIcon)
    ? (typeField == "jam")
      ? Image.asset('assets/icons/ic_hours.png')
      : (typeField == "menu") 
        ? RotatedBox(
            quarterTurns: 3,
            child: Image.asset('assets/icons/ic_arrow_bank.png'),
          )
        : Image.asset('assets/icons/ic_date.png')
    : null,
    border: OutlineInputBorder(
        borderSide: BorderSide(color: ColorsTheme.neutralGrey!, width: 1.w),
    ),
    hintText: (typeField == "tamu")
      ? 'Estimasi Jumlah Tamu'
      : (typeField == "tanggal")
        ? 'Tanggal'
        : (typeField == "jam")
          ? 'Jam Booking'
          : (typeField == "durasi")
            ? 'Durasi'
            : (typeField == "outlet")
              ? 'Outlet'
              : (typeField == "menu")
                ? 'Menu'
      : 'Ini Keterangan...',
    hintStyle: textFormHintStyle,
  );

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

  TextStyle dialogHeaderTextStyle = TextStyle(
    fontFamily: 'Poppins',
    fontSize: 16.sp,
    fontWeight: FontWeight.bold,
    color: ColorsTheme.neutralDark,
  );

  DateTime? date;
  TimeOfDay? time;
  
  LoginController? userController;
  ReservationController? reservationController;
  OutletController? outletController;
  int value = 1;

  //future
  Future? _loadData;

  //datasets
  List<String> duration = [
    "30 Menit",
    "60 Menit",
    "90 Menit",
    "120 Menit",
  ];
  List<Order> orderList = [];
  var fruits = ['Apple', 'Banana', 'Mango', 'Orange'];
  List<Result> allOutletData = [];
  List<Result> filteredOutletData = [];
  List<ResultMenu> allMenuData = [];
  List<ResultMenu> filteredMenuData = [];
  
  var userToken, customerId;
  var produkId, satuanId, produkNama, satuanKode;
  var tanggal, waktu, jumlahOrang, keterangan, pesanan, jumlahPesanan;
  
  TextEditingController? _jumlahOrangController;
  TextEditingController? _outletController;
  TextEditingController? _keteranganController;
  TextEditingController? _pesananController;
  TextEditingController? _controllerDate;
  TextEditingController? _controllerTimes;
  TextEditingController? _menuController;

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
    reservationController = Get.put(ReservationController());
    reservationController = Get.put(ReservationController());
    outletController = Get.put(OutletController());

    userToken = "".obs;
    customerId = "".obs;

    tanggal = "".obs;
    waktu = "".obs;
    jumlahOrang = "".obs;
    keterangan = "".obs;
    pesanan = "".obs;
    jumlahPesanan = "".obs;

    _controllerDate = TextEditingController();
    _controllerTimes = TextEditingController();
    _outletController = TextEditingController();
    _jumlahOrangController = TextEditingController();
    _pesananController = TextEditingController();
    _keteranganController = TextEditingController();
    _menuController = TextEditingController();

    // produkId = "".obs;
    // satuanId = "".obs;
    // produkNama = "".obs;
    // satuanKode = "".obs;
  }

  initData() async {
    await userController!.retrieveUserLocalData();

    
    setState(() {
      userToken.value = LoginController.userToken.value;
      customerId.value = LoginController.customerId.value;
    
      _loadData = loadOutlet(userToken.value);
    });
    
    retrieveDateTimeNow();
  }

  //load data from API and set local configuration
  retrieveDateTimeNow() {
    var month = DateFormat('MM').format(DateTime.now());
    var newMonthFormat = "";

    if(month == "01") {
      newMonthFormat = "Januari";
    } else if(month == "02") {
      newMonthFormat = "Februari";
    } else if(month == "03") {
      newMonthFormat = "Maret";
    } else if(month == "04") {
      newMonthFormat = "April";
    } else if(month == "05") {
      newMonthFormat = "Mei";
    } else if(month == "06") {
      newMonthFormat = "Juni";
    } else if(month == "07") {
      newMonthFormat = "Juli"; 
    } else if(month == "08") {
      newMonthFormat = "Agustus";
    } else if(month == "09") {
      newMonthFormat = "September";
    } else if(month == "10") {
      newMonthFormat = "Oktober";
    } else if(month == "11") {
      newMonthFormat = "November";
    } else {
      newMonthFormat = "Desember";
    }

    var day = DateFormat('dd').format(DateTime.now());
    var year = DateFormat('yyyy').format(DateTime.now());
    var times = DateFormat('HH:mm').format(DateTime.now());

    setState(() {
      _controllerDate!.text = "$day $newMonthFormat $year";
      _controllerTimes!.text = "$times WIB";
    });
  }

  loadOutlet(token) async {
    var result = await outletController!.retrieveOutletListController(token);

    if(result['status'] == 200) {
      OutletModel responsedata = OutletModel.fromJson(result['details']);

      _outletController!.text = responsedata.results![0].cabangNama!;

      for (var element in responsedata.results!) {
        allOutletData.add(element);
      }

      setState(() => filteredOutletData = allOutletData);
      loadMenu(token, customerId);
    }
  }

  loadMenu(token,customerId) async {
    var result = await reservationController!.retrieveMenuList(token, customerId);

    if(result['status'] == 200) {
      MenuModel responsedata = MenuModel.fromJson(result['details']);

      responsedata.results!.forEach((element) {
          allMenuData.add(element);
      });

      setState(() => filteredMenuData = allMenuData);
    }
  }

  //local mechanism controller (quantity and search input)
  _incrementCounter() {
    setState(() {
      value++;
    });
  }

  _decrementCounter() {
    setState(() {
      value--;
    });
  }

  searchInputOutlet(String query,StateSetter state) {
    List<Result> temporarySearch = [];
    
    if(query.isEmpty) {
      state(() {
        filteredOutletData = allOutletData;
      });
    } else {
      state(() {
        temporarySearch = allOutletData.where((element) => element.cabangNama!.toLowerCase().contains(query.toLowerCase())).toList();
        
        filteredOutletData = temporarySearch;
      });
    }
  }

  searchInputMenu(String query,StateSetter state) {
    List<ResultMenu> temporarySearch = [];
    
    if(query.isEmpty) {
      state(() {
        filteredMenuData = allMenuData;
      });
    } else {
      state(() {
        temporarySearch = allMenuData.where((element) => element.produkNama!.toLowerCase().contains(query.toLowerCase())).toList();
        
        filteredMenuData = temporarySearch;
      });
    }
  }

  selectedOutlet(StateSetter state,String cabangNama) {
    _outletController!.text = cabangNama;
    
    Navigator.of(context).pop();
    state(() {
      filteredOutletData = allOutletData;
    });
  }

  selectedMenu(StateSetter state,String produkNama) {
    _menuController!.text = produkNama;
    
    Navigator.of(context).pop();
    state(() {
      filteredMenuData = allMenuData;
    });
  }

  //send into a server function
  initReservation(token,customerId) async {
    setState(() {
      
      tanggal.value = dateReservation();
      waktu.value = timeReservation();
      jumlahOrang.value = _jumlahOrangController!.text;
      keterangan.value = _keteranganController!.text;
      pesanan.value = _pesananController!.text;
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

  //date and time local configuration
  dateReservation() {
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
      return _controllerDate!.text = "$hari $bulan $tahun";
    }
  }

  timeReservation() {
    if (time == null) {
      return '';
    } else if (time!.minute < 10) {
      return _controllerTimes!.text = '${time!.hour}:0${time!.minute} WIB';
    } else {
      return _controllerTimes!.text = '${time!.hour}:${time!.minute} WIB';
    }
  }

  pickDate(context) async {
    final initialDate = DateTime.now();
    final newDate = await showDatePicker(
        context: context,
        initialDate: initialDate,
        firstDate: DateTime(initialDate.year - 5),
        lastDate: DateTime(initialDate.year + 5));
    if (newDate == null) return;
    setState(() => date = newDate);
  }

  pickTime(context) async {
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

  //outlet dialog form
  showOutletDialog(context) async {
    
    TextStyle headerListStyle(isTitle,isSubtitle,isAddress) => TextStyle(
      fontFamily: 'Poppins',
      fontSize: (isTitle) ? 14.sp : 12.sp,
      fontWeight: (isSubtitle) ? FontWeight.w400 : FontWeight.w700,
      color: (isAddress) ? ColorsTheme.neutralGrey : ColorsTheme.neutralDark,
    );

    Widget searchOutlet(state) => TextFormField(
      textInputAction: TextInputAction.search,
      onFieldSubmitted: (value) => searchInputOutlet(value,state),
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

    Widget listText(data) => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          data.cabangNama.toString(),
          style: headerListStyle(true, false, false),
        ),
        SizedBox(height: 4.h),
        Text(
          data.cabangAlamat.toString(),
          style: headerListStyle(false, true, true),
        ),
        SizedBox(height: 4.h),
        Text(
          (data.cabangTelp == "") ? "Tidak Tersedia" : data.cabangTelp.toString(),
          style: headerListStyle(false, true, false),
        )
      ],
    );

    Widget itemMenuList(Result data) => Padding(
      padding: EdgeInsets.all(16.w),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 38.w,
            height: 22.h,
            child: Image.asset('assets/images/logo_onboarding_2.png')
          ),
          SizedBox(width: 12.w), 
          Flexible(
            child: listText(data),
          ),
        ],
      ),
    );

    Widget listOutlet(state) => Expanded(
      child: ListView.builder(
        itemCount: filteredOutletData.length,
        itemBuilder: (context,index) => InkWell(
          onTap: () => selectedOutlet(state,filteredOutletData[index].cabangNama!),
          child: itemMenuList(filteredOutletData[index]),
        ),
        shrinkWrap: true,
      ),
    );

    Widget space() => SizedBox(height: 10.w);

    Widget dialogOutletList() => Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
      insetPadding: EdgeInsets.symmetric(horizontal: 30.w),
      child: StatefulBuilder(
          builder: (context,state) => Container(
              width: ScreenUtil().screenWidth,
              height: 500.h,
              padding: EdgeInsets.symmetric(horizontal: 8.0.w,vertical: 10.0.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Available Outlets In Your Location",style: dialogHeaderTextStyle),
                  space(),
                  searchOutlet(state),
                  space(),
                  listOutlet(state),
                ],
              ),
            ),
          ),
    );
    
    return showDialog(
      context: context, 
      barrierDismissible: false,
      builder: (context) => dialogOutletList(),
    );
  }

  showMenuDialog(context) async {
    
    TextStyle headerListStyle(isTitle,isSubtitle,isAddress) => TextStyle(
      fontFamily: 'Poppins',
      fontSize: (isTitle) ? 14.sp : 12.sp,
      fontWeight: (isSubtitle) ? FontWeight.w400 : FontWeight.w700,
      color: (isAddress) ? ColorsTheme.neutralGrey : ColorsTheme.neutralDark,
    );

    Widget searchOutlet(state) => TextFormField(
      textInputAction: TextInputAction.search,
      onFieldSubmitted: (value) => searchInputMenu(value,state),
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

    Widget listText(ResultMenu data) => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          data.produkNama.toString(),
          style: headerListStyle(true, false, false),
        ),
      ],
    );

    Widget itemMenuList(ResultMenu data) => Padding(
      padding: EdgeInsets.all(16.w),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 38.w,
            height: 22.h,
            child: Image.asset('assets/images/logo_onboarding_2.png')
          ),
          SizedBox(width: 12.w), 
          Flexible(
            child: listText(data),
          ),
        ],
      ),
    );

    Widget listOutlet(state) => Expanded(
      child: ListView.builder(
        itemCount: filteredMenuData.length,
        itemBuilder: (context,index) => InkWell(
          onTap: () => selectedMenu(state,filteredMenuData[index].produkNama!),
          child: itemMenuList(filteredMenuData[index]),
        ),
        shrinkWrap: true,
      ),
    );

    Widget space() => SizedBox(height: 10.w);

    Widget dialogOutletList() => Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
      insetPadding: EdgeInsets.symmetric(horizontal: 30.w),
      child: StatefulBuilder(
          builder: (context,state) => Container(
              width: ScreenUtil().screenWidth,
              height: 500.h,
              padding: EdgeInsets.symmetric(horizontal: 8.0.w,vertical: 10.0.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Available Menu In Your Outlet",style: dialogHeaderTextStyle),
                  space(),
                  searchOutlet(state),
                  space(),
                  listOutlet(state),
                ],
              ),
            ),
          ),
    );
    
    return showDialog(
      context: context, 
      barrierDismissible: false,
      builder: (context) => dialogOutletList(),
    );
  }

  @override
  Widget build(BuildContext context) {

    Widget appbar() => CustomAppBar(
      title: "Reservation",
      secondtitle: "",
      isAccessDetail: true,
      isNeedTwoLines: false,
    );

    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(78.h),
          child: appbar(),
        ),
        body: _body(context),
        bottomNavigationBar: _makeReservationButton(),
      ),
    );
  }

  //widget component
  Widget _body(BuildContext context) => FutureBuilder(
    future: _loadData,
    builder: (context,snapshot) {
      if(snapshot.connectionState == ConnectionState.done) {
        if(snapshot.hasData) {
          //return 'data kosong';
        } else {
          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 16.w,vertical: 24.h),
            child: _formReservation(context),
          );
        }
      }
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(),
            SizedBox(height: 10.h),
            Text("Memuat Data",style: textFormTextStyle),
          ],
        ),
      );
    }
  );

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

  Widget _formReservation(context) {
    
    Widget space(height) => SizedBox(height: height);

    Widget _formDescription() => SizedBox(
      height: 160.h,
      child: TextFormField(
        controller: _keteranganController,
        decoration: fieldStyle(false, '',false),
        minLines: 10,
        keyboardType: TextInputType.multiline,
        maxLines: null,
      ),
    );

    Widget _formDuration() => SizedBox(
      height: 48.h,
      child: DropdownButtonFormField(
        decoration: fieldStyle(false, 'durasi',false),
        icon: RotatedBox(
          quarterTurns: 3,
          child: Image.asset('assets/icons/ic_arrow_back.png'),
        ),
        value: _chosenValue,
        onChanged: (String? Value) {
          setState(() {
            _chosenValue = Value;
          });
        },
        items: duration
            .map(
              (cityTitle) =>
                DropdownMenuItem(
                  value: cityTitle, 
                  child: Text(
                    cityTitle,
                    style: textFormStyle,
                  ),
              ),
            )
            .toList(),
      ),
    );

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
            color: ColorsTheme.primary,
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

    Widget _formMenu() => TextFormField(
      controller: _menuController,
      onTap: () => showMenuDialog(context),
      decoration: fieldStyle(false, 'menu', false),
      keyboardType: TextInputType.none,
      style: textFormTextStyle,
    );
  
    Widget _formOutlet() => SizedBox(
      height: 48.h,
      child: TextFormField(
        controller: _outletController,
        decoration: fieldStyle(true, 'outlet', false),
        onTap: () => showOutletDialog(context),
        keyboardType: TextInputType.none,
      )
    );

    Widget _formGuest() => SizedBox(
      height: 48.h,
      child: TextFormField(
        decoration: fieldStyle(true, "tamu",false),
        controller: _jumlahOrangController,
        keyboardType: TextInputType.number,
        inputFormatters: <TextInputFormatter>[
          FilteringTextInputFormatter.digitsOnly,
        ],
        style: textFormStyle,
      ),
    );

    Widget linesContent() => Container(
      width: ScreenUtil().screenWidth,
      color: ColorsTheme.lightGrey2,
      height: 9.h,
    );

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FormDateTime(
          press: () => pickDate(context),
          text: dateReservation(),
          hint: 'Tanggal',
          controller: _controllerDate!,
        ),
        space(10.h),
        FormDateTime(
          press: () => pickTime(context),
          text: timeReservation(),
          hint: 'Pukul',
          controller: _controllerTimes!,
        ),
        space(10.h),
        _formDuration(),
        space(10.h),
        _formGuest(),
        space(10.h),
        _formOutlet(),
        space(19.h),
        linesContent(),
        space(12.h),
        Text(
          'Menu',
          style: subHeaderTextStyle,
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

}

class FormDateTime extends StatelessWidget {
  final VoidCallback press;
  final String text;
  final String hint;
  final TextEditingController controller;
  const FormDateTime({
    Key? key,
    required this.text,
    required this.press,
    required this.hint,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    
    return SizedBox(
      height: 48.h,
      child: TextFormField(
        onTap: press,
        decoration: fieldStyle(false, (hint == "Pukul") ? 'jam' : 'tanggal',true),
        controller: controller,
        style: textFormStyle,
      ),
    );
  }
}
