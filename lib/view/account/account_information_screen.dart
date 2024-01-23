import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fusia/color/colors_theme.dart';
import 'package:fusia/controller/account_controller.dart';
import 'package:fusia/controller/dashboard_controller.dart';
import 'package:fusia/controller/login_controller.dart';
import 'package:fusia/model/data_account_model.dart';
import 'package:fusia/model/foto_model.dart';
import 'package:fusia/server/server_base.dart';
import 'package:fusia/view/account/camera_screen.dart';
// import 'package:fusia/view/account/change_password_page.dart';
import 'package:fusia/widget/custom_appbar_account.dart';
import 'package:fusia/widget/custom_progress_loading.dart';
import 'package:fusia/widget/custom_toast.dart';
import 'package:get/get.dart';
// import 'package:camerax/camerax.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';

TextStyle alertErrorTextStyle = TextStyle(
  fontFamily: 'Poppins',
  fontSize: 12.sp,
  fontWeight: FontWeight.w400,
  color: ColorsTheme.white,
);

TextStyle alertStyle = TextStyle(
  fontFamily: 'Poppins',
  fontSize: 12.sp,
  fontWeight: FontWeight.w400,
  color: ColorsTheme.white,
);

class AccountInformation extends StatefulWidget {
  AccountInformation({Key? key}) : super(key: key);
  @override
  _AccountInformationState createState() => _AccountInformationState();
}

class _AccountInformationState extends State<AccountInformation> {
  //controller
  LoginController? userController;
  DashboardController? dashboardController;
  AccountController? accountController;

  TextEditingController EmailController = TextEditingController();
  TextEditingController NamaController = TextEditingController();
  TextEditingController PhoneController = TextEditingController();
  TextEditingController BirthdayController = TextEditingController();

  Future? _loadData;
  //global variable

  var token, customerId;
  var namaUser;
  var emailUser;
  var phoneUser;
  var tanggalLahirUser;
  var photoUrlUser;
  var membershipUser;
  var havePassword;

  String? oldPassword;
  String? newPassword;
  @override
  initState() {
    super.initState();

    focusNode1.addListener(onFocusChange1);
    focusNode2.addListener(onFocusChange2);
    focusNode3.addListener(onFocusChange3);
    focusNode4.addListener(onFocusChange4);
    initConstructor();
    initData();
  }

  initConstructor() {
    userController = Get.put(LoginController());
    dashboardController = Get.put(DashboardController());
    accountController = Get.put(AccountController());

    namaUser = "".obs;
    emailUser = "".obs;
    phoneUser = "".obs;
    tanggalLahirUser = "".obs;
    havePassword = "".obs;
    photoUrlUser = "".obs;
  }

  initData() async {
    await userController!.retrieveUserLocalData();

    setState(() {
      token = LoginController.userToken.value;
      customerId = LoginController.customerId.value;
      print(token);
      _loadData = retrieveDashboard(token, customerId);
      // passwordStatus(customerId);
    });
  }

  retrieveDashboard(token, customerId) async {
    var result =
        await dashboardController!.retrieveDashboard(token, customerId);

    setState(() {
      if (result['status'] == 200) {
        DataAccountModel responsedata =
            DataAccountModel.fromJson(result['details']['databody']);
        Foto responsefoto =
            Foto.fromJson(result['details']['databody']['foto']);

        tanggalLahirUser.value = responsedata.custTgllahir;
        phoneUser.value = responsedata.custHp;
        emailUser.value = responsedata.custEmail;
        photoUrlUser.value = responsefoto.fotoUrl;
        EmailController =
            TextEditingController(text: '${responsedata.custEmail}');
        NamaController =
            TextEditingController(text: '${responsedata.custNama}');
        PhoneController = TextEditingController(text: '${responsedata.custHp}');

        print(photoUrlUser.value);
      }
    });
  }

  // passwordStatus(customerId) async {
  //   // showdialog(context);
  //   var result = await accountController!
  //       .RequestPassword(customerId, oldPassword, newPassword);
  //   setState(() {
  //     if (result['status'] == 200) {
  //       if (result['details']['success'] == true) {
  //         havePassword.value = 'false';
  //       } else {
  //         havePassword.value = 'true';
  //       }
  //     }
  //   });
  // }

  Future refreshItem() async {
    setState(() {
      _loadData = retrieveDashboard(token, customerId);
    });
  }

  DateTime? date;
  String Birthday() {
    if (date == null) {
      return tanggalLahirUser.value;
    } else {
      return DateFormat('yyyy-MM-dd').format(date!);
    }
  }

  String BirthText() {
    if (tanggalLahirUser.value == '') {
      return '';
    } else if (date == null && tanggalLahirUser.value != null) {
      DateTime parseDate =
          DateFormat('yyyy-MM-dd').parse(tanggalLahirUser.value);
      var inputDate = DateTime.parse(parseDate.toString());
      return '${DateFormat('dd MMMM yyyy').format(inputDate)}';
    } else {
      return DateFormat('dd MMMM yyyy').format(date!);
    }
  }

  Color? textColor1 = ColorsTheme.neutralGrey;
  Color? textColor2 = ColorsTheme.neutralGrey;
  Color? textColor3 = ColorsTheme.neutralGrey;
  Color? textColor4 = ColorsTheme.neutralGrey;
  final FocusNode focusNode1 = FocusNode();
  final FocusNode focusNode2 = FocusNode();
  final FocusNode focusNode3 = FocusNode();
  final FocusNode focusNode4 = FocusNode();

  void onFocusChange1() {
    setState(() {
      textColor1 = focusNode1.hasFocus ? null : ColorsTheme.neutralGrey;
    });
  }

  void onFocusChange2() {
    setState(() {
      textColor2 = focusNode2.hasFocus ? null : ColorsTheme.neutralGrey;
    });
  }

  void onFocusChange3() {
    setState(() {
      textColor3 = focusNode3.hasFocus ? null : ColorsTheme.neutralGrey;
    });
  }

  void onFocusChange4() {
    setState(() {
      textColor4 = focusNode4.hasFocus ? null : ColorsTheme.neutralGrey;
    });
  }

  validateForm() {
    if (EmailController.text.isEmpty) {
      alertSnacbar("Email tidak boleh Kosong.", ColorsTheme.black);
    } else if (PhoneController.text.isEmpty) {
      alertSnacbar("No.Telp tidak boleh Kosong.", ColorsTheme.black);
    } else if (!EmailController.text.contains("@")) {
      alertSnacbar(
          "Pastikan Email yang anda masukkan sudah sesuai dengan format email.",
          ColorsTheme.black);
    } else if (Birthday().isEmpty) {
      alertSnacbar("Tanggal Lahir tidak boleh Kosong.", ColorsTheme.black);
    } else {
      setState(() {
        UpdateAccount();
      });
    }
  }

  UpdateAccount() async {
    showdialog(context);

    Map<String, dynamic> paramsdata = {
      "id": customerId,
      "nama": NamaController.text,
      "Email": EmailController.text,
      "datebirth": Birthday(),
      "phone": PhoneController.text,
    };
    print(paramsdata);

    var result = await accountController!.SendUpdateInformation(paramsdata);

    if (result['status'] == 200) {
      setState(() {
        hidedialog(context);
        successAlertDialog(context);
      });
    } else {
      hidedialog(context);
      alertSnacbar(result['detail'], ColorsTheme.lightRed);
    }
  }

  alertSnacbar(alertText, color) async {
    var snackbar = SnackBar(
      content: Text(alertText, style: alertStyle),
      backgroundColor: color,
      duration: const Duration(milliseconds: 1000),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackbar);
  }

  successAlertDialog(BuildContext context) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Center(
                child: Icon(Icons.done, size: 80.sp, color: Colors.green[600])),
            content: SingleChildScrollView(
              child: Center(
                  child: Text('Success',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 20.sp))),
            ),
            actions: <Widget>[
              TextButton(
                child: Text('OK',
                    style: TextStyle(color: ColorsTheme.primary, fontSize: 20)),
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context, customerId);
                },
              ),
            ],
          );
        });
  }

  @override
  void dispose() {
    focusNode1.removeListener(onFocusChange1);
    focusNode2.removeListener(onFocusChange2);
    focusNode3.removeListener(onFocusChange3);
    focusNode4.removeListener(onFocusChange4);
    super.dispose();
  }

  Widget build(BuildContext context) => Scaffold(
        appBar: appBar(
          title: 'Account Information',
          // press: () {
          //     Navigator.pushReplacementNamed(context, '/account');
          //   }
        ),
        body: _body(context),
      );

  Widget _body(BuildContext context) => FutureBuilder(
      future: _loadData,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasData) {
            SchedulerBinding.instance!.addPostFrameCallback((_) {
              var snackbar = SnackBar(
                content: Text(
                    "Data user gagal terupload. Pastikan jaringan internet dalam kondisi baik.",
                    style: alertErrorTextStyle),
                backgroundColor: ColorsTheme.lightRed,
                behavior: SnackBarBehavior.floating,
              );
              ScaffoldMessenger.of(context).showSnackBar(snackbar);
            });
            return _ContentBody(context, false);
          } else {
            return _ContentBody(context, false);
          }
        } else {
          return _ContentBody(context, true);
        }
      });
  // _ContentBody(context);

  Widget _ContentBody(BuildContext context, isLoading) => Container(
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          children: <Widget>[
            _AvatarProfile(context, isLoading),
            SizedBox(
              height: 60.h,
            ),
            Label(
              label: 'Nama',
            ),
            SizedBox(height: 10.h),
            TextFieldWidget(
                focusNode: focusNode4,
                textController: NamaController,
                textColor: textColor4),
            SizedBox(height: 10.h),
            Label(
              label: 'Email',
            ),
            SizedBox(height: 10.h),
            TextFieldWidget(
                focusNode: focusNode1,
                textController: EmailController,
                textColor: textColor1),
            SizedBox(height: 10.h),
            Label(
              label: 'Phone Number',
            ),
            SizedBox(height: 10.h),
            TextFieldWidget(
                focusNode: focusNode2,
                textController: PhoneController,
                textColor: textColor2),
            SizedBox(height: 10.h),
            Label(
              label: 'Birthday',
            ),
            SizedBox(height: 10.h),
            _Birthday(context),
            SizedBox(height: 20.h),
            // _ChangePassword(context, havePassword.value),
            SizedBox(height: 25.h),
            ClipRRect(
              borderRadius: BorderRadius.circular(5.r),
              child: FlatButton(
                padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 40.w),
                color: ColorsTheme.primary,
                onPressed: () {
                  validateForm();
                },
                child: Text(
                  'Save',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20.sp,
                  ),
                ),
              ),
            ),
            SizedBox(height: 25.h),
          ],
        ),
      );

  Widget _AvatarProfile(BuildContext context, isLoading) {
    Widget loadingAvatar() => Shimmer.fromColors(
          child: CircleAvatar(backgroundColor: ColorsTheme.black, radius: 30.r),
          baseColor: ColorsTheme.lightBrown!,
          highlightColor: ColorsTheme.darkerBrown!,
        );
    return Center(
      child: Column(
        children: <Widget>[
          SizedBox(height: 60.h),
          (isLoading)
              ? loadingAvatar()
              : CachedNetworkImage(
                  imageUrl: "${ServerBase.serverUrl}/${photoUrlUser.value}",
                  imageBuilder: (context, imageProvider) => ClipRRect(
                    borderRadius: BorderRadius.circular(30.r),
                    child: CircleAvatar(
                      radius: 30.r,
                      backgroundImage: imageProvider,
                    ),
                  ),
                  placeholder: (context, url) => loadingAvatar(),
                  errorWidget: (context, url, error) =>
                      Image.asset("assets/images/mascot_siluet.jpg"),
                ),
          SizedBox(height: 25.h),
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CameraScreen()),
              ).then((value) => setState(() {}));
            },
            child: Text(
              'Ubah Photo Profile',
              style: TextStyle(
                color: ColorsTheme.neutralDark,
                fontWeight: FontWeight.bold,
                fontFamily: 'Poppins',
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _Birthday(BuildContext context) => TextField(
        onTap: () => PickDate(context),
        focusNode: focusNode3,
        decoration: InputDecoration(
          suffixIcon: Icon(
            Icons.date_range_outlined,
            color: ColorsTheme.neutralGrey,
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: ColorsTheme.neutralDark!),
          ),
          border: new OutlineInputBorder(
              borderSide: new BorderSide(
            color: ColorsTheme.whiteCream!,
          )),
          // hintText: 'Tanggal Lahir',
          // hintStyle: TextStyle(
          //   color: ColorsTheme.grey,
          //   fontWeight: FontWeight.bold,s
          //   fontFamily: 'Poppins',
          // ),
        ),
        controller: TextEditingController(text: BirthText()),
        style: TextStyle(
          color: textColor3,
          fontWeight: FontWeight.bold,
          fontFamily: 'Poppins',
        ),
      );

  // Widget _ChangePassword(BuildContext context, String havePassword) {
  //   bool password;
  //   if (havePassword == 'true') {
  //     password = true;
  //   } else {
  //     password = false;
  //   }
  //   return ListTile(
  //     onTap: () {
  // Navigator.push(
  //   context,
  //   MaterialPageRoute(builder: (context) {
  //     return ChangePassword(havePassword: password);
  //   }),
  // );
  //     },
  //     leading: Icon(Icons.lock_outline, color: ColorsTheme.neutralDark),
  //     title: Text(
  //       password ? 'Change Password' : 'Add Password',
  //       style: TextStyle(
  //         color: ColorsTheme.neutralDark,
  //         fontWeight: FontWeight.bold,
  //         fontFamily: 'Poppins',
  //       ),
  //     ),
  //     trailing: Icon(Icons.arrow_forward_ios),
  //   );
  // }

  Future PickDate(BuildContext context) async {
    final initialDate = DateTime.now();
    final newDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(DateTime.now().year - 70),
        lastDate: DateTime(DateTime.now().year + 5));
    if (newDate == null) return;
    setState(() => date = newDate);
  }
}

class TextFieldWidget extends StatelessWidget {
  const TextFieldWidget({
    Key? key,
    required this.focusNode,
    required this.textController,
    required this.textColor,
  }) : super(key: key);

  final FocusNode focusNode;
  final TextEditingController textController;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      focusNode: focusNode,
      decoration: InputDecoration(
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: ColorsTheme.neutralDark!),
        ),
        border: new OutlineInputBorder(
            borderSide: new BorderSide(
          color: ColorsTheme.whiteCream!,
        )),
      ),
      controller: textController,
      style: TextStyle(
        color: textColor,
        fontWeight: FontWeight.bold,
        fontFamily: 'Poppins',
      ),
    );
  }
}

class Label extends StatelessWidget {
  final String label;
  const Label({
    Key? key,
    required this.label,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: TextStyle(
        color: ColorsTheme.neutralDark,
        fontWeight: FontWeight.bold,
        fontFamily: 'Poppins',
      ),
    );
  }
}
