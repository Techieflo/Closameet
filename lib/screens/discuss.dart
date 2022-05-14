import 'dart:io';

import 'package:closameet/api/discussdao.dart';
import 'package:closameet/api/post.dart';
import 'package:closameet/constant.dart';
import 'package:closameet/widget/discussionwidget.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

class Discuss extends StatefulWidget {
  const Discuss({Key? key}) : super(key: key);

  @override
  State<Discuss> createState() => _DiscussState();
}

class _DiscussState extends State<Discuss> {
  File? imagefile;
  String imageurl = '';
  final dateTime = DateTime.now();
  TextEditingController textcontrol = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              icon: const Icon(
                Icons.delete,
                color: Colors.blue,
              ),
              onPressed: () {
                DatabaseReference referenceData =
                    FirebaseDatabase.instance.ref('discussion');
                referenceData.remove();
              })
        ],
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0.134,
        title: const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            "Discussion",
            style: TextStyle(
                fontSize: 22, fontWeight: FontWeight.bold, color: Colors.blue),
          ),
        ),
      ),
      bottomNavigationBar: Container(
          margin: EdgeInsets.all(15.0),
          height: 61,
          child: Row(
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(35.0),
                    boxShadow: const [
                      BoxShadow(
                          offset: Offset(0, 3),
                          blurRadius: 5,
                          color: Colors.grey)
                    ],
                  ),
                  child: Row(
                    children: [
                      const SizedBox(
                        width: 19,
                      ),
                      Expanded(
                        child: TextField(
                          controller: textcontrol,
                          decoration: const InputDecoration(
                              hintText: "Start a discussion...",
                              hintStyle: TextStyle(color: Colors.blueAccent),
                              border: InputBorder.none),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.photo_camera,
                            color: Colors.blueAccent),
                        onPressed: () {
                          showdialog(context);
                        },
                      ),
                      // IconButton(
                      //   icon: const Icon(Icons.attach_file,
                      //       color: Colors.blueAccent),
                      //   onPressed: () {},
                      // )
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 15),
              Container(
                padding: const EdgeInsets.all(15.0),
                decoration: const BoxDecoration(
                    color: Colors.blueAccent, shape: BoxShape.circle),
                child: InkWell(
                    child: const Icon(
                      Icons.send_rounded,
                      color: Colors.white,
                    ),
                    onTap: () async {
                      if (imageurl == null) {
                        setState(() {
                          imageurl = "";
                        });
                      }
                      final post = Post(textcontrol.text.toString().trim(),
                          dateTime.toString(), name, imageurl);

                      upload(post);
                      textcontrol.text = '';
                    }),
              )
            ],
          )),
      body: Column(
        children: [
          Container(
            child: Expanded(
              child: FirebaseAnimatedList(
                defaultChild: Padding(
                  padding: const EdgeInsets.all(40.0),
                  child: Center(
                    child: Column(
                      children: const [
                        CircularProgressIndicator(),
                        Text(
                          "Fetching Chat",
                          style: TextStyle(color: Colors.blue),
                        )
                      ],
                    ),
                  ),
                ),
                query: getdiscuss(),
                itemBuilder: (context, snapshot, animation, index) {
                  final json = snapshot.value as Map<dynamic, dynamic>;
                  final message = Post.fromJson(json);
                  // return Container(
                  //   child: Column(
                  //     children: [
                  //       Text(message.date),
                  //       Text(message.postdesc),
                  //       Text(message.sender)
                  //     ],
                  //   ),
                  // );
                  return Discusswidget(
                    message.postdesc,
                    message.date.substring(1, 16),
                    message.sender,
                    message.imgurl,
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
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
    setState(() {
      imageurl = imageUrl;
    });
    showToast("image selected");
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
    setState(() {
      imageurl = imageUrl;
    });
    showToast('image selected');
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
                      onTap: opencamera),
                ],
              ),
            ),
          );
        });
  }

  Future<void> upload(Post post) async {
    // FirebaseStorage storage = FirebaseStorage.instance;
    // Reference ref = storage.ref().child("images" + DateTime.now().toString());
    // await ref.putFile(File(imagefile!.path));
    // String imageUrl = await ref.getDownloadURL();
    // imageurl = imageUrl;
    // print(imageurl);

    DatabaseReference dbref =
        FirebaseDatabase.instance.ref().child("discussion");
    String? uploadid = dbref.push().key;
    dbref.child(uploadid!).set(post.tojson());

    showToast(" Sent!");

    // } else {
    //   showToast('An error occured! Please try again');
    // }
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
