import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

Widget Postwidget(String postdesc, String date, String sender, String imgurl) {
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
          errorWidget: (context, url, error) => const Icon(Icons.error),
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
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
                onPressed: () {
                  like = true;
                  showToast("like");
                },
                icon: Icon(
                  Icons.thumb_up_outlined,
                  color: like ? Colors.blue : null,
                )),
            IconButton(
              icon: const Icon(
                Icons.chat_outlined,
              ),
              onPressed: () {
                showToast('feature to be added soon');
              },
            ),
            IconButton(
              icon: const Icon(Icons.share_outlined),
              onPressed: () {
                showToast("Shared successfully");
              },
            ),
          ],
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
