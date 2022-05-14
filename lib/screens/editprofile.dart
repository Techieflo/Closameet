import 'package:closameet/screens/homepage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'homebody.dart';

class Editprofile extends StatefulWidget {
  const Editprofile({Key? key}) : super(key: key);

  @override
  State<Editprofile> createState() => _EditprofileState();
}

class _EditprofileState extends State<Editprofile> {
  String email = "", password = "", name = '', adress = '', phonenumber = '';
  TextEditingController username_control = TextEditingController();
  TextEditingController email_control = TextEditingController();
  TextEditingController adress_control = TextEditingController();
  TextEditingController phonenumber_control = TextEditingController();
  var formkey = GlobalKey<FormState>();
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
  void initState() {
    super.initState();
    getname();
    getemail();
    getadress();
    getphonenumber();
  }

  @override
  Widget build(BuildContext context) {
    username_control.text = name;
    email_control.text = email;
    adress_control.text = adress;
    phonenumber_control.text = phonenumber;
    return Scaffold(
      body: Form(
        key: formkey,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: MediaQuery.of(context).size.height * 0.16),
                const Text(
                  "Edit Profile",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  margin: const EdgeInsets.only(top: 16.0),
                  //user name text field
                  child: TextFormField(
                    controller: username_control,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Please enter a username";
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                        enabledBorder: const OutlineInputBorder(
                            borderRadius: BorderRadius.zero,
                            borderSide: BorderSide(color: Colors.transparent)),
                        focusedBorder: const OutlineInputBorder(
                            borderRadius: BorderRadius.zero,
                            borderSide: BorderSide(color: Colors.blue)),
                        hintText: "User Name",
                        fillColor: Colors.grey[200],
                        filled: true,
                        prefixIcon: const Icon(Icons.person)),
                  ),
                ),

                // Email text field
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  margin: const EdgeInsets.only(top: 16.0),
                  child: TextFormField(
                    controller: email_control,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Please enter your Email Adress";
                      } else if (!value.contains("@")) {
                        return "Please Enter a valid email adress";
                      }
                      return null;
                    },
                    onSaved: (value) {
                      email = value!;
                    },
                    decoration: InputDecoration(
                        enabledBorder: const OutlineInputBorder(
                            borderRadius: BorderRadius.zero,
                            borderSide: BorderSide(color: Colors.transparent)),
                        focusedBorder: const OutlineInputBorder(
                            borderRadius: BorderRadius.zero,
                            borderSide: BorderSide(color: Colors.blue)),
                        hintText: "Email Adress",
                        fillColor: Colors.grey[200],
                        filled: true,
                        prefixIcon: const Icon(Icons.mail)),
                  ),
                ),
                // password field
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  margin: const EdgeInsets.only(top: 16.0),
                  child: TextFormField(
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Please enter an address";
                        }
                        return null;
                      },
                      controller: adress_control,
                      decoration: InputDecoration(
                          enabledBorder: const OutlineInputBorder(
                              borderRadius: BorderRadius.zero,
                              borderSide:
                                  BorderSide(color: Colors.transparent)),
                          focusedBorder: const OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(20.0),
                              ),
                              borderSide: BorderSide(color: Colors.blue)),
                          hintText: "Address",
                          fillColor: Colors.grey[200],
                          filled: true,
                          prefixIcon: const Icon(Icons.location_pin))),
                ),
                // phone number
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  margin: const EdgeInsets.only(top: 16.0),
                  child: TextFormField(
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Please, Enter your phone number";
                      }
                      return null;
                    },
                    onSaved: (value) {
                      password = value!;
                    },
                    controller: phonenumber_control,
                    decoration: InputDecoration(
                      enabledBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.zero,
                          borderSide: BorderSide(color: Colors.transparent)),
                      focusedBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.zero,
                          borderSide: BorderSide(color: Colors.blue)),
                      hintText: "Enter your phone number",
                      fillColor: Colors.grey[200],
                      filled: true,
                      prefixIcon: const Icon(Icons.phone),
                    ),
                  ),
                ),
                //sign up button
                Container(
                  margin: const EdgeInsets.all(20),
                  decoration: const BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.zero,
                  ),
                  width: double.infinity,
                  child: FlatButton(
                    child: const Text(
                      "Save Changes",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    onPressed: () async {
                      if (formkey.currentState!.validate()) {
                        //write firstname
                        DocumentReference ref = FirebaseFirestore.instance
                            .collection("Users")
                            .doc(FirebaseAuth.instance.currentUser?.uid)
                            .collection("UserName")
                            .doc("firstname");
                        FirebaseFirestore.instance
                            .runTransaction((transaction) async {
                          DocumentSnapshot snapshot =
                              await transaction.get(ref);
                          if (!snapshot.exists) {
                            ref.set({
                              "firstname":
                                  username_control.text.toString().trim()
                            });
                          } else {
                            ref.update(
                              {
                                "firstname":
                                    username_control.text.toString().trim()
                              },
                            );
                          }
                        });
                        //reset email
                        resetEmail(email_control.text.toString().trim());
                        // write adress

                        DocumentReference refer = FirebaseFirestore.instance
                            .collection("Users")
                            .doc(FirebaseAuth.instance.currentUser?.uid)
                            .collection("UserName")
                            .doc("adress");
                        FirebaseFirestore.instance
                            .runTransaction((transaction) async {
                          DocumentSnapshot snapshot =
                              await transaction.get(refer);
                          if (!snapshot.exists) {
                            refer.set(
                              {"adress": adress_control.text.toString().trim()},
                            );
                          } else {
                            refer.update(
                              {"adress": adress_control.text.toString().trim()},
                            );
                          }
                        });

//write phone number
                        DocumentReference reference = FirebaseFirestore.instance
                            .collection("Users")
                            .doc(FirebaseAuth.instance.currentUser?.uid)
                            .collection("UserName")
                            .doc("phonenumber");
                        FirebaseFirestore.instance
                            .runTransaction((transaction) async {
                          DocumentSnapshot snapshot =
                              await transaction.get(reference);
                          if (!snapshot.exists) {
                            reference.set(
                              {
                                "phonenumber":
                                    phonenumber_control.text.toString().trim()
                              },
                            );
                          } else {
                            reference.update(
                              {
                                "phonenumber":
                                    phonenumber_control.text.toString().trim()
                              },
                            );
                          }
                        });
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const Home()));
                      } else {
                        showToast("Error Updating details");
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future resetEmail(String newEmail) async {
    var message;
    var firebaseUser = await FirebaseAuth.instance.currentUser;
    firebaseUser!
        .updateEmail(newEmail)
        .then(
          (value) => message = 'Success',
        )
        .catchError((onError) => message = 'error');
    print(message);
    return message;
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

  getemail() {
    var mail = FirebaseAuth.instance.currentUser!.email;
    setState(() {
      email = mail.toString();
    });
  }
}

register() {}
