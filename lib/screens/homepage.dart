import 'package:closameet/api/data.dart';
import 'package:closameet/api/post.dart';
import 'package:closameet/api/postdao.dart';
import 'package:closameet/constant.dart';
import 'package:closameet/screens/addpost.dart';
import 'package:closameet/screens/profile.dart';
import 'package:closameet/widget/postwidget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';

class Homebody extends StatefulWidget {
  const Homebody({
    Key? key,
  }) : super(key: key);

  @override
  State<Homebody> createState() => _HomebodyState();
}

class _HomebodyState extends State<Homebody> {
  int _index = 0;

  bool isgreencolor = false;
  late int index;
  String email = '';
  String profileimg = '';
  List<Data> datalist = [];
  TextEditingController passcontrol = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  @override
  void initState() {
    super.initState();
    getname();
    getprofilepic();
    getemail();
    DatabaseReference referenceData = FirebaseDatabase.instance.ref('posts');

    referenceData.once().then((DatabaseEvent event) {
      datalist.clear();
      var keys = event.snapshot.key;
      var values = event.snapshot.value;
    });
  }

  @override
  Widget build(BuildContext context) {
    passcontrol.text = email;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 10, right: 10, top: 20),
          child: Stack(
            children: [
              Container(
                  child: Column(
                children: [
                  Row(children: [
                    GestureDetector(
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Profile())),
                      child: CircleAvatar(
                          radius: 20,
                          backgroundImage: profileimg == ''
                              ? const AssetImage(
                                  "assets/images/onBoardScreenImage2.png",
                                )
                              : NetworkImage(
                                  profileimg,
                                ) as ImageProvider),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: Colors.black),
                        ),
                      ],
                    ),
                  ]),
                  //search bar

                  const SizedBox(
                    height: 20,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const Addpost(),
                          ));
                    },
                    child: Container(
                      margin: const EdgeInsets.only(right: 5, left: 5),
                      height: 50,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          color: const Color.fromARGB(70, 170, 170, 170),
                          borderRadius: BorderRadius.circular(15)),
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Create New post.....",
                            ),
                            IconButton(
                                onPressed: () {},
                                icon: const Icon(Icons.image,
                                    color: Colors.grey, size: double.infinity))
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              )),
              Container(
                margin: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.16, left: 5),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: const [
                          Text(
                            "Recent Stories...",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      //scrollable horizontal view
                      // SizedBox(height: 15),
                      Container(
                        child: Expanded(
                          child: FirebaseAnimatedList(
                            defaultChild: Column(
                              children: const [
                                CircularProgressIndicator(),
                                Text(
                                  "Fetching Posts",
                                  style: TextStyle(color: Colors.blue),
                                )
                              ],
                            ),
                            query: getposts(),
                            itemBuilder: (context, snapshot, animation, index) {
                              var json =
                                  snapshot.value as Map<dynamic, dynamic>;
                              var message = Post.fromJson(json);
                              // return Container(
                              //   child: Column(
                              //     children: [
                              //       Text(message.date),
                              //       Text(message.postdesc),
                              //       Text(message.sender)
                              //     ],
                              //   ),
                              // );

                              return GestureDetector(
                                onTap: () {
                                  // FirebaseDatabase.instance
                                  //     .ref()
                                  //     .child('post')
                                  //     .child(FirebaseAuth
                                  //         .instance.currentUser!.uid)
                                  //     .remove();
                                },
                                child: Postwidget(
                                    message.postdesc,
                                    message.date.substring(1, 16),
                                    message.sender,
                                    message.imgurl),
                              );
                            },
                          ),
                        ),
                      )
                    ]),
              )
            ],
          ),
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   child: const Icon(Icons.add),
      //   onPressed: (() => Navigator.push(
      //         context,
      //         MaterialPageRoute(
      //           builder: (context) => const Addpost(),
      //         ),
      //       )),
      // ),
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

  Future<void> showdialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text(
              "Reset Password",
              style: TextStyle(fontSize: 16),
            ),
            content: SingleChildScrollView(
              child: ListBody(
                children: [
                  TextField(
                    controller: passcontrol,
                  ),
                  GestureDetector(
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        "Send password Reset Link",
                        style: TextStyle(
                            color: Colors.blue,
                            fontSize: 18,
                            fontStyle: FontStyle.normal),
                      ),
                    ),
                    onTap: () {
                      FirebaseAuth.instance.sendPasswordResetEmail(
                          email: passcontrol.text.toString().trim());

                      Navigator.pop(context);
                      showToast(
                          "Password reset link has been sent to your Email");
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

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

  getemail() {
    var mail = FirebaseAuth.instance.currentUser!.email;
    setState(() {
      email = mail.toString();
    });
  }
}
