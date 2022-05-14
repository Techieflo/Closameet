import 'dart:io';
import 'package:closameet/screens/editprofile.dart';
import 'package:closameet/screens/login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:firebase_storage/firebase_storage.dart';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  File? imagefile;
  String imageurl = '';
  String name = '';
  String email = '';
  String phonenumber = '';
  String adress = '';
  String profileimg = '';

  var auth = FirebaseAuth.instance;
  @override
  void initState() {
    super.initState();
    getname();
    getprofilepic();
    getname();
    getemail();

    getadress();
    getphonenumber();
  }

  getemail() {
    var mail = FirebaseAuth.instance.currentUser!.email;
    setState(() {
      email = mail.toString();
    });
  }

  getadress() async {
    var document = FirebaseFirestore.instance
        .collection('Users')
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .collection('UserName');
    var collection = FirebaseFirestore.instance.collection('users');
    var docSnapshot = await document.doc('adress').get();
    if (docSnapshot.exists) {
      Map<String, dynamic>? data = docSnapshot.data();

      var value = data?['adress']; // <-- The value you want to retrieve.
      // Call setState if needed.
      setState(() {
        adress = value;
      });
    }
  }

  getphonenumber() async {
    var document = FirebaseFirestore.instance
        .collection('Users')
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .collection('UserName');
    var collection = FirebaseFirestore.instance.collection('users');
    var docSnapshot = await document.doc('phonenumber').get();
    if (docSnapshot.exists) {
      Map<String, dynamic>? data = docSnapshot.data();

      var value = data?['phonenumber']; // <-- The value you want to retrieve.
      // Call setState if needed.
      setState(() {
        phonenumber = value;
      });
    }
  }

  Future<void> logout() async {
    await auth.signOut();

    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const Login()));
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0.134,
        title: const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            "Profile",
            style: TextStyle(
                fontSize: 22, fontWeight: FontWeight.bold, color: Colors.blue),
          ),
        ),
      ),
      body: Stack(children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 20,
            ),
            GestureDetector(
              onTap: () {
                showdialog(context);
              },
              child: Center(
                child: CircleAvatar(
                    radius: 100,
                    backgroundImage: profileimg == ''
                        ? const AssetImage(
                            "assets/images/onBoardScreenImage2.png",
                          )
                        : NetworkImage(
                            profileimg,
                          ) as ImageProvider),
              ),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    SizedBox(
                      width: 10,
                    ),
                    // Text.rich(TextSpan(
                    //   text: ' Welcome',
                    //   style: TextStyle(
                    //       fontSize: 20,
                    //       fontWeight: FontWeight.bold,
                    //       fontFamily: 'Roboto'),
                    //   children: <InlineSpan>[
                    //     TextSpan(
                    //       text: ' Olaniyan',
                    //       style: TextStyle(
                    //           color: Colors.blue,
                    //           fontSize: 20,
                    //           fontWeight: FontWeight.bold),
                    //     )
                    //   ],
                    // )),
                    SizedBox(
                      width: 10,
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(
              height: MediaQuery.of(context).size.height * 0.5,
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: ListView(children: [
                  ListTile(
                    onTap: () {},
                    leading: const Icon(
                      Icons.person,
                      color: Colors.blue,
                    ),
                    title: Text(
                      name,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          fontFamily: 'Roboto',
                          color: Colors.black.withOpacity(.6)),
                    ),
                  ),
                  ListTile(
                    onTap: () {},
                    leading: const Icon(
                      Icons.mail_outline,
                      color: Colors.blue,
                    ),
                    title: Text(
                      FirebaseAuth.instance.currentUser!.email.toString(),
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          fontFamily: 'Roboto',
                          color: Colors.black.withOpacity(.7)),
                    ),
                  ),
                  ListTile(
                    onTap: () {},
                    leading: const Icon(
                      Icons.location_pin,
                      color: Colors.blue,
                    ),
                    title: Text(
                      adress,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          fontFamily: 'Roboto',
                          color: Colors.black.withOpacity(.7)),
                    ),
                  ),
                  ListTile(
                    onTap: () {},
                    leading: const Icon(
                      Icons.phone,
                      color: Colors.blue,
                    ),
                    title: Text(
                      phonenumber,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          fontFamily: 'Roboto',
                          color: Colors.black.withOpacity(.7)),
                    ),
                  ),
                  const SizedBox(
                    height: 0,
                  ),
                  Container(
                    margin: const EdgeInsets.all(10),
                    decoration: const BoxDecoration(
                      color: Colors.blue,
                      // borderRadius: BorderRadius.circular(20.0)
                    ),
                    width: double.infinity,
                    child: FlatButton(
                      child: const Text(
                        "Edit Profile",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18),
                      ),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Editprofile()));
                      },
                    ),
                  ),
                  // const SizedBox(),
                  // FlatButton(
                  //     onPressed: () {},
                  //     child: const Text(
                  //       "LOG OUT",
                  //       style: TextStyle(
                  //         fontWeight: FontWeight.bold,
                  //         color: Colors.blue,
                  //       ),
                  //     ))
                ]),
              ),
            ),
            // Container(
            //   color: Colors.black,
            // ),
          ],
        ),
        Positioned(
            left: 0,
            right: 0,
            bottom: 0.0,
            child: FlatButton(
                onPressed: () async {
                  Future success = logout();
                  logout();
                },
                child: const Text(
                  "LOG OUT",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                )))
      ]),
    );
  }

  getname() async {
    var document = FirebaseFirestore.instance
        .collection('Users')
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .collection('UserName');
    var collection = FirebaseFirestore.instance.collection('users');
    var docSnapshot = await document.doc('firstname').get();
    if (docSnapshot.exists) {
      Map<String, dynamic>? data = docSnapshot.data();

      var value = data?['firstname']; // <-- The value you want to retrieve.
      // Call setState if needed.
      setState(() {
        name = value;
      });
    }
  }

  Future<void> upload() async {
    FirebaseStorage storage = FirebaseStorage.instance;
    Reference ref = storage.ref().child("images" + DateTime.now().toString());
    await ref.putFile(File(imagefile!.path));
    String imageUrl = await ref.getDownloadURL();
    imageurl = imageUrl;
    print(imageurl);
    setState(() {
      imageurl = imageUrl;
    });

    // DatabaseReference dbref = FirebaseDatabase.instance.ref().child("posts");
    // String? uploadid = dbref.push().key;
    // dbref.child(uploadid!).set(post.tojson());

    showToast("Post created successfully");
  }

  Future<void> opengallery() async {
    var picture = await ImagePicker().pickImage(source: ImageSource.gallery);
    setState(() {
      imagefile = File(picture!.path);
    });
    FirebaseStorage storage = FirebaseStorage.instance;
    Reference ref = storage.ref().child("images" + DateTime.now().toString());
    await ref.putFile(File(imagefile!.path));
    String imageUrl = await ref.getDownloadURL();
    imageurl = imageUrl;
    DocumentReference refer = FirebaseFirestore.instance
        .collection("Users")
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .collection("UserName")
        .doc("profileimg");
    FirebaseFirestore.instance.runTransaction((transaction) async {
      DocumentSnapshot snapshot = await transaction.get(refer);
      if (!snapshot.exists) {
        refer.set(
          {"profileimg": imageurl},
        );
      } else {
        refer.update(
          {"profileimg": imageurl},
        );
      }
    });
  }

  Future<void> opencamera() async {
    var picture = await ImagePicker().pickImage(source: ImageSource.camera);
    setState(() {
      imagefile = File(picture!.path);
    });
    FirebaseStorage storage = FirebaseStorage.instance;
    Reference ref = storage.ref().child("images" + DateTime.now().toString());
    await ref.putFile(File(imagefile!.path));
    String imageUrl = await ref.getDownloadURL();
    imageurl = imageUrl;
  }

  Future<void> showdialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Choose image from?"),
            content: SingleChildScrollView(
              child: ListBody(
                children: [
                  GestureDetector(
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        "Gallery",
                        style: TextStyle(
                            fontSize: 18, fontStyle: FontStyle.normal),
                      ),
                    ),
                    onTap: opengallery,
                  ),
                  GestureDetector(
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        "Camera",
                        style: TextStyle(
                            fontSize: 18, fontStyle: FontStyle.normal),
                      ),
                    ),
                    onTap: opencamera,
                  ),
                ],
              ),
            ),
          );
        });
  }

  // Future<Position> _getLocation() async {
  //   var currentLocation;
  //   // try {
  //   //   currentLocation = await geolocator.getCurrentPosition(
  //   //       desiredAccuracy: LocationAccuracy.best);
  //   // } catch (e) {
  //   //   currentLocation = null;
  //   }
  //   // return currentLocation;
  // // }
  // }
  // Future<Position> _determinePosition() async {
  //   bool serviceEnabled;
  //   LocationPermission permission;

  //   serviceEnabled = await Geolocator.isLocationServiceEnabled();
  //   if (!serviceEnabled) {
  //     return Future.error('Location services are disabled.');
  //   }

  //   permission = await Geolocator.checkPermission();
  //   if (permission == LocationPermission.denied) {
  //     permission = await Geolocator.requestPermission();
  //     if (permission == LocationPermission.denied) {
  //       return Future.error('Location permissions are denied');
  //     }
  //   }

  //   if (permission == LocationPermission.deniedForever) {
  //     return Future.error(
  //         'Location permissions are permanently denied, we cannot request permissions.');
  //   }

  //   print(Geolocator.getCurrentPosition().toString);
  //   showToast(Geolocator.getCurrentPosition().toString());
  //   return await Geolocator.getCurrentPosition();
  // }
  getprofilepic() async {
    var document = FirebaseFirestore.instance
        .collection('Users')
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .collection('UserName');
    var collection = FirebaseFirestore.instance.collection('users');
    var docSnapshot = await document.doc('profileimg').get();
    if (docSnapshot.exists) {
      Map<String, dynamic>? data = docSnapshot.data();

      var value = data?['profileimg']; // <-- The value you want to retrieve.
      // Call setState if needed.

      setState(() {
        profileimg = value;
      });
      print(profileimg);
    }
  }
}
