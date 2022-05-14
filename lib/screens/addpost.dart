import 'dart:io';
import 'package:closameet/api/post.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:date_time_format/date_time_format.dart';
import 'package:image_picker/image_picker.dart';

class Addpost extends StatefulWidget {
  const Addpost({Key? key}) : super(key: key);

  @override
  State<Addpost> createState() => _AddpostState();
}

class _AddpostState extends State<Addpost> {
  File? imagefile;
  @override
  void initState() {
    super.initState();

    getname();
  }

  final dateTime = DateTime.now();

  var formkey = GlobalKey<FormState>();
  String post = '';
  String imageurl = '';
  String name = '';

  TextEditingController postcontrol = TextEditingController();

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
    var curtime = (DateTimeFormat.format(dateTime, format: 'D, M j, H:i'));
    var dlang = dateTime.toString().length;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0.134,
        title: const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            "Create New post",
            style: TextStyle(
                fontSize: 22, fontWeight: FontWeight.bold, color: Colors.blue),
          ),
        ),
      ),
      body: Form(
        key: formkey,
        child: Center(
            child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 15),
            ),
            Row(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * .65,
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  margin: const EdgeInsets.only(top: 16.0, bottom: 10),
                  child: TextFormField(
                    decoration: InputDecoration(
                      enabledBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.zero,
                          borderSide: BorderSide(color: Colors.transparent)),
                      focusedBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.zero,
                          borderSide: BorderSide(color: Colors.blue)),
                      hintText: "Create New post",
                      fillColor: Colors.grey[200],
                      filled: true,
                      // prefixIcon: const Icon(Icons.mail)....
                    ),
                    controller: postcontrol,
                    textAlign: TextAlign.start,
                    keyboardType: TextInputType.multiline,
                    maxLines: 5,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "You cannot create an empty post";
                      } else if (value.length == 1) {
                        return "lenght of post must be greater than one";
                      }
                    },
                  ),
                ),
                Container(
                  decoration: const BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.zero,
                  ),
                  child: FlatButton(
                      minWidth: 10,
                      height: 80,
                      padding: const EdgeInsets.all(16),
                      child: const Text(
                        "Create post",
                        style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                      onPressed: () async {
                        if (imagefile == null) {
                          showToast("please select an image");
                        } else {
                          FirebaseStorage storage = FirebaseStorage.instance;
                          Reference ref = storage
                              .ref()
                              .child("images" + DateTime.now().toString());
                          await ref.putFile(File(imagefile!.path));
                          String imageUrl = await ref.getDownloadURL();
                          setState(() {
                            imageurl = imageUrl;
                          });

                          final post = Post(postcontrol.text.toString().trim(),
                              dateTime.toString(), name, imageurl);
                          upload(post);
                          Navigator.of(context).pop();
                        }
                      }),
                ),
              ],
            ),
            Row(
              children: [
                Container(
                  child: imagefile == null
                      ? Container()
                      : Image.file(
                          imagefile!,
                          width: 100,
                          height: 100,
                        ),
                ),
                FlatButton(
                    onPressed: () {
                      showdialog(context);
                    },
                    child: const Icon(
                      Icons.photo_camera_rounded,
                      size: 50,
                      color: Colors.blue,
                    )),
              ],
            ),
          ],
        )),
      ),
    );
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

  Future<void> opengallery() async {
    var picture = await ImagePicker().pickImage(source: ImageSource.gallery);
    setState(() {
      imagefile = File(picture!.path);
    });
  }

  Future<void> opencamera() async {
    var picture = await ImagePicker().pickImage(source: ImageSource.camera);
    setState(() {
      imagefile = File(picture!.path);
    });
  }

  Future<void> upload(Post post) async {
    if (formkey.currentState!.validate()) {
      FirebaseStorage storage = FirebaseStorage.instance;
      Reference ref = storage.ref().child("images" + DateTime.now().toString());
      await ref.putFile(File(imagefile!.path));
      String imageUrl = await ref.getDownloadURL();
      imageurl = imageUrl;
      print(imageurl);

      DatabaseReference dbref = FirebaseDatabase.instance.ref().child("posts");
      String? uploadid = dbref.push().key;
      dbref.child(uploadid!).set(post.tojson());

      showToast("Post created successfully");
    } else {
      showToast('An error occured! Please try again');
    }

    // Reference ref = FirebaseStorage.instance
    //     .ref()
    //     .child("images")
    //     .child((DateTime.now().millisecondsSinceEpoch.toString()));
    // UploadTask uploadtask = ref.putFile(File(imagefile!.path));

    // uploadtask.then((res) {
    //   res.ref.getDownloadURL();

    //   showToast(imageurl);
    // });
  }
  //     uploadtask.whenComplete(() async {
  //       try {
  //         String url = (await ref.getDownloadURL());
  //         imageurl = url;
  //         setState(() {
  //           imageurl = url.toString();
  //         });
  //       } catch (e) {
  //         showToast(e.toString());
  //       }

  //       print(imageurl);
  //     });

  //     DatabaseReference dbref = FirebaseDatabase.instance.ref().child("posts");
  //     String? uploadid = dbref.push().key;

  //     dbref.child(uploadid!).set(post.tojson());

  //     showToast("successful!");
  //   } else {
  //     showToast('An error occured! Please try again');
  //   }
  // }

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

  bool open() {
    opengallery();
    return true;
  }
}
