import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

// Widget Discusswidget(
//     String postdesc, String date, String sender, String imgurl, double size) {
//   return Padding(
//     padding: const EdgeInsets.all(8.0),
//     child: GestureDetector(
//       onDoubleTap: (() {
//         remove();
//       }),
//       child: Container(
//         decoration: const BoxDecoration(
//             color: Colors.blue,
//             borderRadius: BorderRadius.all(
//               Radius.circular(60.0),
//             )),
//         margin: const EdgeInsets.all(1.0),
//         padding: const EdgeInsets.all(10),
//         child: Padding(
//           padding: const EdgeInsets.all(10.0),
//           child: Column(children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.start,
//               children: [
//                 Text(
//                   sender,
//                   style: const TextStyle(
//                       color: Color.fromARGB(255, 2, 43, 77),
//                       fontWeight: FontWeight.bold,
//                       fontSize: 14),
//                 ),
//               ],
//             ),
//             const SizedBox(
//               height: 8,
//             ),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.start,
//               children: [
//                 Expanded(
//                   child: Text(
//                     postdesc,
//                     maxLines: 20,
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(
//               height: 2,
//             ),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.end,
//               children: [
//                 Container(
//                   child: Text(
//                     date,
//                     style: const TextStyle(
//                       color: Color.fromARGB(255, 79, 77, 77),
//                       fontSize: 11,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             const Divider(
//               thickness: 0.1,
//               color: Colors.blue,
//             ),
//           ]),
//         ),
//       ),
//     ),
//   );
// }

Widget Discusswidget(
    String postdesc, String date, String sender, String imgurl) {
  late bool like = true;
  return Card(
    elevation: 1,
    margin: const EdgeInsets.all(2),
    color: Colors.blue,
    child: Container(
      color: Colors.white,
      margin: const EdgeInsets.all(1.5),
      padding: const EdgeInsets.all(10),
      child: Column(children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              sender,
              style: const TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                  fontSize: 14),
            ),
          ],
        ),
        const Divider(
          height: 0.3,
          color: Color.fromARGB(255, 96, 175, 240),
        ),
        CachedNetworkImage(
          imageUrl: imgurl,
          placeholder: (context, url) => const CircularProgressIndicator(),
          errorWidget: (context, url, error) => const Icon(
            Icons.error,
            color: Colors.transparent,
          ),
        ),
        const SizedBox(
          height: 1,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              child: Text(
                postdesc,
                maxLines: 20,
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 1,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              child: Text(
                date,
                style: const TextStyle(
                  color: Color.fromARGB(255, 79, 77, 77),
                  fontSize: 11,
                ),
              ),
            ),
          ],
        ),
        const Divider(
          thickness: 0.1,
          color: Colors.blue,
        ),
      ]),
    ),
  );
}

void showToast(String message) {
  Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.blue,
      textColor: Colors.white);
}

void remove() {}
