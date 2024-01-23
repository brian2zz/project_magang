
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fusia/color/colors_theme.dart';
import 'package:matrix_gesture_detector/matrix_gesture_detector.dart';

class DetailFullScreenImage extends StatefulWidget {

  final String imageUrl;

  @override
  DetailFullScreenImage(
    {
      required this.imageUrl,
      Key? key,
    }
  ) : super(key: key);

  _DetailFullScreenImageState createState() => _DetailFullScreenImageState();
}

class _DetailFullScreenImageState extends State<DetailFullScreenImage> {

  var _zoomPageNotifier;
  Matrix4? matrix;

  @override
  void initState() {
    super.initState();
    initConstructor();
  }

  initConstructor() {
    _zoomPageNotifier = ValueNotifier<int>(0);
    matrix = Matrix4.identity();
  }

  Widget build(BuildContext context) {
    
    Widget body() => LayoutBuilder(
      builder: (context,constraints) {
        Size size = constraints.biggest;
        double side = size.shortestSide * 0.666;
        return MatrixGestureDetector(
          onMatrixUpdate: (m, tm, sm, rm) {
            matrix = MatrixGestureDetector.compose(matrix, tm, sm, null);

            _zoomPageNotifier.value++;
          },
          child: SizedBox(
            width: ScreenUtil().screenWidth,
            height: double.infinity,
            child: AnimatedBuilder(
              animation: _zoomPageNotifier,
              builder: (context,child) => Transform(
                transform: matrix!,
                child: Container(
                  width: side,
                  height: side,
                  child: CachedNetworkImage(
                    imageUrl: widget.imageUrl,
                    placeholder: (context,url) => const Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
                ),
              ),
            )
          ),
        );
      },
    );
    
    return Scaffold(
      body: body(),
      backgroundColor: ColorsTheme.primary,
    );
  }
}