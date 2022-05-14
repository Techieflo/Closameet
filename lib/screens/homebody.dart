import 'dart:io';

import 'package:closameet/screens/discuss.dart';
import 'package:closameet/screens/homepage.dart';

import 'package:closameet/screens/profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String? user = FirebaseAuth.instance.currentUser?.email.toString();
  int selectedindex = 0;
  int _index = 0;
  bool isgreencolor = false;
  late int index;
  @override
  void initState() {
    super.initState();
    checkconnection();
  }

  @override
  Widget build(BuildContext context) {
    List<StatefulWidget> widgetsOptions = [
      const Homebody(),
      const Discuss(),
      const Profile(),
    ];

    return Scaffold(
        body: widgetsOptions[selectedindex],
        bottomNavigationBar: BottomNavigationBar(
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: "Home",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.messenger),
              label: "Discuss",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: "Profile",
            ),
          ],
          currentIndex: selectedindex,
          onTap: onitemtaped,
          showUnselectedLabels: false,
        ));
  }

  void onitemtaped(int value) {
    setState(() {
      selectedindex = value;
    });
  }

  checkconnection() async {
    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        showToast("Connected!");
      }
    } on SocketException catch (_) {
      showdialog(context);
    }
  }

  Future<void> showdialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text(
              "No internet Connection!",
              style: TextStyle(fontSize: 16),
            ),
            content: SingleChildScrollView(
              child: ListBody(
                children: [
                  GestureDetector(
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        "Ok",
                        style: TextStyle(
                            fontSize: 18, fontStyle: FontStyle.normal),
                      ),
                    ),
                    onTap: () {
                      SystemNavigator.pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
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
}
