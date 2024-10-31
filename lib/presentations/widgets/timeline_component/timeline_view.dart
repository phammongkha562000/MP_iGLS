// // ignore_for_file: public_member_api_docs, sort_constructors_first
// import 'package:flutter/material.dart';

// class TimelineWidget extends StatelessWidget {
//   const TimelineWidget({
//     Key? key,
//     required this.titleLst,
//   }) : super(key: key);
//   final List<String> titleLst;
//   @override
//   Widget build(BuildContext context) {
//     return Expanded(
//       child: ListView.builder(
//         scrollDirection: Axis.horizontal,
//         itemCount: titleLst.length,
//         itemBuilder: (context, index) {
//           return TimelineItem(
//             isFirst: index == 0,
//             isLast: index == titleLst.length - 1,
//             title: titleLst[index],
//             description: 'Description of event $index',
//           );
//         },
//       ),
//     );
//   }
// }

// class TimelineItem extends StatelessWidget {
//   final bool isFirst;
//   final bool isLast;
//   final String title;
//   final String description;

//   TimelineItem(
//       {required this.isFirst,
//       required this.isLast,
//       required this.title,
//       required this.description});

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       children: [
//         Column(
//           children: [
//             // Dòng nối trước Circle (chỉ hiện nếu không phải là item đầu tiên)
//             if (!isFirst)
//               Expanded(child: Container(width: 2, color: Colors.grey)),
//             // Circle tượng trưng cho sự kiện
//             Container(
//               width: 20,
//               height: 20,
//               decoration: BoxDecoration(
//                 color: Colors.blue,
//                 shape: BoxShape.circle,
//               ),
//             ),
//             // Dòng nối sau Circle (chỉ hiện nếu không phải là item cuối cùng)
//             if (!isLast)
//               Expanded(child: Container(width: 2, color: Colors.grey)),
//           ],
//         ),
//         SizedBox(width: 10), // Khoảng cách giữa Circle và nội dung
//         Expanded(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 title,
//                 style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
//               ),
//               Text(
//                 description,
//                 style: TextStyle(fontSize: 14, color: Colors.grey),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }
