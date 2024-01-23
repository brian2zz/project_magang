import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:camera/camera.dart';
import 'package:fusia/widget/custom_progress_loading.dart';
// import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fusia/controller/account_controller.dart';
import 'package:fusia/controller/dashboard_controller.dart';
import 'package:fusia/controller/login_controller.dart';
import 'package:fusia/model/foto_model.dart';
import 'package:fusia/view/account/camera_screen.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:fusia/color/colors_theme.dart';
import 'package:fusia/widget/custom_appbar_account.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as Im;
import 'package:path_provider/path_provider.dart';
import 'dart:math' as Math;

class PreviewCamera extends StatefulWidget {
  PreviewCamera({this.imgPath});
  final XFile? imgPath;

  @override
  State<PreviewCamera> createState() => _PreviewCameraState();
}

class _PreviewCameraState extends State<PreviewCamera> {
  bool _load = false;
  LoginController? userController;
  DashboardController? dashboardController;
  AccountController? accountController;

  var photoUrlUser, photoIdUser;

  // var alertStyle = AlertStyle(
  //   // overlayColor: Colors.blue[400],
  //   animationType: AnimationType.fromTop,
  //   isCloseButton: false,
  //   isOverlayTapDismiss: false,
  //   descStyle: TextStyle(fontWeight: FontWeight.bold),
  //   alertBorder: RoundedRectangleBorder(
  //     borderRadius: BorderRadius.circular(20.0),
  //     side: BorderSide(
  //       color: Colors.grey,
  //     ),
  //   ),
  // );

  initState() {
    super.initState();

    initConstructor();
    // initData();
  }

  initConstructor() {
    userController = Get.put(LoginController());
    dashboardController = Get.put(DashboardController());
    accountController = Get.put(AccountController());

    photoUrlUser = "".obs;
    photoIdUser = "".obs;
  }

  initPhoto(base64Image) async {
    await userController!.retrieveUserLocalData();

    setState(() {
      var token = LoginController.userToken.value;
      var customerId = LoginController.customerId.value;
      // print(customerId);

      retrieveDataPhoto(token, customerId, base64Image);
    });
  }

  retrieveDataPhoto(token, customerId, base64Image) async {
    var result =
        await dashboardController!.retrieveDashboard(token, customerId);

    setState(() {
      if (result['status'] == 200) {
        Foto responsefoto =
            Foto.fromJson(result['details']['databody']['foto']);
        photoUrlUser.value = responsefoto.fotoUrl;
        photoIdUser.value = responsefoto.fotoId;

        PostPhoto(customerId, base64Image, photoIdUser.value);
      }
    });
  }

  PostPhoto(customerId, base64Image, photoIdUser) async {
    showdialog(context);
    var result = await accountController!
        .SendPhoto(customerId, widget.imgPath!.name, base64Image, photoIdUser);
    print(result['details']);
    setState(() {
      if (result['status'] == 200) {
        print("Success send photo");
        Navigator.pop(context);
        successAlertDialog(context);
      } else {
        print("Failed send photo");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        Image.file(
          File(widget.imgPath!.path),
          fit: BoxFit.cover,
          height: double.infinity,
          width: double.infinity,
          alignment: Alignment.center,
        ),
        // Align(
        //   alignment: Alignment.topRight,
        //   child: Container(
        //     padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 20.h),
        //     child: SavePhoto(),
        //   ),
        // ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            height: 250.h,
            width: double.infinity,
            padding: EdgeInsets.all(20.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Expanded(
                  child: FloatingActionButton(
                    heroTag: "btn1",
                    backgroundColor: Colors.green,
                    onPressed: () {
                      // _takePhoto();
                      // print(widget.imgPath!.name);
                      if (File(widget.imgPath!.path).lengthSync() < 512000) {
                        // print(
                        //     '${getFileSizeString(bytes: File(widget.imgPath!.path).lengthSync())}');
                        final bytes =
                            File(widget.imgPath!.path).readAsBytesSync();
                        String base64Image = base64Encode(bytes);
                        // print("name : $base64Image${widget.imgPath!.name}");
                        initPhoto(base64Image);
                      } else {
                        showAlertDialog(context);
                      }
                    },
                    child: Icon(
                      Icons.done,
                      // color: ColorsTheme.lightGreen,
                      size: 40.h,
                    ),
                  ),
                ),
                Expanded(
                  child: FloatingActionButton(
                    heroTag: "btn2",
                    backgroundColor: Colors.red,
                    onPressed: () {
                      BackAlertDialog();
                    },
                    child: Icon(
                      Icons.close,
                      // color: ColorsTheme.lightRed,
                      size: 40.h,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    ));
  }

  Widget SavePhoto() => Expanded(
        child: Align(
          alignment: Alignment.topRight,
          child: IconButton(
            onPressed: () {
              _takePhoto();
            },
            icon: Icon(
              Icons.download,
              color: ColorsTheme.white,
              size: 40.h,
            ),
          ),
        ),
      );

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
                  Navigator.pop(context);
                  Navigator.pushReplacementNamed(context, '/editaccount');
                },
              ),
            ],
          );
        });
  }

  loadingDialog(BuildContext context) {
    
    AlertDialog alert = AlertDialog(
      content: new Row(
        children: [
          CircularProgressIndicator(),
          Container(margin: EdgeInsets.only(left: 5), child: Text("Loading")),
        ],
      ),
    );
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  showAlertDialog(BuildContext context) {
    showDialog(
      barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Center(
                child: Icon(Icons.warning,
                    size: 80.sp, color: Colors.yellow[700])),
            content: SingleChildScrollView(
              child: Center(
                  child: Text('Image size too large',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 20.sp))),
            ),
            actions: <Widget>[
              TextButton(
                  child: Text('OK',
                      style:
                          TextStyle(color: ColorsTheme.primary, fontSize: 20)),
                  onPressed: () {
                    Navigator.pop(context);
                  }),
            ],
          );
        });
    
  }

  BackAlertDialog() {
    showDialog(
      barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Center(
                child: Icon(Icons.warning,
                    size: 80.sp, color: Colors.yellow[700])),
            content: SingleChildScrollView(
              child: Center(
                  child: Text('Apakah anda yakin ingin kembali ?',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ))),
            ),
            actions: <Widget>[
              TextButton(
                  child: Text('OK',
                      style:
                          TextStyle(color: ColorsTheme.primary, fontSize: 20)),
                  onPressed: () {
                    Navigator.of(context, rootNavigator: true).pop();
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) {
                        return CameraScreen();
                      }),
                    );
                  }),
              TextButton(
                child: Text('TIDAK',
                    style: TextStyle(color: ColorsTheme.primary, fontSize: 20)),
                onPressed: () {
                  Navigator.of(context, rootNavigator: true).pop();
                },
              ),
            ],
          );
        });
    
  }

  int getFileSizeString({required int bytes, int decimals = 0}) {
    // if (bytes <= 0) return "0 Bytes";
    // const suffixes = [" Bytes", "KB", "MB", "GB", "TB"];
    // var i = (log(bytes) / log(1024)).floor();
    // return ((bytes / pow(1024, i)).toStringAsFixed(decimals)) + suffixes[i];
    return bytes;
  }

  void _takePhoto() async {
    if (widget.imgPath! != null && widget.imgPath!.path != null) {
      setState(() {
        _load = true;
      });
      GallerySaver.saveImage(widget.imgPath!.path, albumName: 'FusiaAlbum')
          .then((bool? success) {
        /*Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) {
            return CameraScreen();
          }),
        );*/
        Navigator.pushReplacementNamed(context, '/editaccount');
      });
    }
    ;
  }
}
