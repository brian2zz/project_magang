// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:fusia/view/reservation/reservation_detail.dart';
// import 'package:fusia/widget/custom_appbar_account.dart';

// TextStyle text1 = TextStyle(
//   fontWeight: FontWeight.bold,
//   fontSize: 14.sp,
//   fontFamily: 'Poppins',
// );
// TextStyle text2 = TextStyle(
//   color: Color.fromARGB(255, 109, 109, 109),
//   fontWeight: FontWeight.bold,
//   fontSize: 12.sp,
//   fontFamily: 'Poppins',
// );

// class reservationHistory extends StatelessWidget {
//   const reservationHistory({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: appBar(title: 'Reservation History'),
//       body: _body(context),
//     );
//   }

//   Widget _body(BuildContext context) => Container(
//         child:
//             ListView(padding: EdgeInsets.symmetric(vertical: 20.h), children: [
//           ListReservationHistory(
//             title: 'Nasi Timbel 1',
//             sub:
//                 'Purus scelerisque arcu convallis sit ornare. Vel aliquet est nisi, bibendum',
//             press: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (context) {
//                   return reservationDetail(

//                   );
//                 }),
//               );
//             },
//           ),
//           ListReservationHistory(
//               title: 'Food Delivery',
//               sub:
//                   'Purus scelerisque arcu convallis sit ornare. Vel aliquet est nisi, bibendum',
//               press: () {}),
//         ]),
//       );
// }

// class ListReservationHistory extends StatelessWidget {
//   final String title;
//   final String sub;
//   final VoidCallback press;
//   const ListReservationHistory({
//     Key? key,
//     required this.title,
//     required this.sub,
//     required this.press,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return ListTile(
//       onTap: press,
//       leading: Container(
//         padding: EdgeInsets.all(2),
//         decoration: BoxDecoration(
//             border: Border.all(
//               color: Colors.yellow.shade700,
//             ),
//             borderRadius: BorderRadius.all(Radius.circular(50))),
//         child: CircleAvatar(
//             backgroundColor: Colors.white,
//             radius: 25,
//             backgroundImage: AssetImage(
//               'assets/images/logo_onboarding_2.png',
//             )),
//       ),
//       title: Text(
//         title,
//         style: text1,
//       ),
//       subtitle: Text(sub, style: text2),
//     );
//   }
// }
